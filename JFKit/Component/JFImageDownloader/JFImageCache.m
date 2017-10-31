//
//  JFImageCache.m
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+Format.h"

// 图片在Library/Caches目录下的子目录名
static NSString* const JFImageCacheDirectory = @"com.JFImageDownloader.ImageCache";

@interface JFImageCache()
@property (nonatomic, strong) NSCache* cache; // 缓存
@property (nonatomic, strong) NSFileManager* fileManager; // 文件管理器
@property (nonatomic, strong) dispatch_queue_t ioQueue; // 文件IO队列:同步or异步?
@end

@implementation JFImageCache


# pragma mark : interface

+ (instancetype)sharedCache {
    static JFImageCache* imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [JFImageCache new];
    });
    return imageCache;
}

- (void)storeImage:(UIImage *)image
         imageData:(NSData *)imageData
           withKey:(NSString *)key
      cacheOptions:(NSInteger)cacheOptions
      onCompletion:(JFBlockNonParams)completion
{
    if (!image || !key) {
        if (completion) {
            completion();
        }
        return;
    }
    __weak typeof(self) wself = self;
    // 如果有图片则缓存图片
    if (self.config.shouldSaveInNSCache) {
        // NSCache是线程安全的
        [self.cache setObject:image forKey:key cost:[self imageCost:image]];
    }
    // 如果有数据则保存数据到disk
    if (self.config.shouldSaveInDisk) {
        dispatch_async(self.ioQueue, ^{
            // 没有data就用image创建data
            NSData* data = imageData;
            if (!data) {
                data = [wself imageDataForImage:image];
            }
            // 没有创建目录就创建目录
            NSString* imageDirectory = [wself imageCacheDirectory];
            if (![wself.fileManager fileExistsAtPath:imageDirectory]) {
                [wself.fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            // 创建文件，并写入data
            [wself.fileManager createFileAtPath:[wself cacheFullPathForKey:key] contents:data attributes:nil];
            // 完成回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        });
    } else {
        // 完成回调
        if (completion) {
            completion();
        }
    }
}

- (NSOperation *)queryImageWithKey:(NSString *)key onCompletion:(JFBlockDownloadCompletion)completion
{
    if (!key || key.length == 0) {
        if (completion) {
            completion(nil, nil);
        }
        return nil;
    }
    //
    __weak typeof(self) wself = self;
    NSOperation* operation = [NSOperation new];
    dispatch_async(self.ioQueue, ^{
        @autoreleasepool {
            if (operation.isCancelled) {
                return ;
            }
            // 从cache中读取image
            UIImage* image = [wself.cache objectForKey:key];
            
            if (operation.isCancelled) {
                return ;
            }
            // 从硬盘中读取data
            NSData* imageData = [self getImageDataFromDiskWithKey:key];
            
            if (operation.isCancelled) {
                return ;
            }
            // 如果cache中没有，而self.config.shouldSaveInCache == YES,则再次保存image到cache中
            if (!image && imageData && wself.config.shouldSaveInNSCache) {
                image = [imageData jf_makeImage];
                NSUInteger imageCost = 0;
                if ([imageData jf_imageFormat] == JFImageFormatPNG) {
                    imageCost = image.size.width * image.scale * image.size.height * image.scale;
                } else {
                    imageCost = image.size.width * image.size.height;
                }
                [wself.cache setObject:image forKey:key cost:imageCost];
            }
            
            // 查询完毕就可以回调了
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image, imageData);
                });
            }
            
        }
    });
    return operation;
}

- (NSInteger) diskCacheSize {
    NSString* cacheDirectory = [self imageCacheDirectory];
    NSDirectoryEnumerator* directoryEnum = [self.fileManager enumeratorAtPath:cacheDirectory];
    NSInteger size = 0;
    for (NSString* fileName in directoryEnum) {
        NSString* fullPath = [cacheDirectory stringByAppendingPathComponent:fileName];
        NSDictionary* fileAttri = [self.fileManager attributesOfItemAtPath:fullPath error:NULL];
        size += [fileAttri fileSize];
    }
    return size;
}

- (void) clearCachesOnFinished:(JFBlockNonParams)finishedBlock {
    [self.cache removeAllObjects];
    
    __weak typeof(self) wself = self;
    dispatch_async(self.ioQueue, ^{
        NSString* cacheDirectory = [wself imageCacheDirectory];
        [wself.fileManager removeItemAtPath:cacheDirectory error:nil];
        [wself.fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        if (finishedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedBlock();
            });
        }
    });
}


# pragma mark : 目录
// 图片目录
- (NSString*) imageCacheDirectory {
    NSString* cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingPathComponent:JFImageCacheDirectory];
}

// key经过MD5加密后的文件名
- (NSString*) cacheFileNameMD5WithKey:(NSString*)key {
    const char* str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString* extension = key.pathExtension.length > 0 ? [NSString stringWithFormat:@".%@", key.pathExtension] : @"";
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@", r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9],r[10],r[11],r[12],r[13],r[14],r[15],extension];
}
// key对应的全路径文件名
- (NSString*) cacheFullPathForKey:(NSString*)key {
    NSString* md5Name = [self cacheFileNameMD5WithKey:key];
    return [[self imageCacheDirectory] stringByAppendingPathComponent:md5Name];
}
# pragma mark : 保存

# pragma mark : 查询

// 根据key从cache目录中取出文件数据
- (NSData*) getImageDataFromDiskWithKey:(NSString*)key {
    NSString* fullPath = [self cacheFullPathForKey:key];
    return [NSData dataWithContentsOfFile:fullPath];
}

# pragma mark : 工具
// 计算图片实际大小(byte)
- (NSUInteger) imageCost:(UIImage*)image {
    return image.size.width * image.scale * image.size.height * image.scale;
}

// 由图片生成图片数据
- (NSData*) imageDataForImage:(UIImage*)image {
    return [image jf_imageDataAsFormat:JFImageFormatUndefined];
}

# pragma mark : life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // 创建缓存并配置
        _cache = [NSCache new];
        _cache.name = JFImageCacheDirectory;
        // 创建文件管理器并配置
        _fileManager = [NSFileManager new];
        // 创建并初始化缓存配置
        _config = [JFImageCacheConfig new];
        // 文件IO队列:先用异步试下
        _ioQueue = dispatch_queue_create(JFImageCacheDirectory.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


@end


@implementation JFImageCacheConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        _maxCacheSize = 0;
        _shouldSaveInDisk = YES;
        _shouldSaveInNSCache = YES;
    }
    return self;
}
@end

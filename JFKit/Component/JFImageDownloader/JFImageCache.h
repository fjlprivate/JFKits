//
//  JFImageCache.h
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFImageDownloadMacro.h"

/* 缓存配置 */
@interface JFImageCacheConfig : NSObject

@property (nonatomic, assign) NSInteger maxCacheSize; // 最大缓存大小
@property (nonatomic, assign) BOOL shouldSaveInNSCache; // 是否缓存到NSCache
@property (nonatomic, assign) BOOL shouldSaveInDisk; // 是否缓存到硬盘

@end




/**
 * # 图片缓存类 #
 * 下载的图片默认进行缓存，同时缓存在NSCache和Library/Caches下面;
 * 也可以通过配置属性，指定只缓存NSCache或Library/Caches，或都不缓存;
 */

@interface JFImageCache : NSObject

+ (instancetype) sharedCache;

// 缓存配置
@property (nonatomic, strong, readonly) JFImageCacheConfig* config;

/**
 缓存图片和图片数据

 @param image 缓存的图片;
 @param imageData 要缓存的图片数据;
 @param key 图片键名;
 @param cacheOptions 缓存参数:暂时没用到;
 @param completion 缓存完毕的回调;
 */
- (void) storeImage:(UIImage*)image
          imageData:(NSData*)imageData
            withKey:(NSString*)key
       cacheOptions:(NSInteger)cacheOptions
       onCompletion:(JFBlockNonParams)completion;




/**
 从缓存中读取图片和图片数据;

 @param key 图片键名;
 @param completion 查询完毕的回调;同时回调UIImage+NSData
 @return operation;可以在外部用来停止查询操作;避免多余的内存消耗;
 */
- (NSOperation*) queryImageWithKey:(NSString*)key onCompletion:(JFBlockDownloadCompletion)completion;



/**
 获取缓存空间大小;

 @return 缓存大小;
 */
- (NSInteger) diskCacheSize;


/**
 清空缓存;

 @param finishedBlock 清空完毕的回调;
 */
- (void) clearCachesOnFinished:(JFBlockNonParams)finishedBlock;

@end




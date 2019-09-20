//
//  JFVideoPathHelper.m
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import "JFVideoPathHelper.h"
#import <Photos/Photos.h>

@implementation JFVideoPathHelper

// 当前时间的视频全路径:(Tmp/yyyyMMddHHmmss.mp4)
+ (NSString*) videoPathForCurTime {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* curTime = [dateFormatter stringFromDate:[NSDate date]];
    NSString* videoPath = [self videoPathForSaving];
    NSString* fullPath = [videoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", curTime]];
    return fullPath;
}

// 存放视频的目录:(Tmp)
+ (NSString*) videoPathForSaving {
//    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* tmpDocumentPath = NSTemporaryDirectory();
    NSString* videoDirectoryName = JFVideoDirectoryName;
    NSString* fullPath = [tmpDocumentPath stringByAppendingPathComponent:videoDirectoryName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fullPath]) {
        [fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return fullPath;
}

// 视频目录下的所有视频名字
+ (NSDirectoryEnumerator*) allVideoNamesInDisk {
    NSDirectoryEnumerator* directoryEnum = [[NSFileManager defaultManager] enumeratorAtPath:[self videoPathForSaving]];
    return directoryEnum;
}

// 删除指定url的视频文件
+ (void) removeVideoWithURL:(NSURL*)url {
    if (url) {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
}


// 清理视频目录(暂时不删除相册中的视频)
+ (void) clearAllVideosInDisk {
    NSString* videoDirectory = [self videoPathForSaving];
    for (NSString* videoName in [self allVideoNamesInDisk]) {
        [[NSFileManager defaultManager] removeItemAtPath:[videoDirectory stringByAppendingPathComponent:videoName] error:nil];
    }
}


// 保存视频到相册
+ (void) savingVideoIntoAlbumWithURL:(NSURL*)url completionHandler:(void (^) (BOOL success, NSError * _Nullable error))completionHandler{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        if (@available(iOS 9.0, *)) {
            PHAssetCreationRequest* creationRequest = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:url];
            PHAssetCollection* assetCollection = [self videoAssetCollection];
            PHAssetCollectionChangeRequest* collectionChangeRequest = nil;
            if (assetCollection) {
                collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            } else {
                collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:[self curAppName]];
            }
            [collectionChangeRequest addAssets:@[creationRequest.placeholderForCreatedAsset]];
        } else {
            // Fallback on earlier versions
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(success, error);
        }
    }];
}


# pragma mark - tools

// 获取视频目录集
+ (PHAssetCollection*) videoAssetCollection {
    PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection* assetCollection in result) {
        if ([assetCollection.localizedTitle isEqualToString:[self curAppName]]) {
            return assetCollection;
        }
    }
    return nil;
}

// 获取当前app的名称
+ (NSString*) curAppName {
    NSDictionary* appInfo = [[NSBundle mainBundle] infoDictionary];
    return [appInfo objectForKey:@"CFBundleDisplayName"];
}

@end

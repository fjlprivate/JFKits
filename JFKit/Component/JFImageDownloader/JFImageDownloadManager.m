//
//  JFImageDownloadManager.m
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFImageDownloadManager.h"

@implementation JFImageDownloadManager

+ (instancetype)sharedManager {
    static JFImageDownloadManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [JFImageDownloadManager new];
    });
    return manager;
}

- (void)jf_loadImageWithURL:(NSURL *)url
                 onProgress:(JFBlockDownloadProgress)progressBlock
               onCompletion:(JFBlockDownloadCompletion)completionBlock
                     onFail:(JFBlockDownloadError)failBlock
{
    NSString* key = url.absoluteString;
    // 从缓存中查询图片
    [[JFImageCache sharedCache] queryImageWithKey:key onCompletion:^(UIImage *image, NSData *imageData) {
        // 查询到则回调
        if (image && imageData) {
            if (progressBlock) {
                NSInteger totalSize = imageData.length;
                progressBlock(totalSize, totalSize);
            }
            if (completionBlock) {
                completionBlock(image, imageData);
            }
        } else {
            // 没查询到就从网页下载
            [[JFImageDownloader sharedDownloader] jf_imageDownloadingWithURL:url onProgress:^(NSInteger received, NSInteger totalSize) {
                if (progressBlock) {
                    progressBlock(received, totalSize);
                }
            } onCompletion:^(UIImage *image, NSData *imageData) {
                // 下载完毕，将图片回调出去
                if (completionBlock) {
                    completionBlock(image, imageData);
                }
                // 并将图片缓存到本地
                [[JFImageCache sharedCache] storeImage:image imageData:imageData withKey:key cacheOptions:0 onCompletion:^{
                    
                }];
            } orError:^(NSError *error) {
                if (failBlock) {
                    failBlock(error);
                }
            }];
        }
    }];
}


@end

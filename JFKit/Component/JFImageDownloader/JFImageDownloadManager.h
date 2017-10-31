//
//  JFImageDownloadManager.h
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFImageDownloader.h"
#import "JFImageCache.h"

@interface JFImageDownloadManager : NSObject

+ (instancetype) sharedManager;


/**
 加载图片，指定url;
 先从缓存中获取图片，没有获取到再从web获取;

 @param url 图片url;
 @param progressBlock 进度回调;
 @param completionBlock 加载完毕回调;
 @param failBlock 加载失败回调;
 */
- (void) jf_loadImageWithURL:(NSURL*)url onProgress:(JFBlockDownloadProgress)progressBlock onCompletion:(JFBlockDownloadCompletion)completionBlock onFail:(JFBlockDownloadError)failBlock;



@end

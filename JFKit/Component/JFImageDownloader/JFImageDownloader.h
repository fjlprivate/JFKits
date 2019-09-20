//
//  JFImageDownloader.h
//  TestForOperation
//
//  Created by johnny feng on 2017/9/20.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFImageDownloadMacro.h"

@interface JFImageDownloader : NSObject


/**
 获取公共下载器入口;

 @return 公共下载器;
 */
+ (instancetype) sharedDownloader;

// 超时时间;默认15s;
@property (nonatomic, assign) NSTimeInterval downloadTimeOut;


/**
 启动下载;可以同时启动多个，但是默认最大并发6个;
 添加流程:现在NSCache中查找,
         然后在bundle中查找,最终查不到才进行下载;
         下载完毕后,要讲数据保存到本地;

 @param url 下载url;
 @param progressBlock 进度回调;
 @param completionBlock 下载完成回调;
 @param errorBlock 下载失败回调;
 */
- (void) jf_imageDownloadingWithURL:(NSURL*)url onProgress:(JFBlockDownloadProgress)progressBlock onCompletion:(JFBlockDownloadCompletion)completionBlock orError:(JFBlockDownloadError)errorBlock;


/**
 取消下载操作;

 @param url 指定url;
 */
- (void) cancelWithUrl:(NSURL*)url;

@end

//
//  JFImageDownloadOperation.h
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/12.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFImageDownloadMacro.h"


/**
 * 封装下载任务到NSOperation
 * 在外部通过加载operation到NSOperationQueue中，启动异步的下载任务；
 * 在外部也可以进行cancel取消下载操作;
 */
@interface JFImageDownloadOperation : NSOperation <NSURLSessionDelegate,NSURLSessionDataDelegate>

- (instancetype) initWithURLRequest:(NSURLRequest*)urlRequest andURLSession:(NSURLSession*)urlSession;


// 下载成功的回调
@property (nonatomic, copy) JFBlockDownloadCompletion downloadCompletionBlock;
// 下载进度回调
@property (nonatomic, copy) JFBlockDownloadProgress downloadProgressBlock;
// 下载失败的回调
@property (nonatomic, copy) JFBlockDownloadError downloadFailBlock;

@end

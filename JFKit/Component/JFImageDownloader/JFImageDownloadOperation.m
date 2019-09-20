//
//  JFImageDownloadOperation.m
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/12.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFImageDownloadOperation.h"
#import "JFImageDownloadMacro.h"



@interface JFImageDownloadOperation()

@property (nonatomic, copy) NSURLRequest* urlRequest;
@property (nonatomic, weak)   NSURLSession* unownURLSession;        // 外部的session
@property (nonatomic, strong) NSURLSession* ownURLSession;          // 内部创建的session
@property (nonatomic, strong) NSURLSessionDataTask* dataTask;       // 下载的task
@property (nonatomic, assign) NSInteger expectedSize;               // 预计下载的大小
@property (nonatomic, strong) NSMutableData* imageData;             // 保存下载图片数据的
@property (nonatomic, assign) JFImageDownloadState state;           // 状态

@end

@implementation JFImageDownloadOperation




# pragma mark : NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    // 要么没有statusCode;要么statusCode < 400 && != 304
    if (![response performSelector:@selector(statusCode)] || (((NSHTTPURLResponse*)response).statusCode < 400 && ((NSHTTPURLResponse*)response).statusCode != 304) ) {
        self.expectedSize = response.expectedContentLength;
        self.imageData = [NSMutableData dataWithCapacity:self.expectedSize];
        [self willChangeValueForKey:@"isExecuting"];
        self.state = JFImageDownloadStateExecuting;
        [self willChangeValueForKey:@"isExecuting"];
    } else {
        [self callBackWithError:[NSError errorWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@"链接服务器失败"}]];
        [self willChangeValueForKey:@"isFinished"];
        self.state = JFImageDownloadStateFailed;
        [self willChangeValueForKey:@"isFinished"];
        disposition = NSURLSessionResponseCancel;
        [self reset];
    }
    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    [self callBackWithReceived:self.imageData.length totalSize:self.expectedSize];
    if (self.imageData.length >= self.expectedSize) {
        UIImage* image = [UIImage imageWithData:self.imageData];
        [self callBackWithCompletion:image imageData:self.imageData];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler
{
    
}

# pragma mark : tools

// 处理回调
- (void) callBackWithError:(NSError*)error {
    if (self.downloadFailBlock) {
        self.downloadFailBlock(error);
    }
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = JFImageDownloadStateFailed;
    [self didChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    [self reset];
}
- (void) callBackWithCompletion:(UIImage*)image imageData:(NSData*)imageData {
    if (self.downloadCompletionBlock) {
        self.downloadCompletionBlock(image, imageData);
    }
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = JFImageDownloadStateDone;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    [self reset];
}
- (void) callBackWithReceived:(NSInteger)received totalSize:(NSInteger)totalSize {
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(received, totalSize);
    }
}


# pragma mark : life cycle

- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest andURLSession:(NSURLSession *)urlSession {
    self = [super init];
    if (self) {
        self.urlRequest = urlRequest;
        self.unownURLSession = urlSession;
    }
    return self;
}

- (void)start {
    if (!self.urlRequest) {
        return;
    }
    // 初始化下载的配置
    if (self.unownURLSession) {
        self.dataTask = [self.unownURLSession dataTaskWithRequest:self.urlRequest];
    } else {
        self.ownURLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.dataTask = [self.ownURLSession dataTaskWithRequest:self.urlRequest];
    }
    // 执行下载
    [self.dataTask resume];
}

- (void)cancel {
    [super cancel];
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isCancelled"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = JFImageDownloadStateCanceled;
    [self didChangeValueForKey:@"isCancelled"];
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
    [self reset];
}

- (void) reset {
    self.imageData = nil;
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    if (self.ownURLSession) {
        [self.ownURLSession invalidateAndCancel];
        self.ownURLSession = nil;
    }

}

- (BOOL)isFinished {
    return self.state == JFImageDownloadStateDone || self.state == JFImageDownloadStateCanceled || self.state == JFImageDownloadStateFailed;
}
- (BOOL)isExecuting {
    return self.state == JFImageDownloadStateExecuting;
}
- (BOOL)isCancelled {
    return self.state == JFImageDownloadStateCanceled;
}





# pragma mark : NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session API_AVAILABLE(ios(7.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos) {
    
}


@end

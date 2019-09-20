//
//  JFImageDownloader.m
//  TestForOperation
//
//  Created by johnny feng on 2017/9/20.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFImageDownloader.h"
#import "JFImageDownloadOperation.h"

static NSString* const JFDownloadBlockNameCompletion    = @"JFDownloadBlockNameCompletion";
static NSString* const JFDownloadBlockNameFail          = @"JFDownloadBlockNameFail";
static NSString* const JFDownloadBlockNameProgress      = @"JFDownloadBlockNameProgress";


@interface JFImageDownloader() <NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession* urlSession; // 下载管理器
@property (nonatomic, strong) NSOperationQueue* operationQueue; // 用来处理下载的operation异步的
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableDictionary*>* callBacksDic; // 保存回调的字典
@property (nonatomic, strong) NSMutableDictionary<NSString*, JFImageDownloadOperation*>* operationsDic; // 保存operation的字典

@end

@implementation JFImageDownloader


# pragma mark : interface

+ (instancetype) sharedDownloader {
    static JFImageDownloader* downloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [JFImageDownloader new];
    });
    return downloader;
}


- (void) jf_imageDownloadingWithURL:(NSURL*)url
                         onProgress:(JFBlockDownloadProgress)progressBlock
                       onCompletion:(JFBlockDownloadCompletion)completionBlock
                            orError:(JFBlockDownloadError)errorBlock
{
    if (self.operationsDic[url.absoluteString]) {
        // 如果重复了，要不要更新回调??
        return;
    }
    [self saveCallBacksWithURL:url completion:completionBlock fail:errorBlock progress:progressBlock];
    __weak typeof(self) wself = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:self.downloadTimeOut];
    JFImageDownloadOperation* downloadOperation = [[JFImageDownloadOperation alloc] initWithURLRequest:request andURLSession:self.urlSession];
    downloadOperation.downloadCompletionBlock = ^(UIImage *image, NSData *imageData) {
        [wself callBackCompletionWithImage:image imageData:imageData forUrl:url];
    };
    downloadOperation.downloadFailBlock = ^(NSError *error) {
        [wself callBackFailWithError:error forUrl:url];
    };
    downloadOperation.downloadProgressBlock = ^(NSInteger receivedSize, NSInteger totalSize) {
        [wself callBackProgressWithReceived:receivedSize totalSize:totalSize forUrl:url];
    };
    downloadOperation.completionBlock = ^{
        [wself removeDownloadOperationForUrl:url];
    };
    self.operationsDic[url.absoluteString] = downloadOperation;
    [self.operationQueue addOperation:downloadOperation];
}

- (void)cancelWithUrl:(NSURL *)url {
    JFImageDownloadOperation* operation = self.operationsDic[url.absoluteString];
    if (operation) {
        [operation cancel];
    }
    [self removeDownloadOperationForUrl:url];
}

# pragma mark : tools

// 保存回调
- (void) saveCallBacksWithURL:(NSURL*)url
                   completion:(JFBlockDownloadCompletion)completionBlock
                         fail:(JFBlockDownloadError)failBlock
                     progress:(JFBlockDownloadProgress)progressBlock
{
    NSMutableDictionary* callBackDic = [self.callBacksDic objectForKey:url.absoluteString];
    if (callBackDic) {
        if (completionBlock) callBackDic[JFDownloadBlockNameCompletion] = completionBlock;
        if (failBlock) callBackDic[JFDownloadBlockNameFail] = failBlock;
        if (progressBlock) callBackDic[JFDownloadBlockNameProgress] = progressBlock;
    } else {
        callBackDic = @{}.mutableCopy;
        if (completionBlock) callBackDic[JFDownloadBlockNameCompletion] = completionBlock;
        if (failBlock) callBackDic[JFDownloadBlockNameFail] = failBlock;
        if (progressBlock) callBackDic[JFDownloadBlockNameProgress] = progressBlock;
        self.callBacksDic[url.absoluteString] = callBackDic;
    }
}


// 回调: 成功
- (void) callBackCompletionWithImage:(UIImage*)image imageData:(NSData*)imageData forUrl:(NSURL*)url{
    NSMutableDictionary* dic = self.callBacksDic[url.absoluteString];
    if (dic) {
        JFBlockDownloadCompletion comp = dic[JFDownloadBlockNameCompletion];
        if (comp) {
            dispatch_async(dispatch_get_main_queue(), ^{
                comp(image, imageData);
            });
        }
    }
}
// 回调: 失败
- (void) callBackFailWithError:(NSError*)error forUrl:(NSURL*)url{
    NSMutableDictionary* dic = self.callBacksDic[url.absoluteString];
    if (dic) {
        JFBlockDownloadError failBlock = dic[JFDownloadBlockNameFail];
        if (failBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failBlock(error);
            });
        }
    }
}
// 回调: 进度
- (void) callBackProgressWithReceived:(NSInteger)received totalSize:(NSInteger)totalSize forUrl:(NSURL*)url{
    NSMutableDictionary* dic = self.callBacksDic[url.absoluteString];
    if (dic) {
        JFBlockDownloadProgress progress = dic[JFDownloadBlockNameProgress];
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(received, totalSize);
            });
        }
    }
}

// 移除字典operation
- (void) removeDownloadOperationForUrl:(NSURL*)url {
    [self.operationsDic removeObjectForKey:url.absoluteString];
}

# pragma mark : NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential* credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (completionHandler) {
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session API_AVAILABLE(ios(7.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos) {
}

# pragma mark : NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    JFImageDownloadOperation* operation = self.operationsDic[dataTask.originalRequest.URL.absoluteString];
    if (operation) {
        [operation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    JFImageDownloadOperation* operation = self.operationsDic[dataTask.originalRequest.URL.absoluteString];
    if (operation) {
        [operation URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    JFImageDownloadOperation* operation = self.operationsDic[dataTask.originalRequest.URL.absoluteString];
    if (operation) {
        [operation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
    }
}

# pragma mark : life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.downloadTimeOut = 15;
    }
    return self;
}

# pragma mark : getter

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 6;
    }
    return _operationQueue;
}

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _urlSession;
}
- (NSMutableDictionary<NSString *,NSMutableDictionary *> *)callBacksDic {
    if (!_callBacksDic) {
        _callBacksDic = @{}.mutableCopy;
    }
    return _callBacksDic;
}
- (NSMutableDictionary<NSString *, JFImageDownloadOperation *> *)operationsDic {
    if (!_operationsDic) {
        _operationsDic = @{}.mutableCopy;
    }
    return _operationsDic;
}

@end

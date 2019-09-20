//
//  ShortMediaDownloader.m
//  ShortMediaCacheDemo
//
//  Created by dangercheng on 2018/8/7.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import "ShortMediaDownloader.h"
#import "ShortMediaDownloadOperation.h"

#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define UnLock() dispatch_semaphore_signal(self.lock)

@interface ShortMediaDownloader()<NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *operationCache;

@property (nonatomic, strong) dispatch_semaphore_t lock;
@end

@implementation ShortMediaDownloader

+ (instancetype)shareDownloader {
    static ShortMediaDownloader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ShortMediaDownloader alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(!self) return nil;
    _lock = dispatch_semaphore_create(1);
    _queue = [NSOperationQueue new];
    _operationCache = [NSMutableDictionary dictionary];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    return self;
}

- (void)downloadMediaWithUrl:(NSURL *)url
                     options:(ShortMediaOptions)options
                    progress:(ShortMediaProgressBlock)progress
                  completion:(ShortMediaCompletionBlock)completion {
    [self downloadMediaWithUrl:url options:options preload:NO progress:progress completion:completion];
}

- (void)preloadMediaWithUrl:(NSURL *)url
                    options:(ShortMediaOptions)options
                   progress:(ShortMediaProgressBlock)progress
                 completion:(ShortMediaCompletionBlock)completion {
    [self downloadMediaWithUrl:url options:options preload:YES progress:progress completion:completion];
}

// 加载和预加载的都走这个方法
- (void)downloadMediaWithUrl:(NSURL *)url
                     options:(ShortMediaOptions)options
                     preload:(BOOL)preload
                    progress:(ShortMediaProgressBlock)progress
                  completion:(ShortMediaCompletionBlock)completion {
    BOOL cached = [[ShortMediaCache shareCache] isCacheCompletedWithUrl:url];
    if(cached) {
        NSInteger fileSize = [[ShortMediaCache shareCache] finalCachedSizeWithUrl:url];
        if(progress) progress(fileSize, fileSize);
        if(completion) completion(nil);
        return;
    }
    
    // 先取消当前的下载
    [self cancelDownloadWithUrl:url];
    // 获取当前已经缓存的大小，如果有缓存
    NSInteger cachedSize = [[ShortMediaCache shareCache] cachedSizeWithUrl:url];
    // 并将缓存的大小设置到请求头的range
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *range = [NSString stringWithFormat:@"bytes=%ld-", (long)cachedSize];
    [downloadRequest setValue:range forHTTPHeaderField:@"Range"];
    downloadRequest.HTTPShouldHandleCookies = (options & ShortMediaOptionsHandleCookies);
    downloadRequest.HTTPShouldUsePipelining = YES;
    
    // 创建下载器
    __weak typeof(self) _self = self;
    ShortMediaDownloadOperation *downloadOperation = [[ShortMediaDownloadOperation alloc] initWithRequest:downloadRequest session:_session options:options progress:progress completion:^(NSError *error) {
        // 如果下载器被停止了，这里也会回调出去
        __strong typeof(_self) self = _self;
        if(!self) return;
        Lock();
        [self.operationCache removeObjectForKey:url];
        UnLock();
        if(completion) completion(error);
    }];
    // 如果有设置用户名|密码，则填写用户名密码
    if(_userName && _password) {
        downloadOperation.credential = [NSURLCredential credentialWithUser:_userName password:_password persistence:NSURLCredentialPersistenceForSession];
    }
    // 设置是否预加载属性
    downloadOperation.isPreloading = preload;
    Lock();
    // 不是预加载的:要将下载器缓存中的所有预加载的下载器移除
    if(!preload) {
        NSMutableArray *needCancelUrls = [NSMutableArray array];
        for (NSURL *url in _operationCache.allKeys) {
            ShortMediaDownloadOperation *operation = _operationCache[url];
            if(operation.isPreloading) {
                // 删除的请求要不要先d停止？？？？？
                [operation cancelOperation];
                [needCancelUrls addObject:url];
            }
        }
        for (NSURL *url in needCancelUrls) {
            [_operationCache removeObjectForKey:url];
        }
    }
    // 将创建的下载缓存到集合;因为是url:operation的键值对集合，所以如果段时间创建了2个下载，前面一个会被冲掉
    [_operationCache setObject:downloadOperation forKey:url];
    // 将下载事物添加到队列，就会启动下载
    [_queue addOperation:downloadOperation];
    UnLock();
}

- (void)cancelDownloadWithUrl:(NSURL *)url {
    if(!url) {
        return;
    }
    Lock();
    ShortMediaDownloadOperation *operation = [_operationCache objectForKey:url];
    if(operation) {
        [operation cancel];
        [_operationCache removeObjectForKey:url];
    }
    UnLock();
}
- (void)cancelAllDownloads {
    Lock();
    for (ShortMediaDownloadOperation* op in [_operationCache allValues]) {
        if ([op isKindOfClass:[ShortMediaDownloadOperation class]]) {
            [op cancel];
        }
    }
    [_operationCache removeAllObjects];
    UnLock();
}


- (BOOL)canPreload {
    BOOL retValue = YES;
    Lock();
    for (ShortMediaDownloadOperation *operation in self.operationCache.allValues) {
        if(!operation.isPreloading) {
            retValue = NO;
            break;
        }
    }
    UnLock();
    return retValue;
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    Lock();
    ShortMediaDownloadOperation *operation = [_operationCache objectForKey:task.originalRequest.URL];
    UnLock();
    if (operation.dataTask != task) {
        return;
    }
    [operation URLSession:session task:task didCompleteWithError:error];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    ShortMediaDownloadOperation *operation = [_operationCache objectForKey:task.originalRequest.URL];
    if (operation.dataTask != task) {
        return;
    }
    [operation URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    Lock();
    ShortMediaDownloadOperation *operation = [_operationCache objectForKey:dataTask.originalRequest.URL];
    UnLock();
    if (operation.dataTask != dataTask) {
        return;
    }
    [operation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    Lock();
    ShortMediaDownloadOperation *operation = [_operationCache objectForKey:dataTask.originalRequest.URL];
    UnLock();
    if (operation.dataTask != dataTask) {
        return;
    }
    [operation URLSession:session dataTask:dataTask didReceiveData:data];
}

@end

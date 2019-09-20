//
//  ShortMediaResourceLoader.m
//  ShortMediaCacheDemo
//
//  Created by dangercheng on 2018/7/30.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import "ShortMediaResourceLoader.h"
#import "AVAssetResourceLoadingDataRequest+ShortMediaCache.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ShortMediaResourceLoader()<AVAssetResourceLoaderDelegate>
@property (nonatomic, strong) NSMutableArray *pendingRequests;
@property (nonatomic, assign) NSInteger expectedSize;
@property (nonatomic, assign) NSInteger receivedSize;
@property (nonatomic, assign) ShortMediaOptions options;
@end

@implementation ShortMediaResourceLoader

- (instancetype)init {
    self = [super init];
    if(!self) return nil;
    _pendingRequests = [NSMutableArray array];
    return self;
}

- (instancetype)initWithDelegate:(id<ShortMediaResourceLoaderDelegate>)delegate {
    _delegate = delegate;
    return [self init];
}

- (AVPlayerItem *)playItemWithUrl:(NSURL *)url {
    return [self playItemWithUrl:url options:kNilOptions];
}

- (AVPlayerItem *)playItemWithUrl:(NSURL *)url options:(ShortMediaOptions)options {
    _url = url;
    _options = options;
    [self startLoading];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[self unRecognizerUrl] options:nil];
    [asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    return item;
}

// 开始加载数据
- (void)startLoading {
    __weak typeof(self) _self = self;
    // 开始加载视频数据
    [[ShortMediaManager shareManager] loadMediaWithUrl:_url options:_options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong typeof(_self) self = _self;
        if(!self) return;
        self.receivedSize = receivedSize;
        self.expectedSize = expectedSize;
        [self dealPendingRequests];
    } completion:^(NSError *error) {
        __strong typeof(_self) self = _self;
        if(!self) return;
        if(!error) {
            self.receivedSize = self.expectedSize;
        }
        [self dealPendingRequests];
    }];
}

// 停止加载数据
- (void)endLoading {
    [[ShortMediaManager shareManager] endLoadMediaWithUrl:_url];
}

- (void)dealloc {
    [self endLoading];
}

#pragma mark - AVAssetResourceLoaderDelegate
// AVPlayer在播放的时候，会分片请求播放数据
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (resourceLoader && loadingRequest) {
        // 重置数据请求的已接收到的响应数据的大小:0
        loadingRequest.dataRequest.respondedSize = 0;
        // 将这个请求添加到当前请求列表
        [self.pendingRequests addObject:loadingRequest];
        // 处理当前所有的请求列表
        [self dealPendingRequests];
    }
    return YES;
}

// 已取消请求的回调
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (!loadingRequest.isFinished) {
        [loadingRequest finishLoadingWithError:[self loaderCancelledError]];
    }
    // 已取消的要将请求从当前请求列表缓存中移除
    [self.pendingRequests removeObject:loadingRequest];
}

#pragma mark - private
// 每个请求，每次回调，都要来处理下数据
- (void)dealPendingRequests {
    NSMutableArray *finishedRequests = [NSMutableArray array];
    // 枚举所有的请求
    [self.pendingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * _Nonnull stop) {
        // 完善请求头信息
        [self fillInContentInformation:loadingRequest.contentInformationRequest];
        // 向下载器请求数据,并将请求到的数据传递给playerItem
        BOOL finish = [self respondWithDataForRequest:loadingRequest];
        // 当前次传递完毕了，要关闭请求
        if (finish) {
            [finishedRequests addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }];
    // 清理已完成的数据请求
    if (finishedRequests.count) {
        [self.pendingRequests removeObjectsInArray:finishedRequests];
    }
}

// 获取请求的数据回调;并返回是否请求到数据
- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 获取请求的数据加载器
    AVAssetResourceLoadingDataRequest *dataRequest = loadingRequest.dataRequest;
    // 发起请求数据的起始位置
    NSInteger startOffset = (NSInteger)dataRequest.requestedOffset;
    // 实际请求到的数据的起始位置:因为可能前面因为没有缓存的足够的数据，只响应了部分数据回去了，在下载的progress中需要继续进来处理
    if (dataRequest.currentOffset != 0) {
        startOffset = (NSInteger)dataRequest.currentOffset;
    }
    startOffset = MAX(0, startOffset);
    // 如果开始的位置大于已接收的数据的末尾，则返回没有数据,因为不支持seek(说明数据还在传输中,需要等待传输完毕)
    if(startOffset > _receivedSize) {
        return NO;
    }
    // 计算可以读取的数据大小：已接收到的数据大小 - 开始获取的位置
    NSInteger canReadsize = _receivedSize - startOffset;
    canReadsize = MAX(0, canReadsize);
    // 即将获取的真实的数据大小: 期望读取的数据大小 | 能读取的的数据大小 的最小值
    NSInteger realReadSize = MIN(dataRequest.requestedLength, canReadsize);
    NSData *respondData = [NSData data];
    // 数据大小必须大于2才能读取:因为前2个字节是视频的信息字节
    if(realReadSize > 2) {
        // 从缓存器中读取指定位置的指定大小的数据;每次调用都要对文件进行一次O操作
        NSData *cacheData = [[ShortMediaManager shareManager] cacheDataFromOffset:startOffset length:realReadSize withUrl:_url];
        if(cacheData) {
            respondData = cacheData;
            realReadSize = respondData.length;
        } else {
            realReadSize = 0;
        }
    }
    else {
        // 我们可以理解为:视频的实际数据中，每隔一段时间就会有2个字节的数据信息节点.
        // 一次请求的数据小于2byte时放弃掉么
//        realReadSize = 0;
    }
    dataRequest.respondedSize += realReadSize;
    [dataRequest respondWithData:respondData];
    //
    if(dataRequest.respondedSize >= dataRequest.requestedLength) {
        return YES;
    } else {
        // 实际请求到的数据比期望请求到的数据少:没下载够，等待继续下载
        return NO;
    }
}


/**
 完善请求头信息

 @param contentInformationRequest 内容信息请求
 */
- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest * _Nonnull)contentInformationRequest{
    // 请求有效才进入
    if (contentInformationRequest && !contentInformationRequest.contentType && _expectedSize > 0) {
        // 路径后缀
        NSString *fileExtension = [self.url pathExtension];
        //
        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
        NSString *contentTypeS = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
        if (!contentTypeS) {
            contentTypeS = @"application/octet-stream";
        }
        NSString *mimetype = contentTypeS;
        CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef _Nonnull)(mimetype), NULL);
        contentInformationRequest.byteRangeAccessSupported = YES;
        contentInformationRequest.contentType = CFBridgingRelease(contentType);
        contentInformationRequest.contentLength = _expectedSize;
    }
}

- (NSURL *)unRecognizerUrl {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:@"www.dandj.top"] resolvingAgainstBaseURL:NO];
    components.scheme = @"SystemCannotRecognition";
    return [components URL];
}

- (NSError *)loaderCancelledError{
    NSError *error = [[NSError alloc] initWithDomain:@"dandj.top"
                                                code:-3
                                            userInfo:@{NSLocalizedDescriptionKey:@"Resource loader cancelled"}];
    return error;
}

@end

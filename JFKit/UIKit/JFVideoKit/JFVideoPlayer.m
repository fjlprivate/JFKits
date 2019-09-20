//
//  JFVideoPlayer.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/24.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFVideoPlayer.h"
#import "JFMacro.h"
#import <UIKit/UIKit.h>
#import "ShortMediaResourceLoader.h"

// 通知键:状态
static NSString* const JFVideoPlayerKVOKeyStatus = @"status";
// 通知键:缓冲时间
static NSString* const JFVideoPlayerKVOKeyLoadedTime = @"loadedTimeRanges";

@interface JFVideoPlayer()
@property (nonatomic, strong) AVPlayer* avPlayer;
@property (nonatomic, strong) id playTimeObserver;
@property (nonatomic, assign) BOOL isNowPlaying;
@property (nonatomic, assign) BOOL isPlayingWhenEnterBg; // 记录进去后台前的播放状态
@property (nonatomic, strong) ShortMediaResourceLoader* resourceLoader; // 视频预加载器
@end

@implementation JFVideoPlayer
// 播放
- (void) play {
    if (self.status == JFVideoPlayStateReadToPlay ||
        self.status == JFVideoPlayStatePausing ||
        self.status == JFVideoPlayStateFinishing ||
        self.status == JFVideoPlayStateFailed)
    {
        self.status = JFVideoPlayStatePlaying;
        [self.avPlayer play];
    }
}
// 暂停
- (void) pause {
    if (self.status == JFVideoPlayStateFinishing ||
        self.status == JFVideoPlayStateFailed)
    {
        return;
    }
    self.status = JFVideoPlayStatePausing;
    [self.avPlayer pause];
}
// 更新进度
- (void) seekToTime:(NSTimeInterval)time {
    if (self.avPlayer) {
        [self.avPlayer seekToTime:CMTimeMake(time * 300, 300) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}


// 播放完毕了
- (void) playToEnd:(NSNotification*)noti {
    AVPlayerItem* curItem = noti.object;
    if (curItem != self.avPlayer.currentItem) {
        return;
    }
    if (self.playCircle) {
        [self.avPlayer seekToTime:kCMTimeZero];
        [self.avPlayer play];
    } else {
        self.status = JFVideoPlayStateFinishing;
    }
}

// 创建新的播放器
- (void) createNewPlayer {
    if (!self.video) {
        return;
    }
    if ([self.video isKindOfClass:[NSURL class]]) {
        // 设置状态
        self.status = JFVideoPlayStateWaiting;
        // 创建预加载器
        AVPlayerItem* playerItem = nil;
        if (self.shoulPreLoad) {
            self.resourceLoader = [ShortMediaResourceLoader new];
            playerItem = [self.resourceLoader playItemWithUrl:self.video];
        } else {
            playerItem = [AVPlayerItem playerItemWithURL:self.video];
        }
        // 监听播放状态
        [playerItem addObserver:self forKeyPath:JFVideoPlayerKVOKeyStatus options:0 context:nil];
        // 监听缓冲进度
        [playerItem addObserver:self forKeyPath:JFVideoPlayerKVOKeyLoadedTime options:0 context:nil];
        // 创建播放器
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
        // 关联播放界面
        if (self.playerLayer) {
            self.playerLayer.player = self.avPlayer;
        }
    }
}
// 释放旧的播放器
- (void) releaseLastPlayer {
    // 停止预加载
    if (self.resourceLoader) {
        [self.resourceLoader endLoading];
    }
    if (self.avPlayer) {
        // 移除playerItem的加载器的delegate
        AVURLAsset* asset = (AVURLAsset*)self.avPlayer.currentItem.asset;
        [asset.resourceLoader setDelegate:nil queue:dispatch_get_main_queue()];
        self.resourceLoader = nil;
        if (self.avPlayer.currentItem) {
            [self.avPlayer.currentItem removeObserver:self forKeyPath:JFVideoPlayerKVOKeyStatus];
            [self.avPlayer.currentItem removeObserver:self forKeyPath:JFVideoPlayerKVOKeyLoadedTime];
        }
        [self pause];
        [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
    }
}

// 激活播放监听
- (void) activateCirclePlayNoti {
    // 播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // app即将进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterFgModeNoti:) name:UIApplicationWillEnterForegroundNotification object:nil];
    // app即将进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBgModeNoti:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
// 注销播放监听
- (void) reactivateCirclePlayNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 处理APP进入后台
- (void) appDidEnterBgModeNoti:(NSNotification*)noti {
    self.isPlayingWhenEnterBg = self.status == JFVideoPlayStatePlaying;
    [self pause];
}
// 处理APP进入前台
- (void) appDidEnterFgModeNoti:(NSNotification*)noti {
    if (self.isPlayingWhenEnterBg) {
        [self play];
    }
}

# pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem* playerItem = object;
    if ([keyPath isEqualToString:JFVideoPlayerKVOKeyStatus]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            // 有可能是还未开始，状态就被置为pause了
            if (self.status != JFVideoPlayStateWaiting) {
                return;
            }
            self.status = JFVideoPlayStateReadToPlay;
            if (self.playAuto) {
                [self play];
            }
        }
        else if (playerItem.status == AVPlayerItemStatusFailed) {
            self.status = JFVideoPlayStateFailed;
        }
        else { // AVPlayerItemStatusUnknown
            self.status = JFVideoPlayStateWaiting;
        }
    }
    else if ([keyPath isEqualToString:JFVideoPlayerKVOKeyLoadedTime]) {
        NSArray* rangs = [playerItem loadedTimeRanges];
        CMTimeRange timeRange = [rangs[0] CMTimeRangeValue];
        NSTimeInterval loadedTime = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration));
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:preloadedTimeSecs:)]) {
            WeakSelf(wself);
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.delegate videoPlayer:wself preloadedTimeSecs:loadedTime];
            });
        }
    }
}



# pragma mark - life cycle
- (instancetype)initWithVideo:(id)video {
    self = [super init];
    if (self) {
        [self setupDatas];
        self.video = video;
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDatas];
    }
    return self;
}
- (void)dealloc {
    [self releaseLastPlayer];
    self.avPlayer = nil;
    [self reactivateCirclePlayNoti];
}

- (void) setupDatas {
    self.playCircle = YES;
    self.playAuto = YES;
    [self activateCirclePlayNoti];
}

# pragma mark - setter
// 设置|重置了视频源
- (void)setVideo:(id)video {
    _video = video;
    // 释放旧的播放
    [self releaseLastPlayer];
    // 创建新的播放器
    [self createNewPlayer];
}

- (void)setStatus:(JFVideoPlayState)status {
    _status = status;
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:didUpdateStatus:)]) {
        WeakSelf(wself);
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.delegate videoPlayer:wself didUpdateStatus:status];
        });
    }
}

- (void)setPlayerLayer:(AVPlayerLayer *)playerLayer {
    if (_playerLayer) {
        _playerLayer.player = nil;
    }
    _playerLayer = playerLayer;
    if (self.avPlayer) {
        if (_playerLayer) {
            _playerLayer.player = self.avPlayer;
        }
    }
}


# pragma mark - getter
- (AVPlayer *)avPlayer {
    if (!_avPlayer) {
        _avPlayer = [[AVPlayer alloc] init];
        WeakSelf(wself);
        // 监听播放时间
        self.playTimeObserver = [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 30)
                                                                        queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                                   usingBlock:^(CMTime time) {
                                                                       if (wself.status != JFVideoPlayStatePlaying) {
                                                                           return ;
                                                                       }
                                                                       if (wself.delegate && [wself.delegate respondsToSelector:@selector(videoPlayer:curPlayingTimeSecs:)]) {
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               [wself.delegate videoPlayer:wself curPlayingTimeSecs:CMTimeGetSeconds(time)];
                                                                           });
                                                                       }
                                                                   }];
    }
    return _avPlayer;
}

@end

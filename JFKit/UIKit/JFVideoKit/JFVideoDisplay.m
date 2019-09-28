//
//  JFVideoDisplay.m
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import "JFVideoDisplay.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
//#import <ReactiveCocoa.h>

#import "JFVideoDisplayHandles.h"
#import "JFMacro.h"
#import "JFVideoPlayer.h"


# pragma mark - 视频播放视图
@interface JFVideoDisplayContentView : UIView
@end



/****【JFVideoDisplay】****/

@interface JFVideoDisplay() <JFVideoPlayerDelegate>
// 播放视图
@property (nonatomic, strong) JFVideoDisplayContentView* displayView;

@property (nonatomic, strong) JFVideoDisplayHandles* vHandels;


// 播放控件;
@property (nonatomic, strong) JFVideoPlayer* player;
// 视频总时间(秒)
@property (nonatomic, assign) NSTimeInterval duration;
// 视频缓冲进度时间(秒)
@property (nonatomic, assign) NSTimeInterval preloadedTime;
// 视频播放进度时间(秒)
@property (nonatomic, assign) NSTimeInterval curTime;

// 手势动作
// 方向
@property (nonatomic, assign) UISwipeGestureRecognizerDirection panGesDirection;
// 开始滑动时的progressSecs
@property (nonatomic, assign) float panGesBeginProgessSecs;
@end

@implementation JFVideoDisplay

// 暂停
- (void) pause {
    [self.player pause];
    self.showHandleBtns = YES;
}
// 播放
- (void) play {
    [self.player play];
    WeakSelf(wself);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (wself.player.status == JFVideoPlayStatePlaying) {
            wself.showHandleBtns = NO;
        }
    });
}


# pragma mark - private


// 点击了播放按钮
- (IBAction) clickedPlayBtn:(id)sender {
    if (self.state == JFVideoPlayStatePlaying) {
        [self pause];
    } else {
        [self play];
    }
}

// 单击:显示|隐藏操作
- (IBAction) tapGesSingle:(UIGestureRecognizer*)sender {
    self.showHandleBtns = !self.showHandleBtns;
}
// 双击:暂停|播放
- (IBAction) tapGesDouble:(UIGestureRecognizer*)sender {
    if (self.state == JFVideoPlayStatePlaying) {
        [self.player pause];
    }
    else if (self.state == JFVideoPlayStatePausing ||
             self.state == JFVideoPlayStateReadToPlay ||
             self.state == JFVideoPlayStateFinishing)
    {
        [self.player play];
    }
}

// panGes拖动事件
- (IBAction) panGes:(UIPanGestureRecognizer*)sender {
    CGPoint transitionP = [sender translationInView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 水平方向；暂停播放
        if (fabs(transitionP.x) > fabs(transitionP.y)) {
            self.panGesDirection = transitionP.x > 0 ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft;
            self.panGesBeginProgessSecs = self.curTime;
            [self.player pause];
        }
        // 垂直方向
        else {
            self.panGesDirection = transitionP.y > 0 ? UISwipeGestureRecognizerDirectionDown : UISwipeGestureRecognizerDirectionUp;
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        // 如果是垂直方向的，移动距离超过了[n]就可以退出了
        // 垂直方向
        if (self.panGesDirection == UISwipeGestureRecognizerDirectionDown ||
            self.panGesDirection == UISwipeGestureRecognizerDirectionUp)
        {
            // 移动距离超过60就可以退出了
            if (fabs(transitionP.y) >= 60) {
                [self.player pause];
                if (self.cancelledBlock) {
                    self.cancelledBlock();
                }
            }
        }
        // 水平方向
        else {
//            float changeValue = transitionP.x / self.width * self.bottomBanner.slider.maximumValue;
//            if (self.panGesBeginProgessSecs + changeValue >= 0 &&
//                self.panGesBeginProgessSecs + changeValue <= self.bottomBanner.slider.maximumValue) {
//                [self.bottomBanner.slider setValue:self.panGesBeginProgessSecs + changeValue animated:YES];
//                [self.player seekToTime:CMTimeMake(self.bottomBanner.slider.value, 1)];
//            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        // 如果是水平滑动的，要恢复播放
        if (self.panGesDirection == UISwipeGestureRecognizerDirectionLeft ||
            self.panGesDirection == UISwipeGestureRecognizerDirectionRight )
        {
            [self.player play];
        }
    }
}




// 秒转时间: hh:mm:ss
- (NSString*) formatTimeWithSecs:(NSInteger)secs {
    NSInteger hour = secs/60/60;
    NSInteger min = secs/60%60;
    NSInteger sec = secs%60;
    if (hour > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, min, sec];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
    }
}

// 重置
- (void) setup {
    self.shouldCyclePlay = YES;
    self.shouldAutoPlay = YES;
    self.duration = 0;
    self.curTime = 0;
    self.preloadedTime = 0;
}

# pragma mark - JFVideoPlayerDelegate
/**
 状态更新
 @param videoPlayer             播放器
 @param status                  播放状态
 */
- (void) videoPlayer:(JFVideoPlayer*)videoPlayer didUpdateStatus:(JFVideoPlayState)status {
    self.state = status;
    if (status == JFVideoPlayStateFailed) {
        [self.vHandels showHandles];
    }
    else if (status == JFVideoPlayStateFinishing) {
        if (!videoPlayer.playCircle) {
            [self.vHandels showHandles];
        }
    }
}

/**
 播放进度
 @param videoPlayer             播放器
 @param curTimeSecs             当前已播放的秒数
 */
- (void) videoPlayer:(JFVideoPlayer*)videoPlayer curPlayingTimeSecs:(NSTimeInterval)curTimeSecs {
    self.curTime = curTimeSecs;
}
/**
 预加载进度
 @param videoPlayer             播放器
 @param preloadedTimeSecs       已加载缓存的时间;单位:秒
 */
- (void) videoPlayer:(JFVideoPlayer*)videoPlayer preloadedTimeSecs:(NSTimeInterval)preloadedTimeSecs {
    self.preloadedTime = preloadedTimeSecs;
}


# pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
    self.clipsToBounds = YES;
    [self setup];
    self.showHandleBtns = NO;
    self.shouldCyclePlay = YES;
    self.shouldAutoPlay = YES;
    self.userInteractionEnabled = YES;
    // 单击事件
    UITapGestureRecognizer* singleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesSingle:)];
    singleGes.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleGes];
    // 双击事件
    UITapGestureRecognizer* doubleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesDouble:)];
    doubleGes.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleGes];
    [singleGes requireGestureRecognizerToFail:doubleGes];
    // 拖动事件
//    UIPanGestureRecognizer* panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
//    panGes.maximumNumberOfTouches = 1;
//    [self addGestureRecognizer:panGes];
}
- (void) setupViews {
    [self addSubview:self.displayView];
    [self addSubview:self.vHandels];
    [self.vHandels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
# pragma mark - setter
- (void)setState:(JFVideoPlayState)state {
    _state = state;
    self.vHandels.state = state;
    if (state == JFVideoPlayStateReadToPlay) {
        self.player.playerLayer = (AVPlayerLayer*)self.displayView.layer;
    }
}

- (void)setShowHandleBtns:(BOOL)showHandleBtns {
    _showHandleBtns = showHandleBtns;
    if (showHandleBtns) {
        [self.vHandels showHandles];
    } else {
        [self.vHandels hideHandles];
    }
}

// 视频总时长
- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    self.vHandels.duration = duration;
}

// 播放进度时长
- (void)setCurTime:(NSTimeInterval)curTime {
    _curTime = curTime;
    self.vHandels.curTime = curTime;
}
// 视频缓存时长
- (void)setPreloadedTime:(NSTimeInterval)preloadedTime {
    _preloadedTime = preloadedTime;
    self.vHandels.preloadedTime = preloadedTime;
}


- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    self.player.video = videoUrl;
    if (videoUrl) {
        AVURLAsset* asset = [AVURLAsset assetWithURL:videoUrl];
        self.duration = CMTimeGetSeconds(asset.duration);
    }
}

- (void)setShouldAutoPlay:(BOOL)shouldAutoPlay {
    _shouldAutoPlay = shouldAutoPlay;
    self.player.playAuto = shouldAutoPlay;
}
- (void)setShouldCyclePlay:(BOOL)shouldCyclePlay {
    _shouldCyclePlay = shouldCyclePlay;
    self.player.playCircle = shouldCyclePlay;
}
- (void)setCancelledBlock:(void (^)(void))cancelledBlock {
    _cancelledBlock = cancelledBlock;
    self.vHandels.cancelledBlock = cancelledBlock;
}

# pragma mark - getter
- (JFVideoPlayer *)player {
    if (!_player) {
        _player = [JFVideoPlayer new];
        _player.delegate = self;
    }
    return _player;
}
// 存放AVLayer的视图
- (JFVideoDisplayContentView *)displayView {
    if (!_displayView) {
        _displayView = [JFVideoDisplayContentView new];
    }
    return _displayView;
}
- (JFVideoDisplayHandles *)vHandels {
    if (!_vHandels) {
        _vHandels = [JFVideoDisplayHandles new];
        WeakSelf(wself);
        _vHandels.didClickPlayPauseBtn = ^{
            [wself clickedPlayBtn:nil];
        };
        _vHandels.willUpdateSlider = ^(JFVideoSlider * _Nonnull slider) {
            [wself.player pause];
        };
        _vHandels.didUpdateSlider = ^(JFVideoSlider * _Nonnull slider) {
            if (slider.curTime < slider.duration) {
                [wself.player seekToTime:slider.curTime];
            }
            wself.curTime = slider.curTime;
        };
        _vHandels.didEndUpdateSlider = ^(JFVideoSlider * _Nonnull slider) {
            [wself.player play];
        };
    }
    return _vHandels;
}
@end



@implementation JFVideoDisplayContentView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        AVPlayerLayer* avLayer = (AVPlayerLayer*)self.layer;
        avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return self;
}
@end




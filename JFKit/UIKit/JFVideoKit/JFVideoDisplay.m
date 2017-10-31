//
//  JFVideoDisplay.m
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import "JFVideoDisplay.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

/****【下banner】****/
@interface JFVideoDisplayBannerBottom : UIView
@property (nonatomic, strong) UIButton* playBtn; // 播放按钮
@property (nonatomic, strong) UILabel* progressLabel; // 进度时间标签
@property (nonatomic, strong) UILabel* durationLabel; // 视频时间标签
@property (nonatomic, strong) UIProgressView* progressView; // 进度条
@property (nonatomic, strong) UISlider* slider; // 滑块
@property (nonatomic, strong) UIButton* orienTationBtn; // 全屏切换按钮
@end

/****【JFVideoDisplay】****/

@interface JFVideoDisplay()
@property (nonatomic, strong) AVPlayer* player; // 播放控件;
@property (nonatomic, strong) AVPlayerItem* playerItem; // 播放源
@property (nonatomic, assign) JFVideoPlayState state; // 播放状态
// 上banner: 退出按钮+标题+操作按钮
@property (nonatomic, strong) JFVideoDisplayBannerBottom* bottomBanner; // 下banner: 进度条+进度时间+总时间+横竖屏切换
@property (nonatomic, assign) float videoTotalSecs; // 视频总时间(秒)
@property (nonatomic, assign) float videoCacheProgressSecs; // 视频缓冲进度时间(秒)
@property (nonatomic, assign) float videoPlayProgressSecs; // 视频播放进度时间(秒)

@end

@implementation JFVideoDisplay

# pragma mark - public
// 播放:指定url
- (void)displayWithUrl:(NSURL *)url {
    [self releaseLastPlayerItem];
    [self setup];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self addObserverOnPlayerItem:self.playerItem];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
}

- (void) stop {
    [self pause];
}

# pragma mark - private

// 开始播放
- (void) play {
    self.state = JFVideoPlayStatePlaying;
    [self.player play];
}
// 暂停播放
- (void) pause {
    self.state = JFVideoPlayStatePausing;
    [self.player pause];
}

// 给播放源添加监听
- (void) addObserverOnPlayerItem:(AVPlayerItem*)playerItem {
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

// 释放原来的播放源
- (void) releaseLastPlayerItem {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player pause];
}

// 点击了播放按钮
- (IBAction) clickedPlayBtn:(id)sender {
    if (self.state == JFVideoPlayStatePlaying) {
        [self pause];
    } else {
        [self play];
    }
}

// 点击slider: touch down
- (IBAction) sliderTouchDown:(UISlider*)slider {
    if (self.videoTotalSecs > 0) {
        [self pause];
    }
}
// 点击slider: touch up inside
- (IBAction) sliderTouchUpInside:(UISlider*)slider {
    self.videoPlayProgressSecs = slider.value;
    [self play];
}
// 点击slider: touch up outside
- (IBAction) sliderTouchUpOutside:(UISlider*)slider {
    self.videoPlayProgressSecs = slider.value;
    [self play];
}
// slider: value变动了
- (IBAction) sliderValueChanged:(UISlider*)slider {
    [self.player seekToTime:CMTimeMake(slider.value, 1)];
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
    self.videoTotalSecs = 0;
    self.videoPlayProgressSecs = 0;
    self.videoCacheProgressSecs = 0;
}

# pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem* playerItem = (AVPlayerItem*)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = playerItem.status;
        if (status == AVPlayerItemStatusReadyToPlay) {
            // 获取视频总时间
            self.videoTotalSecs = floorf(CMTimeGetSeconds(playerItem.duration));
            // 准备好就可以开始播放了，也可以手动启动播放
            [self play];
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 获取视频进度时间
        NSArray* loadedTimeRanges = playerItem.loadedTimeRanges;
        CMTimeRange timerange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float start = CMTimeGetSeconds(timerange.start);
        float duration = CMTimeGetSeconds(timerange.duration);
        self.videoCacheProgressSecs = floorf(start + duration);
    }
}

# pragma mark - life cycle

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}
- (void)dealloc {
    [self releaseLastPlayerItem];
    NSLog(@"-----JFVideoDisplay dealloc-----");
}

- (void) setupDatas {
    ((AVPlayerLayer*)self.layer).player = self.player;
    self.videoTotalSecs = 0;
    self.videoPlayProgressSecs = 0;
    self.videoCacheProgressSecs = 0;
}
- (void) setupViews {
    [self addSubview:self.bottomBanner];
    
    [self.bottomBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(JFVideoBottomBannerHeight);
    }];
}


# pragma mark - setter
- (void)setState:(JFVideoPlayState)state {
    _state = state;
    switch (state) {
        case JFVideoPlayStateWaiting:
        {
            [self.bottomBanner.playBtn setImage:[UIImage imageNamed:JFVideoImageNamePlay] forState:UIControlStateNormal];
        }
            break;
        case JFVideoPlayStatePlaying:
        {
            [self.bottomBanner.playBtn setImage:[UIImage imageNamed:JFVideoImageNamePause] forState:UIControlStateNormal];
        }
            break;
        case JFVideoPlayStatePausing:
        {
            [self.bottomBanner.playBtn setImage:[UIImage imageNamed:JFVideoImageNamePlay] forState:UIControlStateNormal];
        }
            break;
        case JFVideoPlayStateFinishing:
        {
            [self.bottomBanner.playBtn setImage:[UIImage imageNamed:JFVideoImageNamePlay] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [self.bottomBanner.playBtn setImage:[UIImage imageNamed:JFVideoImageNamePlay] forState:UIControlStateNormal];
        }
            break;
    }
}
- (void)setVideoTotalSecs:(float)videoTotalSecs {
    _videoTotalSecs = videoTotalSecs;
    self.bottomBanner.durationLabel.text = [self formatTimeWithSecs:videoTotalSecs];
    if (videoTotalSecs > 0) {
        self.bottomBanner.slider.maximumValue = videoTotalSecs;
    } else {
        self.bottomBanner.slider.maximumValue = 0;
        self.bottomBanner.slider.value = 0;
    }
}
- (void)setVideoPlayProgressSecs:(float)videoPlayProgressSecs {
    _videoPlayProgressSecs = videoPlayProgressSecs;
    self.bottomBanner.progressLabel.text = [self formatTimeWithSecs:videoPlayProgressSecs];
    if (self.videoTotalSecs > 0) {
        self.bottomBanner.slider.value = videoPlayProgressSecs;
    }
}
- (void)setVideoCacheProgressSecs:(float)videoCacheProgressSecs {
    _videoCacheProgressSecs = videoCacheProgressSecs;
    if (self.videoTotalSecs > 0) {
        [self.bottomBanner.progressView setProgress:videoCacheProgressSecs/self.videoTotalSecs animated:YES];
    }
}

# pragma mark - getter
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        // 监听播放进度
        __weak typeof(self) wself = self;
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) usingBlock:^(CMTime time) {
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.videoPlayProgressSecs = time.value/time.timescale;
            });
        }];
    }
    return _player;
}
- (JFVideoDisplayBannerBottom *)bottomBanner {
    if (!_bottomBanner) {
        _bottomBanner = [JFVideoDisplayBannerBottom new];
        _bottomBanner.backgroundColor = JFVideoBannerBgColor;
        [_bottomBanner.playBtn addTarget:self action:@selector(clickedPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBanner.slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_bottomBanner.slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBanner.slider addTarget:self action:@selector(sliderTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_bottomBanner.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _bottomBanner;
}

@end


/****【下banner】****/
@implementation JFVideoDisplayBannerBottom

# pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.playBtn];
        [self addSubview:self.progressLabel];
        [self addSubview:self.durationLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.slider];
        [self addSubview:self.orienTationBtn];
        
        CGFloat gap = 10;
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.equalTo(self.playBtn.mas_height);
        }];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playBtn.mas_right).offset(gap);
            make.centerY.mas_equalTo(0);
        }];
        [self.orienTationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.equalTo(self.orienTationBtn.mas_height);
        }];
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.orienTationBtn.mas_left).offset(-gap);
            make.centerY.mas_equalTo(0);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressLabel.mas_right).offset(gap);
            make.right.equalTo(self.durationLabel.mas_left).offset(-gap);
            make.centerY.mas_equalTo(0);
        }];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.right.equalTo(self.progressView);
        }];
    }
    return self;
}

# pragma mark - getter
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.textColor = JFVideoTextColor;
        _progressLabel.font = [UIFont systemFontOfSize:JFVideoTextTimeFontSize];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.textColor = JFVideoTextColor;
        _durationLabel.font = [UIFont systemFontOfSize:JFVideoTextTimeFontSize];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _durationLabel;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = JFVideoProgressTintColor;
        _progressView.trackTintColor = JFVideoProgressTrackColor;
    }
    return _progressView;
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.minimumTrackTintColor = [UIColor clearColor];
        [_slider setThumbImage:[UIImage imageNamed:JFVideoImageNameSlider] forState:UIControlStateNormal];
    }
    return _slider;
}
- (UIButton *)orienTationBtn {
    if (!_orienTationBtn) {
        _orienTationBtn = [UIButton new];
        [_orienTationBtn setImage:[UIImage imageNamed:JFVideoImageNameFullscreen] forState:UIControlStateNormal];
//        CGFloat gap = JFVideoBottomBannerItemHeight * (1 - 0.618);
//        _orienTationBtn.imageEdgeInsets = UIEdgeInsetsMake(gap, gap, gap, gap);
    }
    return _orienTationBtn;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:JFVideoImageNamePlay] forState:UIControlStateNormal];
        CGFloat gap = JFVideoBottomBannerItemHeight * 0.5;
        _playBtn.imageEdgeInsets = UIEdgeInsetsMake(gap, gap, gap, gap);
    }
    return _playBtn;
}

@end

/****【上banner】****/
@interface JFVideoDisplayBannerTop : UIView
@end
@implementation JFVideoDisplayBannerTop
@end




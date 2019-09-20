//
//  JFVideoDisplayHandles.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/24.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFVideoDisplayHandles.h"
#import "JFMacro.h"
#import "JFHelper.h"
#import <Masonry.h>

// 底部区域的高度比(跟屏幕高度的比)
static CGFloat const JFVDH_bottomBarHeightScale = 1/5.f;
// 图片名:播放
static NSString* const JFVDH_imageNamePlay = @"play_white";
// 图片名:暂停
static NSString* const JFVDH_imageNamePause = @"pause_white";

@interface JFVideoDisplayHandles()
// 渐变背景
@property (nonatomic, strong) CAGradientLayer* gradientLayer;
// 播放|暂停按钮图片
@property (nonatomic, strong) UIImageView* playImageView;
// 退出按钮
@property (nonatomic, strong) UIButton* cancelBtn;
// 搓擦条
@property (nonatomic, strong) JFVideoSlider* slider;
// 当前时间标签
@property (nonatomic, strong) UILabel* curTimeLabel;
// 视频时长标签
@property (nonatomic, strong) UILabel* durationLabel;

@end

@implementation JFVideoDisplayHandles
// 显示操作按钮
- (void) showHandles {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}
// 隐藏操作按钮
- (void) hideHandles {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
}

// 格式化时间
- (NSString*) formatTime:(NSTimeInterval)time {
    NSInteger min = time / 60;
    if (min > 60) {
        min %= 60;
    }
    NSInteger sec = (NSInteger)time - min * 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}

- (void) clickedPlayImage:(UITapGestureRecognizer*)tapGes {
    if (self.didClickPlayPauseBtn) {
        self.didClickPlayPauseBtn();
    }
}

- (IBAction) clickedCancelBtn:(id)sender {
    if (self.cancelledBlock) {
        self.cancelledBlock();
    }
}


# pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.playImageView];
        [self addSubview:self.curTimeLabel];
        [self addSubview:self.durationLabel];
        [self addSubview:self.slider];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(JFScaleWidth6(15));
            make.centerY.equalTo(self.mas_top).offset(JFStatusBarHeight + JFNavigationBarHeight * 0.5);
        }];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.mas_width).multipliedBy(1/6.f);
            make.centerX.centerY.mas_equalTo(0);
        }];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(JFScaleWidth6(64));
            make.right.mas_equalTo(JFScaleWidth6(-64));
            make.bottom.mas_equalTo(JFScaleWidth6(-25));
            make.height.mas_equalTo(4);
        }];
        [self.curTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.slider.mas_left).offset(JFScaleWidth6(-10));
            make.centerY.equalTo(self.slider);
        }];
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slider.mas_right).offset(JFScaleWidth6(10));
            make.centerY.equalTo(self.slider);
        }];

        self.curTime = 0;
        self.duration = 0;
    }
    return self;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.gradientLayer.frame = self.bounds;
}

# pragma mark - setter
- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    self.durationLabel.text = [self formatTime:duration];
    self.slider.duration = duration;
}
- (void)setCurTime:(NSTimeInterval)curTime {
    _curTime = curTime;
    self.curTimeLabel.text = [self formatTime:curTime];
    self.slider.curTime = curTime;
}
- (void)setPreloadedTime:(NSTimeInterval)preloadedTime {
    _preloadedTime = preloadedTime;
    self.slider.preLoadedTime = preloadedTime;
}
- (void)setState:(JFVideoPlayState)state {
    _state = state;
    if (state == JFVideoPlayStatePlaying) {
        self.playImageView.image = JFImageNamed(JFVDH_imageNamePause);
    } else {
        self.playImageView.image = JFImageNamed(JFVDH_imageNamePlay);
    }
}
- (void)setDidUpdateSlider:(void (^)(JFVideoSlider * _Nonnull))didUpdateSlider {
    _didUpdateSlider = didUpdateSlider;
    self.slider.didUpdateSlider = didUpdateSlider;
}
- (void)setWillUpdateSlider:(void (^)(JFVideoSlider * _Nonnull))willUpdateSlider {
    _willUpdateSlider = willUpdateSlider;
    self.slider.willUpdateSlider = willUpdateSlider;
}
- (void)setDidEndUpdateSlider:(void (^)(JFVideoSlider * _Nonnull))didEndUpdateSlider {
    _didEndUpdateSlider = didEndUpdateSlider;
    self.slider.didEndUpdateSlider = didEndUpdateSlider;
}


# pragma mark - getter
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,
                                  (__bridge id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,
                                  (__bridge id)[UIColor colorWithWhite:0 alpha:0.6].CGColor];
        _gradientLayer.locations = @[@(0),@(1 - JFVDH_bottomBarHeightScale),@(1)];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);
    }
    return _gradientLayer;
}
- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [UIImageView new];
        _playImageView.userInteractionEnabled = YES;
        _playImageView.clipsToBounds = YES;
        _playImageView.contentMode = UIViewContentModeScaleAspectFit;
        _playImageView.image = JFImageNamed(JFVDH_imageNamePlay);
        [_playImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedPlayImage:)]];
    }
    return _playImageView;
}
- (UILabel *)curTimeLabel {
    if (!_curTimeLabel) {
        _curTimeLabel = [UILabel new];
        _curTimeLabel.textColor = JFColorWhite;
        _curTimeLabel.font = JFSystemFont(12);
        [_curTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_curTimeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _curTimeLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.textColor = JFColorWhite;
        _durationLabel.font = JFSystemFont(12);
        [_durationLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_durationLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _durationLabel;
}
- (JFVideoSlider *)slider {
    if (!_slider) {
        _slider = [JFVideoSlider new];
    }
    return _slider;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:JFImageNamed(@"delete_fill") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


@end

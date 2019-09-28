//
//  JFVideoSlider.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/24.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFVideoSlider.h"
#import "JFMacro.h"
#import "JFHelper.h"
#import "JFConstant.h"
#import "Masonry.h"
#import "UIView+Extension.h"

static CGFloat const JFVideoSliderThumbWidth = 20;

@interface JFVideoSlider()
@property (nonatomic, strong) UIView* vBgTrack; // 背景轨道
@property (nonatomic, strong) UIView* vProgress; // 预加载进度条
@property (nonatomic, strong) UIView* vTrack; // 已播放进度条
@property (nonatomic, strong) UIView* vThumb; // 进度按钮图片

@property (nonatomic, strong) MASConstraint* masProgressWidth;
@property (nonatomic, strong) MASConstraint* masTrackWidth;
@property (nonatomic, strong) MASConstraint* masThumbLeft;

@property (nonatomic, assign) CGFloat thumbStartX; // thumb的起点

@end
@implementation JFVideoSlider

// 拖动事件
- (void) handleWidthPanGes:(UIPanGestureRecognizer*)panGes {
    // 开始拖动
    if (panGes.state == UIGestureRecognizerStateBegan) {
        CGPoint curP = [panGes locationInView:self];
        CGFloat touchGap = 20;
        if (CGRectContainsPoint(CGRectInset(self.vThumb.frame, -touchGap, -touchGap), curP)) {
            self.thumbStartX = self.vThumb.left;
            if (self.willUpdateSlider) {
                self.willUpdateSlider(self);
            }
        }
    }
    // 拖动中
    else if (panGes.state == UIGestureRecognizerStateChanged && self.thumbStartX >= 0) {
        CGPoint translation = [panGes translationInView:self];
        CGFloat destStartX = self.thumbStartX + translation.x;
        if (destStartX < 0) {
            destStartX = 0;
        }
        else if (destStartX > self.width - JFVideoSliderThumbWidth) {
            destStartX = self.width - JFVideoSliderThumbWidth;
        }
        self.curTime = destStartX / (self.width - JFVideoSliderThumbWidth) * self.duration;
        if (self.didUpdateSlider) {
            self.didUpdateSlider(self);
        }
    }
    // 拖动结束
    else {
        self.thumbStartX = -1;
        if (self.didEndUpdateSlider) {
            self.didEndUpdateSlider(self);
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWidthPanGes:)]];
        [self addSubview:self.vBgTrack];
        [self.vBgTrack addSubview:self.vProgress];
        [self.vBgTrack addSubview:self.vTrack];
        [self addSubview:self.vThumb];
        
        self.vBgTrack.backgroundColor = JFRGBAColor(0xffffff, 0.1);
        self.vProgress.backgroundColor = JFRGBAColor(0xffffff, 0.4);
        self.vTrack.backgroundColor = JFRGBAColor(0xffffff, 1);
        self.vThumb.backgroundColor = JFColorWhite;
        
        [self.vBgTrack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.vProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            self.masProgressWidth = make.width.mas_equalTo(0);
        }];
        [self.vTrack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            self.masTrackWidth = make.width.mas_equalTo(0);
        }];
        [self.vThumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(JFVideoSliderThumbWidth);
            self.masThumbLeft = make.left.mas_equalTo(0);
        }];
        self.vThumb.layer.cornerRadius = JFVideoSliderThumbWidth * 0.5;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.vBgTrack.layer.cornerRadius = self.vBgTrack.height * 0.5;
}



# pragma mark - setter
- (void)setPreLoadedTime:(NSTimeInterval)preLoadedTime {
    _preLoadedTime = preLoadedTime;
    if (self.duration > 0) {
        CGFloat width = preLoadedTime / self.duration * self.width;
        [self.masProgressWidth uninstall];
        [self.vProgress mas_updateConstraints:^(MASConstraintMaker *make) {
            self.masProgressWidth = make.width.mas_equalTo(width);
        }];
        [self setNeedsLayout];
    }
}
- (void)setCurTime:(NSTimeInterval)curTime {
    _curTime = curTime;
    if (self.duration > 0) {
        CGFloat width = curTime / self.duration * (self.width - JFVideoSliderThumbWidth);
        [self.masTrackWidth uninstall];
        [self.masThumbLeft uninstall];
        [self.vTrack mas_updateConstraints:^(MASConstraintMaker *make) {
            self.masTrackWidth = make.width.mas_equalTo(width + JFVideoSliderThumbWidth * 0.5);
        }];
        [self.vThumb mas_updateConstraints:^(MASConstraintMaker *make) {
            self.masThumbLeft = make.left.mas_equalTo(width);
        }];
        [self setNeedsLayout];
    }
}

# pragma mark - getter
- (UIView *)vBgTrack {
    if (!_vBgTrack) {
        _vBgTrack = [UIView new];
        _vBgTrack.layer.masksToBounds = YES;
    }
    return _vBgTrack;
}
- (UIView *)vProgress {
    if (!_vProgress) {
        _vProgress = [UIView new];
    }
    return _vProgress;
}
- (UIView *)vTrack {
    if (!_vTrack) {
        _vTrack = [UIView new];
    }
    return _vTrack;
}
- (UIView *)vThumb {
    if (!_vThumb) {
        _vThumb = [UIView new];
        _vThumb.layer.masksToBounds = YES;
    }
    return _vThumb;
}

@end

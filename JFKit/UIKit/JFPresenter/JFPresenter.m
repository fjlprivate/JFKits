//  JFPresenter.m
//  Created by 冯金龙 on 2021/5/10.
//  Copyright © 2021 冯金龙. All rights reserved.
//

#import "JFPresenter.h"

// 背景动画时间
static CGFloat const JFPresenterBgDuration = 0.1;
// 内容动画时间
static CGFloat const JFPresenterContentDuration = 0.1;


@interface JFPresenter()
// 背景层
@property (nonatomic, strong) UIView* vBg;
// 动画类型
@property (nonatomic, assign) JFPresenterAnimateStyle animateStyle;
@end


@implementation JFPresenter
@synthesize bgColor = _bgColor;

/// 1: 创建加载器
/// @param animateStyle 显示动画类型
- (instancetype) initWithAnimateStyle:(JFPresenterAnimateStyle)animateStyle {
    if (self = [self initWithFrame:CGRectZero]) {
        self.animateStyle = animateStyle;
    }
    return self;
}

/// 2: 动画显示加载器到指定view
/// @param superView  上层view；nil时为window
- (void) showInView:(nullable UIView*)superView {
    if (!superView) {
        superView = UIApplication.sharedApplication.keyWindow;
    }
    self.frame = superView.bounds;
    [superView addSubview:self];
    [self show];
}

/// 隐藏并移除加载器
- (void) show {
    [self showAnimatingOnFinished:^{
    }];
}

/// 隐藏并移除加载器
- (void) hide {
    [self hideAnimatingOnFinished:^{
        [self removeFromSuperview];
    }];
}


#pragma mark - private

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.vBg];
        self.vBg.alpha = 0;
        [self.vBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithTapGes:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}


#pragma mark - 动画

// 显示
- (void) showAnimatingOnFinished:(void(^)(void))finished {
    [UIView animateWithDuration:JFPresenterBgDuration animations:^{
        self.vBg.alpha = 1;
    }];
    switch (self.animateStyle) {
        case JFPresenterAnimateStyleFade:
            [self showAnimatingFadeOnFinished:finished];
            break;
        default:
            break;
    }
}

// 消失
- (void) hideAnimatingOnFinished:(void(^)(void))finished {
    [UIView animateWithDuration:JFPresenterBgDuration animations:^{
        self.vBg.alpha = 0;
    }];
    switch (self.animateStyle) {
        case JFPresenterAnimateStyleFade:
            [self hideAnimatingFadeOnFinished:finished];
            break;
        default:
            break;
    }
}

// 显示动画-淡入淡出
- (void) showAnimatingFadeOnFinished:(void(^)(void))finished {
    self.vContent.alpha = 0;
    [UIView animateWithDuration:JFPresenterContentDuration animations:^{
        self.vContent.alpha = 1;
    } completion:^(BOOL finish) {
        if (finished) {
            finished();
        }
    }];
}

// 消失动画-淡入淡出
- (void) hideAnimatingFadeOnFinished:(void(^)(void))finished {
    [UIView animateWithDuration:JFPresenterContentDuration animations:^{
        self.vContent.alpha = 0;
    } completion:^(BOOL finish) {
        if (finished) {
            finished();
        }
    }];
}


#pragma mark - touch

- (void) handleWithTapGes:(UITapGestureRecognizer*)tapGes {
    if (self.hideWhenClickOutContent) {
        CGPoint curP = [tapGes locationInView:self];
        if (!self.vContent || !CGRectContainsPoint(self.vContent.frame, curP)) {
            [self hide];
        }
    }
}


#pragma mark - getter

- (UIView *)vBg {
    if (!_vBg) {
        _vBg = [[UIView alloc] initWithFrame:self.bounds];
        _vBg.backgroundColor = self.bgColor;
    }
    return _vBg;
}

- (UIColor *)bgColor {
    if (!_bgColor) {
        _bgColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _bgColor;
}

#pragma mark - setter

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.vBg.backgroundColor = self.bgColor;
}


@end

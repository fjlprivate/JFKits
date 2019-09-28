//
//  JFAnimateTransition.m
//  TestForTransition
//
//  Created by johnny feng on 2017/12/16.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFAnimateTransition.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIImageView+WebCache.h"
#import "JFHelper.h"


@interface JFAnimateTransitionImageBrowser()
@property (nonatomic, assign) JFAnimateTransitionType transitionType;
@end

@implementation JFAnimateTransitionImageBrowser

# pragma mark - life cycle

+ (instancetype) transitionWithType:(JFAnimateTransitionType)transitionType {
    return [[self alloc] initWithType:transitionType andDuration:0.5];
}

- (instancetype) initWithType:(JFAnimateTransitionType)transitionType andDuration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        self.transitionType = transitionType;
        self.animationDuration = duration;
        self.contentViewBgColor = [UIColor whiteColor];
    }
    return self;
}

# pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionType == JFAnimateTransitionTypePresent) {
        [self doPresentationTranstionWithContext:transitionContext];
    } else {
        [self doDismissionTranstionWithContext:transitionContext];
    }
}

// present
- (void) doPresentationTranstionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    // present vc
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 被present vc
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 转场容器
    UIView* containerView = [transitionContext containerView];
    containerView.backgroundColor = self.contentViewBgColor;
    // 添加toVC.view
    [containerView addSubview:toVC.view];
    toVC.view.hidden = YES;

    // 添加动画图片视图
    UIImageView* showImgView = [[UIImageView alloc] initWithFrame:self.originImageRect];
    showImgView.contentMode = UIViewContentModeScaleAspectFill;
    showImgView.clipsToBounds = YES;
    if ([self.image isKindOfClass:[UIImage class]]) {
        showImgView.image = self.image;
    }
    else if ([self.image isKindOfClass:[NSURL class]]) {
        [showImgView sd_setImageWithURL:self.image];
    }
    else if ([self.image isKindOfClass:[NSString class]]) {
        [showImgView sd_setImageWithURL:[NSURL URLWithString:self.image]];
    }
    [containerView addSubview:showImgView];
    // 开始动画
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:self.animationDuration * (1 - 0.618) delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        showImgView.frame = wself.finalImageRect;
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        toVC.view.hidden = NO;
        [transitionContext completeTransition:YES];
        if (finished) {
            showImgView.hidden = YES;
            [showImgView removeFromSuperview];
        }
    }];
}

// dismiss
- (void) doDismissionTranstionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.view.hidden = YES;
    // present vc
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 转场容器
    UIView* containerView = [transitionContext containerView];
    // 添加toVC.view
    [containerView addSubview:toVC.view];
    // 添加动画图片视图
    UIImageView* showImgView = [[UIImageView alloc] initWithFrame:self.originImageRect];
    showImgView.contentMode = UIViewContentModeScaleAspectFill;
    showImgView.clipsToBounds = YES;
    if ([self.image isKindOfClass:[UIImage class]]) {
        showImgView.image = self.image;
    }
    else if ([self.image isKindOfClass:[NSURL class]]) {
        [showImgView sd_setImageWithURL:self.image];
    }
    else if ([self.image isKindOfClass:[NSString class]]) {
        [showImgView sd_setImageWithURL:[NSURL URLWithString:self.image]];
    }
    [containerView addSubview:showImgView];
    // 开始动画
    [UIView animateWithDuration:self.animationDuration * (1 - 0.618) delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        showImgView.frame = self.finalImageRect;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        if (finished) {
            showImgView.hidden = YES;
            [showImgView removeFromSuperview];
        }
    }];

}


@end

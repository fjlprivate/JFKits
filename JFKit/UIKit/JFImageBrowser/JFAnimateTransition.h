//
//  JFAnimateTransition.h
//  TestForTransition
//
//  Created by johnny feng on 2017/12/16.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>

// 转场类型
typedef NS_ENUM(NSInteger, JFAnimateTransitionType) {
    JFAnimateTransitionTypePresent,     // present vc
    JFAnimateTransitionTypeDismiss,     // dismiss vc
    JFAnimateTransitionTypePush,        // push vc
    JFAnimateTransitionTypePop          // pop vc
};




# pragma mark - 图片放大浏览转场动画

@interface JFAnimateTransitionImageBrowser : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype) transitionWithType:(JFAnimateTransitionType)transitionType;

// 转场动画时间,默认0.3s
@property (nonatomic, assign) NSTimeInterval animationDuration;

// 图片内容: NSURL|NSString|UIImage
@property (nonatomic, copy) id image;
// 图片的起始frame
@property (nonatomic, assign) CGRect originImageRect;
// 图片的终止frame: 
@property (nonatomic, assign) CGRect finalImageRect;

// 承载视图背景色;默认:白色
@property (nonatomic, copy) UIColor* contentViewBgColor;
@end






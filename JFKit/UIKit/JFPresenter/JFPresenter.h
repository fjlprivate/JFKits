//  JFPresenter.h
//  Created by 冯金龙 on 2021/5/10.
//  Copyright © 2021 冯金龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>



NS_ASSUME_NONNULL_BEGIN

/* view显示加载器
 * 背景层:黑色,半透明
 * 内容层:子类实现内容视图
 * 显示动画:背景层淡入淡出,内容层从小到大、从下到上、从上到下...
 */


// 显示动画类型
typedef NS_ENUM(NSInteger, JFPresenterAnimateStyle) {
    JFPresenterAnimateStyleFade,        // 淡入淡出
    JFPresenterAnimateStyleScale,       // 缩放
    JFPresenterAnimateStyleFromTop,     // 从上到下     topConstant
    JFPresenterAnimateStyleFromDown     // 从下到上     topConstant
};


@interface JFPresenter : UIView

/// 1: 创建加载器
/// @param animateStyle 显示动画类型
- (instancetype) initWithAnimateStyle:(JFPresenterAnimateStyle)animateStyle;

/// 2: 动画显示加载器到指定view
/// @param superView  上层view；nil时为window
- (void) showInView:(nullable UIView*)superView;

/// 隐藏并移除加载器
- (void) hide;

// 点击内容外部是否隐藏; 默认:NO
@property (nonatomic, assign) BOOL hideWhenClickOutContent;

// 背景色;默认:黑色,0.5
@property (nonatomic, strong) UIColor* bgColor;


// === 以下为私有方法，子类实现 ===

/// 内容层；由子类去创建；getter方式创建
@property (nonatomic, strong) UIView* vContent;

@end

NS_ASSUME_NONNULL_END

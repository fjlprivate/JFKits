//
//  JFLayout.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFLayout : NSObject


/**
 初始化layout;
 @param frame 位置和尺寸;
 @param insets content内嵌边距;
 @param backgroundColor 背景色
 @return layout;
 */
- (instancetype) initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets backgroundColor:(UIColor*)backgroundColor;
- (instancetype) initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;
- (instancetype) iniWithFrame:(CGRect)frame;


// 布局支持;setter会更改origin和size
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
// 内嵌边距
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 是否截取建议尺寸(suggustSize);默认:YES;
 YES:按文本实际width、行数，截断(包含insets);
 NO:不截取;直接=viewSize;
 */
@property (nonatomic, assign) BOOL shouldSuggustingSize;

// 边框
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor* borderColor;

// 圆角
@property (nonatomic, assign) CGSize cornerRadius;

// 背景色
@property (nonatomic, copy) UIColor* backgroundColor;

// 用于标记
@property (nonatomic, assign) NSInteger tag;

// 测试line边框绘制:默认:NO;
@property (nonatomic, assign) BOOL debug;

# pragma mark - readonly
@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) CGRect contentFrame;

// 视图在界面中的位置
//@property (nonatomic, assign, readonly) CGPoint viewOrigin;
// 视图的初始尺寸
//@property (nonatomic, assign, readonly) CGSize viewSize;
// 建议尺寸;
//@property (nonatomic, assign, readonly) CGSize suggustSize;

// 由子类实现
- (void) relayouting;

// 更新frame和contentFrame
//- (void) updateFrame;

- (void) updateWidthWithoutRelayouting:(CGFloat)width;
- (void) updateHeightWithoutRelayouting:(CGFloat)height;


@end

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

/**
 是否截取建议尺寸(suggustSize);默认:YES;
 YES:按文本实际width、行数，截断(包含insets);
 NO:不截取;直接=viewSize;
 */
@property (nonatomic, assign) BOOL shouldSuggustingSize;
// 内嵌边距
@property (nonatomic, assign) UIEdgeInsets insets;
// 圆角
@property (nonatomic, assign) CGSize cornerRadius;

// 边框宽度
@property (nonatomic, assign) CGFloat borderWidth;
// 边框颜色
@property (nonatomic, strong) UIColor* borderColor;

// 用于标记
@property (nonatomic, assign) NSInteger tag;

// 背景色
@property (nonatomic, copy) UIColor* backgroundColor;

// 测试line边框绘制:默认:NO;
@property (nonatomic, assign) BOOL debug;

# pragma mark - 只读属性
// 视图在界面中的位置
@property (nonatomic, assign) CGPoint viewOrigin;
// 视图的初始尺寸
@property (nonatomic, assign) CGSize viewSize;
// 建议尺寸;
@property (nonatomic, assign) CGSize suggustSize;


@end

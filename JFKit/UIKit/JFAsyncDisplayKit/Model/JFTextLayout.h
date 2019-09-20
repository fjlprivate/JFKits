//
//  JFTextLayout.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFLayout.h"
#import "JFConstant.h"
#import "JFTextStorage.h"


@interface JFTextLayout : JFLayout

/**
 创建并初始化textLayout;
 @param frame           :位置和尺寸;
 @param text            :富文本;
 @param insets          :content内嵌边距;
 @param backgroundColor :背景色:生效于JFLabel
 @return layout;
 */
+ (instancetype) textLayoutWithFrame:(CGRect)frame text:(JFTextStorage*)text insets:(UIEdgeInsets)insets backgroundColor:(UIColor*)backgroundColor;
+ (instancetype) textLayoutWithFrame:(CGRect)frame text:(JFTextStorage*)text insets:(UIEdgeInsets)insets;
+ (instancetype) textLayoutWithFrame:(CGRect)frame text:(JFTextStorage*)text;
+ (instancetype) textLayoutWithText:(JFTextStorage*)text;


/**
 富文本;text修改后要重新setter;
 */
@property (nonatomic, strong) JFTextStorage* textStorage;


/**
 行数;默认为0;
 */
@property (nonatomic, assign) NSInteger numberOfLines;

/**
 是否显示'全文'or'收起'等更多操作;当截断了行数时;默认:YES;
 */
@property (nonatomic, assign) BOOL shouldShowMoreAct;

/**
 '全文'字体颜色
 */
@property (nonatomic, strong) UIColor* showMoreActColor;

/**
 绘制文本到上下文;
 @param context 指定上下文;
 @param cancelled 退出操作的回调;
 */
- (void) drawInContext:(CGContextRef)context cancelled:(IsCancelled)cancelled;


@end

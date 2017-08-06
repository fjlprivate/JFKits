//
//  JFStorage.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

// 判断是否退出的block
typedef BOOL (^ isCanceledBlock) ();


@interface JFStorage : NSObject

- (instancetype) initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;

// 布局属性
@property (nonatomic, assign, readonly) CGRect frame; // 初始化传递的原始frame
@property (nonatomic, assign, readonly) UIEdgeInsets insets; // 保存文本内嵌距离
@property (nonatomic, assign) CGRect suggustFrame; // 最终的frame;子类也可以对它重新计算
@property (nonatomic, assign, readonly) CGFloat top;
@property (nonatomic, assign, readonly) CGFloat bottom;
@property (nonatomic, assign, readonly) CGFloat left;
@property (nonatomic, assign, readonly) CGFloat right;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;

/**
 ** 虚函数，必须在子类中重载实现;
 绘制缓存数据到图形上下文;
 缓存数据可以是text或image;
 如果是image,contents必须是UIImage才可以绘制;
 
 @param context 图形上下文;
 @param canceled 是否取消绘制的校验方法;
 */
- (void) drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled;


@end

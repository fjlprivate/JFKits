//
//  JFStorage.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

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


@end

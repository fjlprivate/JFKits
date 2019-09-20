//
//  JFLayout.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFLayout.h"


@interface JFLayout()
@end

@implementation JFLayout

# pragma mark - 布局相关
- (CGFloat)top {
    return self.viewOrigin.y;
}
- (void)setTop:(CGFloat)top {
    CGPoint origin = self.viewOrigin;
    origin.y = top;
    self.viewOrigin = origin;
}

- (CGFloat)left {
    return self.viewOrigin.x;
}
- (void)setLeft:(CGFloat)left {
    CGPoint origin = self.viewOrigin;
    origin.x = left;
    self.viewOrigin = origin;
}

- (CGFloat)bottom {
    return self.viewOrigin.y + self.suggustSize.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGSize size = self.viewSize;
    size.height = bottom - self.viewOrigin.y;
    self.viewSize = size;
}

- (CGFloat)right {
    return self.viewOrigin.x + self.suggustSize.width;
}
- (void)setRight:(CGFloat)right {
    CGSize size = self.viewSize;
    size.width = right - self.viewOrigin.x;
    self.viewSize = size;
}

- (CGFloat)width {
    return self.suggustSize.width;
}
- (void)setWidth:(CGFloat)width {
    CGSize size = self.viewSize;
    size.width = width;
    self.viewSize = size;
}

- (CGFloat)height {
    return self.suggustSize.height;
}
- (void)setHeight:(CGFloat)height {
    CGSize size = self.viewSize;
    size.height = height;
    self.viewSize = size;
}

- (CGFloat)centerX {
    return self.viewOrigin.x + self.width * 0.5;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint origin = self.viewOrigin;
    origin.x = centerX - self.width * 0.5;
    self.viewOrigin = origin;
}

- (CGFloat)centerY {
    return self.viewOrigin.y + self.height * 0.5;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint origin = self.viewOrigin;
    origin.y = centerY - self.height * 0.5;
    self.viewOrigin = origin;
}

# pragma mark - setter
- (void)setViewSize:(CGSize)viewSize {
    _viewSize = viewSize;
    _suggustSize = viewSize;
}



# pragma mark - life cycle

/**
 创建并初始化layout;
 @param frame 位置和尺寸;
 @param insets content内嵌边距;
 @param backgroundColor 背景色
 @return layout;
 */
- (instancetype) initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets backgroundColor:(UIColor*)backgroundColor
{
    self = [super init];
    if (self) {
        self.shouldSuggustingSize = YES;
        self.viewOrigin = frame.origin;
        self.viewSize = frame.size;
        self.insets = insets;
        self.backgroundColor = backgroundColor;
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets
{
    return [self initWithFrame:frame insets:insets backgroundColor:nil];
}
- (instancetype) iniWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame insets:UIEdgeInsetsZero];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldSuggustingSize = YES;
    }
    return self;
}


@end

//
//  JFLayout.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFLayout.h"


@interface JFLayout()
// 视图在界面中的位置
@property (nonatomic, assign) CGPoint viewOrigin;
// 视图的初始尺寸
@property (nonatomic, assign) CGSize viewSize;
// 建议尺寸;
@property (nonatomic, assign) CGSize suggustSize;

@end

@implementation JFLayout

# pragma mark - 布局相关
- (CGFloat)top {
    return self.viewOrigin.y;
}
- (void)setTop:(CGFloat)top {
    CGPoint origin = self.viewOrigin;
    origin.y = floor(top);
    self.viewOrigin = origin;
}

- (CGFloat)left {
    return self.viewOrigin.x;
}
- (void)setLeft:(CGFloat)left {
    CGPoint origin = self.viewOrigin;
    origin.x = floor(left);
    self.viewOrigin = origin;
}

- (CGFloat)bottom {
    return self.viewOrigin.y + self.suggustSize.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGSize size = self.viewSize;
    size.height = floor(bottom - self.viewOrigin.y);
    self.viewSize = size;
}

- (CGFloat)right {
    return self.viewOrigin.x + self.suggustSize.width;
}
- (void)setRight:(CGFloat)right {
    CGSize size = self.viewSize;
    size.width = floor(right - self.viewOrigin.x);
    self.viewSize = size;
}

- (CGFloat)width {
    return self.suggustSize.width;
}
- (void)setWidth:(CGFloat)width {
    CGSize size = self.viewSize;
    size.width = floor(width);
    self.viewSize = size;
}

- (CGFloat)height {
    return self.suggustSize.height;
}
- (void)setHeight:(CGFloat)height {
    CGSize size = self.viewSize;
    size.height = floor(height);
    self.viewSize = size;
}

- (CGFloat)centerX {
    return self.viewOrigin.x + self.width * 0.5;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint origin = self.viewOrigin;
    origin.x = floor(centerX - self.width * 0.5);
    self.viewOrigin = origin;
}

- (CGFloat)centerY {
    return self.viewOrigin.y + self.height * 0.5;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint origin = self.viewOrigin;
    origin.y = floor(centerY - self.height * 0.5);
    self.viewOrigin = origin;
}


// 由子类实现
- (void) relayouting {
    
}

# pragma mark - setter
- (void)setViewSize:(CGSize)viewSize {
    _viewSize = CGSizeMake(floor(viewSize.width), floor(viewSize.height));
    _suggustSize = _viewSize;
    [self relayouting];
}
- (void)setViewOrigin:(CGPoint)viewOrigin {
    _viewOrigin = CGPointMake(floor(viewOrigin.x), floor(viewOrigin.y));
    [self relayouting];
}
- (void)setInsets:(UIEdgeInsets)insets {
    _insets = UIEdgeInsetsMake(floor(insets.top),
                               floor(insets.left),
                               floor(insets.bottom),
                               floor(insets.right));
    [self relayouting];
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self relayouting];
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self relayouting];
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

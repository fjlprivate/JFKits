//
//  JFLayout.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFLayout.h"
#import "JFAsyncFlag.h"

@interface JFLayout()
// 视图在界面中的位置
@property (nonatomic, assign) CGPoint viewOrigin;
// 视图的初始尺寸
@property (nonatomic, assign) CGSize viewSize;
// 建议尺寸;
@property (nonatomic, assign) CGSize suggustSize;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, strong) JFAsyncFlag* flag;
@end

@implementation JFLayout
@synthesize top = _top;
@synthesize left = _left;
@synthesize bottom = _bottom;
@synthesize right = _right;
@synthesize centerX = _centerX;
@synthesize centerY = _centerY;
@synthesize width = _width;
@synthesize height = _height;

# pragma mark - 布局相关
// 由子类实现
- (void) relayouting {
    
}

- (void) updateWidthWithoutRelayouting:(CGFloat)width {
    if (width == CGFLOAT_MIN) {
        _width = width;
        return;
    }
    _width = floor(width);
}
- (void) updateHeightWithoutRelayouting:(CGFloat)height {
    if (height == CGFLOAT_MIN) {
        _height = height;
        return;
    }
    _height = floor(height);
}


# pragma mark - setter & getter
- (CGFloat)top {
    if (_top != CGFLOAT_MIN) {
        return _top;
    }
    if (_height == CGFLOAT_MIN) {
        return CGFLOAT_MIN;
    }
    if (_bottom != CGFLOAT_MIN) {
        return _bottom - _height;
    }
    else if (_centerY != CGFLOAT_MIN) {
        return _centerY - _height * 0.5;
    }
    return CGFLOAT_MIN;
}

- (void)setTop:(CGFloat)top {
    if (top == CGFLOAT_MIN) {
        _top = top;
        return;
    }
    _top = floor(top);
    [self relayouting];
}

- (CGFloat)left {
    if (_left != CGFLOAT_MIN) {
        return _left;
    }
    if (_width == CGFLOAT_MIN) {
        return CGFLOAT_MIN;
    }
    if (_right != CGFLOAT_MIN) {
        return _right - _width;
    }
    else if (_centerX != CGFLOAT_MIN) {
        return _centerX - _width * 0.5;
    }
    return CGFLOAT_MIN;
}
- (void)setLeft:(CGFloat)left {
    if (left == CGFLOAT_MIN) {
        _left = left;
        return;
    }
    _left = floor(left);
    [self relayouting];
}

- (CGFloat)bottom {
    if (_bottom != CGFLOAT_MIN) {
        return _bottom;
    }
    if (_height == CGFLOAT_MIN) {
        return CGFLOAT_MIN;
    }
    if (_top != CGFLOAT_MIN) {
        return _top + _height;
    }
    else if (_centerY != CGFLOAT_MIN) {
        return _centerY + _height * 0.5;
    }
    return CGFLOAT_MIN;
}
- (void)setBottom:(CGFloat)bottom {
    if (bottom == CGFLOAT_MIN) {
        _bottom = bottom;
        return;
    }
    _bottom = floor(bottom);
    [self relayouting];
}

- (CGFloat)right {
    if (_right != CGFLOAT_MIN) {
        return _right;
    }
    if (_width == CGFLOAT_MIN) {
        return CGFLOAT_MIN;
    }
    if (_left != CGFLOAT_MIN) {
        return _left + _width;
    }
    else if (_centerX != CGFLOAT_MIN) {
        return _centerX + _width * 0.5;
    }
    return CGFLOAT_MIN;
}
- (void)setRight:(CGFloat)right {
    if (right == CGFLOAT_MIN) {
        _right = right;
        return;
    }
    _right = floor(right);
    [self relayouting];
}

- (CGFloat)width {
    if (_width != CGFLOAT_MIN) {
        return _width;
    }
    if (_left != CGFLOAT_MIN && _right != CGFLOAT_MIN) {
        return _right - _left;
    }
    else if (_left != CGFLOAT_MIN && _centerX != CGFLOAT_MIN) {
        return (_centerX - _left) * 2;
    }
    else if (_right != CGFLOAT_MIN && _centerX != CGFLOAT_MIN) {
        return (_right - _centerX) * 2;
    }
    return CGFLOAT_MIN;
}

- (void)setWidth:(CGFloat)width {
    if (width == CGFLOAT_MIN) {
        _width = width;
        return;
    }
    _width = floor(width);
    [self relayouting];
}

- (CGFloat)height {
    if (_height != CGFLOAT_MIN) {
        return _height;
    }
    if (_top != CGFLOAT_MIN && _bottom != CGFLOAT_MIN) {
        return _bottom - _top;
    }
    else if (_top != CGFLOAT_MIN && _centerY != CGFLOAT_MIN) {
        return (_centerY - _top) * 2;
    }
    else if (_bottom != CGFLOAT_MIN && _centerY != CGFLOAT_MIN) {
        return (_bottom - _centerY) * 2;
    }
    return CGFLOAT_MIN;
}
- (void)setHeight:(CGFloat)height {
    if (height == CGFLOAT_MIN) {
        _height = height;
        return;
    }
    _height = floor(height);
    [self relayouting];
}

- (CGFloat)centerX {
    if (_centerX != CGFLOAT_MIN) {
        return _centerX;
    }
    if (_width == CGFLOAT_MIN) {
        return CGFLOAT_MIN;
    }
    if (_left != CGFLOAT_MIN) {
        return _left + _width * 0.5;
    }
    else if (_right != CGFLOAT_MIN) {
        return _right - _width * 0.5;
    }
    return CGFLOAT_MIN;
}
- (void)setCenterX:(CGFloat)centerX {
    if (centerX == CGFLOAT_MIN) {
        _centerX = centerX;
        return;
    }
    _centerX = floor(centerX);
    [self relayouting];
}

- (CGFloat)centerY {
    if (_centerY != CGFLOAT_MIN) {
        return _centerY;
    }
    if (_height == CGFLOAT_MIN) {
        return CGFLOAT_MIN;
    }
    if (_top != CGFLOAT_MIN) {
        return _top + _height * 0.5;
    }
    else if (_bottom != CGFLOAT_MIN) {
        return _bottom - _height * 0.5;
    }
    return CGFLOAT_MIN;
}
- (void)setCenterY:(CGFloat)centerY {
    if (centerY == CGFLOAT_MIN) {
        _centerX = centerY;
        return;
    }
    _centerY = floor(centerY);
    [self relayouting];
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    [self relayouting];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self relayouting];
}
- (void)setCornerRadius:(CGSize)cornerRadius {
    _cornerRadius = cornerRadius;
    [self relayouting];
}



- (CGRect)frame {
    return CGRectMake(self.left, self.top, self.width, self.height);
}
- (CGRect)contentFrame {
    return CGRectMake(self.left + _insets.left,
                      self.top + _insets.top,
                      self.width - _insets.left - _insets.right,
                      self.height - _insets.top - _insets.bottom);
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
    self = [self init];
    if (self) {
        if (!CGRectEqualToRect(frame, CGRectZero)) {
            self.left = CGRectGetMinX(frame);
            self.top = CGRectGetMinY(frame);
            self.width = CGRectGetWidth(frame);
            self.height = CGRectGetHeight(frame);
        }
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
        _top = CGFLOAT_MIN;
        _left = CGFLOAT_MIN;
        _right = CGFLOAT_MIN;
        _bottom = CGFLOAT_MIN;
        _width = CGFLOAT_MIN;
        _height = CGFLOAT_MIN;
        _centerX = CGFLOAT_MIN;
        _centerY = CGFLOAT_MIN;
        _insets = UIEdgeInsetsZero;
        
        _shouldSuggustingSize = YES;
        _viewOrigin = CGPointZero;
        _viewSize = CGSizeZero;
        _backgroundColor = [UIColor whiteColor];
        _flag = [JFAsyncFlag new];
    }
    return self;
}


@end

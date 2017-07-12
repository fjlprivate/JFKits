//
//  UIView+Extension.m
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)



# pragma mask ---- 坐标系相关

- (CGFloat)top {
    return self.frame.origin.y;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}


- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    if (self.height > 0) {
        CGFloat bottom = self.bottom;
        frame.size.height = bottom - top;
    }
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.size.height = bottom - self.top;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    if (self.width > 0) {
        frame.size.width = self.right - left;
    }
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.size.width = right - self.left;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.bounds;
    frame.size.width = width;
    self.bounds = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.bounds;
    frame.size.height = height;
    self.bounds = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end

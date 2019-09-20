//
//  JFImageLayout.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFImageLayout.h"

@implementation JFImageLayout
@synthesize suggustSize = _suggustSize;
@synthesize viewSize = _viewSize;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


- (void)setBottom:(CGFloat)bottom {
    CGSize size = self.suggustSize;
    size.height = bottom - self.viewOrigin.y;
    self.suggustSize = size;
}

- (void)setRight:(CGFloat)right {
    CGSize size = self.suggustSize;
    size.width = right - self.viewOrigin.x;
    self.suggustSize = size;
}

- (void)setWidth:(CGFloat)width {
    CGSize size = self.suggustSize;
    size.width = width;
    self.suggustSize = size;
}

- (void)setHeight:(CGFloat)height {
    CGSize size = self.suggustSize;
    size.height = height;
    self.suggustSize = size;
}


- (void)setSuggustSize:(CGSize)suggustSize {
    _suggustSize = suggustSize;
    [self resetViewSize];
}

- (void) resetViewSize {
    _viewSize = CGSizeMake(self.suggustSize.width - self.insets.left - self.insets.right,
                           self.suggustSize.height - self.insets.top - self.insets.bottom);
}


- (void)setViewSize:(CGSize)viewSize {
    _viewSize = viewSize;
//    [super setViewSize:viewSize];
//    [self resetSuggustSize];
}
- (void)setInsets:(UIEdgeInsets)insets {
    [super setInsets:insets];
    [self resetViewSize];
}
//- (void) resetSuggustSize {
//    _suggustSize = CGSizeMake(self.viewSize.width - self.insets.left - self.insets.right,
//                              self.viewSize.height - self.insets.top - self.insets.bottom);
//}
@end

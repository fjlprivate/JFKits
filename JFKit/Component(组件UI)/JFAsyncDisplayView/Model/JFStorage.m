//
//  JFStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFStorage.h"

@implementation JFStorage

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    self = [super init];
    if (self) {
        _frame = frame;
        _insets = insets;
        frame.origin.x += insets.left;
        frame.origin.y += insets.top;
        frame.size.width -= (insets.left + insets.right);
        frame.size.height -= (insets.top + insets.bottom);
        _suggustFrame = frame;
    }
    return self;
}

# pragma mask 4 getter
- (CGFloat)top {
    return self.suggustFrame.origin.y;
}
- (CGFloat)bottom {
    return self.suggustFrame.origin.y + self.suggustFrame.size.height;
}
- (CGFloat)left {
    return self.suggustFrame.origin.x;
}
- (CGFloat)right {
    return self.suggustFrame.origin.x + self.suggustFrame.size.width;
}
- (CGFloat)width {
    return self.suggustFrame.size.width;
}
- (CGFloat)height {
    return self.suggustFrame.size.height;
}


@end

//
//  JFIBButton.m
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFIBButton.h"

@implementation JFIBButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = CGRectInset(self.bounds, -20, -20);
    if (CGRectContainsPoint(frame, point)) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

@end

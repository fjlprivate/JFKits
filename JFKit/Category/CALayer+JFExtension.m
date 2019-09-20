//
//  CALayer+JFExtension.m
//  RuralMeet
//
//  Created by LiChong on 2017/12/14.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "CALayer+JFExtension.h"

@implementation CALayer (JFExtension)

// fade动画显示contents
- (void) jf_showContentsAnimation {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"contentsFadeAnimation"];
}
// 移除contents的动画效果
- (void) jf_removeContentsAnimation {
    [self removeAnimationForKey:@"contentsFadeAnimation"];
}


@end

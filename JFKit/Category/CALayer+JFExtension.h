//
//  CALayer+JFExtension.h
//  RuralMeet
//
//  Created by LiChong on 2017/12/14.
//  Copyright © 2017年 occ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JFExtension)

// fade动画显示contents
- (void) jf_showContentsAnimation;
// 移除contents的动画效果
- (void) jf_removeContentsAnimation;

@end

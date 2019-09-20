//
//  UIImageView+JFExtention.h
//  QiangQiang
//
//  Created by LiChong on 2018/3/27.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JFExtention)

# pragma mark - 设置高斯模糊图片
/**
 @param image 图片;
 @param blur 高斯模糊值:0~1.f
 */
- (void) jf_setImage:(UIImage*)image withBlur:(CGFloat)blur;

@end

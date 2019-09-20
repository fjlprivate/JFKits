//
//  UIImageView+JFExtention.m
//  QiangQiang
//
//  Created by LiChong on 2018/3/27.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "UIImageView+JFExtention.h"
#import "UIImage+JFExtension.h"

@implementation UIImageView (JFExtention)

# pragma mark - 设置高斯模糊图片
/**
 @param image 图片;
 @param blur 高斯模糊值:0~1.f
 */
- (void) jf_setImage:(UIImage*)image withBlur:(CGFloat)blur {
    if (!image) {
        return;
    }
    if (![image isKindOfClass:[UIImage class]]) {
        return;
    }
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* newImage = [image jf_blurImage:blur];
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.image = newImage;
        });
    });
}

@end

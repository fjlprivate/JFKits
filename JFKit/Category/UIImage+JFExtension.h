//
//  UIImage+JFExtension.h
//  RuralMeet
//
//  Created by LiChong on 2018/1/23.
//  Copyright © 2018年 occ. All rights reserved.
//

#import <UIKit/UIKit.h>

// 键名:文字的背景色
static NSString* const JFTextBackgroundColorAttributeKey = @"JFTextBackgroundColorAttributeKey";

@interface UIImage (JFExtension)

// 由颜色生成图片
+ (instancetype) jf_imageWithColor:(UIColor*)color;
+ (instancetype) jf_imageWithColor:(UIColor*)color inSize:(CGSize)size;

// 从video取指定时间的帧图片
+ (instancetype) jf_thumbnailImageForVideoURL:(NSURL*)videoURL atTime:(NSTimeInterval)time;
+ (void) jf_thumbnailImageForVideoURL:(NSURL*)videoURL atTime:(NSTimeInterval)time onFinished:(void (^)(UIImage* image))finishedBlock;

// 高斯模糊
- (UIImage*) jf_blurImage:(CGFloat)blur;

// 读取二维码信息
- (NSString*) jf_readQRCode;

// 更正图片的方向
- (UIImage*) jf_normalizedImage;

/**
 绘制文字到图片上面;
 如果要给文字加上背景颜色,请设置属性[JFTextBackgroundColorAttribute]
 @param text            富文本
 @param rect            要绘制的区域
 @param newImageSize    图片最终要显示的尺寸
 @return                绘制了文字的图片;
 */
- (UIImage*) jf_drawText:(NSAttributedString*)text inRect:(CGRect)rect newImageSize:(CGSize)newImageSize;

@end

//
//  UIImage+Extension.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "UIImage+Extension.h"
#import "JFMacro.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (Extension)



/**
 裁剪+缩放+边框;
 @param newSize 缩放后的尺寸;
 @param contentMode 位置;
 @param cornerRadius 圆角值;对比缩放后的尺寸;
 @param borderWidth 边框宽度;对比缩放后的尺寸;
 @param borderColor 边框颜色;
 @param backgroundColor 图片背景色;
 @return 处理后的图片;
 */
- (UIImage*) jf_imageScaledInSize:(CGSize)newSize
                   contentMode:(UIViewContentMode)contentMode
                  cornerRadius:(CGSize)cornerRadius
                    boderWidth:(CGFloat)borderWidth
                   borderColor:(UIColor*)borderColor
               backgroundColor:(UIColor*)backgroundColor
{
    if (newSize.width <= 0 || newSize.height <= 0) {
        return nil;
    }
    // 初始化参数
    CGSize imageSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat tempBorderWidth = borderWidth >= 0 ? borderWidth : 0;
    CGFloat cornerWidth = cornerRadius.width >= 0 ? cornerRadius.width : 0;
    CGFloat cornerHeight = cornerRadius.height >= 0 ? cornerRadius.height : 0;
    CGRect frame = CGRectMake(0, 0, newSize.width, newSize.height);
    // 根据缩放后的尺寸比例计算需要裁剪的区域
    CGSize trimedSize = [self trimedSizeWithScaleSize:newSize];
    UIImage* trimedImage = self;
    // 裁剪的区域跟当前图片的尺寸不一致才需要裁剪
    if (!CGSizeEqualToSize(trimedSize, imageSize)) {
        trimedImage = [self jf_imageTrimedWithContentMode:contentMode inSize:trimedSize];
    }
    BOOL opacua = YES;
    CGFloat alpha = 0;
    [backgroundColor getRed:nil green:nil blue:nil alpha:&alpha];
    if (!backgroundColor || alpha < 1) {
        opacua = NO;
    }
    // 创建画板
    UIGraphicsBeginImageContextWithOptions(newSize, opacua, screenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 绘制背景色
    CGContextSetFillColorWithColor(context, backgroundColor ? backgroundColor.CGColor : [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectInset(frame, -2, -2));
    // 裁剪区域
    CGPathRef path = CGPathCreateWithRoundedRect(frame, cornerWidth, cornerHeight, nil);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGPathRelease(path);
    // 缩放裁剪后的图片
    [trimedImage drawInRect:frame];
    // 绘制边框
    if (tempBorderWidth > 0 && borderColor) {
        frame = CGRectInset(frame, tempBorderWidth * 0.5, tempBorderWidth * 0.5);
        path = CGPathCreateWithRoundedRect(frame, cornerWidth - tempBorderWidth * 0.5, cornerHeight - tempBorderWidth * 0.5, nil);
        CGContextAddPath(context, path);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, tempBorderWidth);
        CGContextStrokePath(context);
    }
    // 取出图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 裁剪边框和圆角;
 @param cornerRadius 圆角值(含widthRadius,heightRadius);
 @param borderWidth 边框宽度;默认0;
 @param borderColor 边框颜色;默认白色;
 @param backgroundColor 背景色;传空就用白色;
 @return 裁剪后的图片;
 */
- (UIImage*) jf_imageTrimedWithCornerRadius:(CGSize)cornerRadius
                                 boderWidth:(CGFloat)borderWidth
                                borderColor:(UIColor*)borderColor
                            backgroundColor:(UIColor*)backgroundColor
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat tempBorderWidth = borderWidth >= 0 ? borderWidth * screenScale : 0;
    CGSize imageSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGFloat cornerWidth = cornerRadius.width >= 0 ? cornerRadius.width * screenScale : 0;
    CGFloat cornerHeight = cornerRadius.height > 0 ? cornerRadius.height * screenScale : 0;
    CGRect frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    // 创建画板
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 先绘制背景色
    CGContextSetFillColorWithColor(context, backgroundColor ? backgroundColor.CGColor : [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectInset(frame, -2, -2));
    // 裁剪path
    CGPathRef path = CGPathCreateWithRoundedRect(frame, cornerWidth, cornerHeight, nil);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGPathRelease(path);
    // 绘制图片
    [self drawInRect:frame];
    // 绘制边框
    CGPathRef inPath = CGPathCreateWithRoundedRect(CGRectInset(frame, tempBorderWidth * 0.5, tempBorderWidth * 0.5), cornerWidth - tempBorderWidth * 0.5, cornerHeight - tempBorderWidth * 0.5, nil);
    CGContextAddPath(context, inPath);
    CGContextSetStrokeColorWithColor(context, borderColor ? borderColor.CGColor : [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, tempBorderWidth);
    CGContextStrokePath(context);
    CGPathRelease(inPath);
    // 回调图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 等比缩放图片;不裁剪;
 @param size 缩放的尺寸(不考虑scale;处理中才考虑);
 @return 缩放后的图片;
 */
- (UIImage*) jf_imageScaledToSize:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width * self.scale, size.height * self.scale);
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, [UIScreen mainScreen].scale);
    [self drawInRect:frame];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 裁剪图片;不缩放;
 @param contentMode 裁剪模式;
 @param inSize 裁剪的尺寸;图片中实际裁剪的尺寸;
 @return 裁剪后的图片;
 */
- (UIImage*) jf_imageTrimedWithContentMode:(UIViewContentMode)contentMode inSize:(CGSize)inSize {
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGRect frame = CGRectMake(0, 0,
                              inSize.width > imageWidth ? imageWidth : inSize.width,
                              inSize.height > imageHeight ? imageHeight : inSize.height);
    if (contentMode == UIViewContentModeTop) {
        frame.origin.x = (imageWidth - frame.size.width) * 0.5;
    }
    else if (contentMode == UIViewContentModeTopRight) {
        frame.origin.x = imageWidth - frame.size.width;
    }
    else if (contentMode == UIViewContentModeRight) {
        frame.origin.x = imageWidth - frame.size.width;
        frame.origin.y = (imageHeight - frame.size.height) * 0.5;
    }
    else if (contentMode == UIViewContentModeBottomRight) {
        frame.origin.x = imageWidth - frame.size.width;
        frame.origin.y = imageHeight - frame.size.height;
    }
    else if (contentMode == UIViewContentModeBottom) {
        frame.origin.x = (imageWidth - frame.size.width) * 0.5;
        frame.origin.y = imageHeight - frame.size.height;
    }
    else if (contentMode == UIViewContentModeBottomLeft) {
        frame.origin.y = imageHeight - frame.size.height;
    }
    else if (contentMode == UIViewContentModeLeft) {
        frame.origin.y = (imageHeight - frame.size.height) * 0.5;
    }
    else if (contentMode == UIViewContentModeTopLeft) {
    }
    // 取中
    else {
        frame.origin.x = (imageWidth - frame.size.width) * 0.5;
        frame.origin.y = (imageHeight - frame.size.height) * 0.5;
    }
    CGImageRef subCGImageRef =  CGImageCreateWithImageInRect(self.CGImage, frame);
    UIImage* subImage = [UIImage imageWithCGImage:subCGImageRef];
    CGImageRelease(subCGImageRef);
    return subImage;
}

/**
 给图片添加背景色，并缩放到指定的size中的指定比例尺寸;
 还可以添加圆角;
 @param size 缩放的最终尺寸;
 @param innerRatio 图片占最终尺寸的比例; [0-1]
 @param backgroundColor 背景色;
 @param cornerRadius 圆角;
 @return 缩放并添加背景的图片;
 */
- (UIImage*) jf_imageScaledInSize:(CGSize)size
                       innerRatio:(CGFloat)innerRatio
                  backgroundColor:(UIColor*)backgroundColor
                     cornerRadius:(CGSize)cornerRadius
{
    if (CGSizeEqualToSize(size, CGSizeZero) || innerRatio == 0 || innerRatio > 1) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    // 先绘制背景色
    if (backgroundColor) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectInset(frame, -2, -2));
    }
    // 再裁剪
    CGPathRef path = CGPathCreateWithRoundedRect(frame, cornerRadius.width, cornerRadius.height, nil);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGPathRelease(path);
    // 最后填充图片到中间
    CGFloat widthRatio = 0;
    CGFloat heightRatio = 0;
    if (self.size.width/self.size.height > size.width/size.height) {
        widthRatio = innerRatio;
        heightRatio = innerRatio * (self.size.height/self.size.width);
    }
    else if (self.size.width/self.size.height < size.width/size.height) {
        heightRatio = innerRatio;
        widthRatio = innerRatio * (self.size.width/self.size.height);
    }
    else {
        widthRatio = innerRatio;
        heightRatio = innerRatio;
    }
    CGSize innerSize = CGSizeMake(size.width * widthRatio, size.height * heightRatio);
    CGRect innerRect = CGRectMake((size.width - innerSize.width) * 0.5, (size.height - innerSize.height) * 0.5, innerSize.width, innerSize.height);
    [self drawInRect:innerRect];
    //
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


# pragma mark - tools

// 根据指定的尺寸计算出缩放的要裁剪的尺寸
- (CGSize) trimedSizeWithScaleSize:(CGSize)scaleSize {
    CGSize originSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    if (originSize.width/originSize.height > scaleSize.width/scaleSize.height) {
        originSize.width = originSize.height * scaleSize.width/scaleSize.height;
    }
    else if (originSize.width/originSize.height < scaleSize.width/scaleSize.height) {
        originSize.height = originSize.width * scaleSize.height / scaleSize.width;
    }
    return originSize;
}




@end

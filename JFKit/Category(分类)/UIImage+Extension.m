//
//  UIImage+Extension.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "UIImage+Extension.h"
#import "JFMacro.h"

@implementation UIImage (Extension)


/**
 裁剪出指定size的图片;
 从左上角开始;
 
 @param newSize 裁剪size;
 @return 裁剪后的图片;
 */
- (UIImage*) imageCutedWithNewSize:(CGSize)newSize {
    if (CGSizeEqualToSize(newSize, CGSizeZero)) {
        return nil;
    }
    if (newSize.width > self.size.width) {
        newSize.width = self.size.width;
    }
    if (newSize.height > self.size.height) {
        newSize.height = self.size.height;
    }
    CGRect bounds = CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);

    UIImage* image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}


/**
 裁剪出指定size的图片;
 按指定的位置;
 
 @param newSize 裁剪size;
 @param contentMode 指定位置;
 @return 裁剪后的图片;
 */
- (UIImage*) imageCutedWithNewSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode {
    if (CGSizeEqualToSize(newSize, CGSizeZero)) {
        return nil;
    }
    if (newSize.width > self.size.width) {
        newSize.width = self.size.width;
    }
    if (newSize.height > self.size.height) {
        newSize.height = self.size.height;
    }
    CGSize imageSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGRect bounds =  CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale);
    
    switch (contentMode) {
        case UIViewContentModeCenter:       // 中点
        {
            bounds.origin.x = (imageSize.width - bounds.size.width)/2.0;
            bounds.origin.y = (imageSize.height - bounds.size.height)/2.0;
        }
            break;
        case UIViewContentModeTop:          // 中上
        {
            bounds.origin.x = (imageSize.width - bounds.size.width)/2.0;
        }
            break;
        case UIViewContentModeBottom:       // 中下
        {
            bounds.origin.x = (imageSize.width - bounds.size.width)/2.0;
            bounds.origin.y = (imageSize.height - bounds.size.height);
        }
            break;
        case UIViewContentModeLeft:         // 中左
        {
            bounds.origin.y = (imageSize.height - bounds.size.height)/2.0;
        }
            break;
        case UIViewContentModeRight:        // 中右
        {
            bounds.origin.x = (imageSize.width - bounds.size.width);
            bounds.origin.y = (imageSize.height - bounds.size.height)/2.0;
        }
            break;
        case UIViewContentModeTopRight:     // 右上
        {
            bounds.origin.x = (imageSize.width - bounds.size.width);
        }
            break;
        case UIViewContentModeBottomLeft:   // 左下
        {
            bounds.origin.y = (imageSize.height - bounds.size.height);
        }
            break;
        case UIViewContentModeBottomRight:  // 右下
        {
            bounds.origin.x = (imageSize.width - bounds.size.width);
            bounds.origin.y = (imageSize.height - bounds.size.height);
        }
            break;
        default:                            // 左上
            break;
    }
        
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}






/**
 裁剪当前image;
 按下列属性裁剪;
 
 @param contentMode 布局模式
 @param newSize 新的图片大小
 @param cornerRadius 圆角大小，分横竖
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 @param backgroundColor 背景色
 @return 裁剪后的图片
 */
- (UIImage*) imageCutedWithContentMode:(UIViewContentMode)contentMode
                               newSize:(CGSize)newSize
                          cornerRadius:(CGSize)cornerRadius
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor*)borderColor
                       backgroundColor:(UIColor*)backgroundColor
{
    if (CGSizeEqualToSize(newSize, CGSizeZero)) {
        return nil;
    }
    if (newSize.width > self.size.width) {
        newSize.width = self.size.width;
    }
    if (newSize.height > self.size.height) {
        newSize.height = self.size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageFrame = CGRectMake(0, 0, newSize.width, newSize.height);
    
    
    // 绘制背景色
    if (backgroundColor) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectInset(imageFrame, -2, -2));
    }
    

    // 裁剪图片
    CGSize imageSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGRect bounds =  CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale);
    
    switch (contentMode) {
        case UIViewContentModeCenter:       // 中点
        {
            bounds.origin.x = (imageSize.width - bounds.size.width)/2.0;
            bounds.origin.y = (imageSize.height - bounds.size.height)/2.0;
        }
            break;
        case UIViewContentModeTop:          // 中上
        {
            bounds.origin.x = (imageSize.width - bounds.size.width)/2.0;
        }
            break;
        case UIViewContentModeBottom:       // 中下
        {
            bounds.origin.x = (imageSize.width - bounds.size.width)/2.0;
            bounds.origin.y = (imageSize.height - bounds.size.height);
        }
            break;
        case UIViewContentModeLeft:         // 中左
        {
            bounds.origin.y = (imageSize.height - bounds.size.height)/2.0;
        }
            break;
        case UIViewContentModeRight:        // 中右
        {
            bounds.origin.x = (imageSize.width - bounds.size.width);
            bounds.origin.y = (imageSize.height - bounds.size.height)/2.0;
        }
            break;
        case UIViewContentModeTopRight:     // 右上
        {
            bounds.origin.x = (imageSize.width - bounds.size.width);
        }
            break;
        case UIViewContentModeBottomLeft:   // 左下
        {
            bounds.origin.y = (imageSize.height - bounds.size.height);
        }
            break;
        case UIViewContentModeBottomRight:  // 右下
        {
            bounds.origin.x = (imageSize.width - bounds.size.width);
            bounds.origin.y = (imageSize.height - bounds.size.height);
        }
            break;
        default:                            // 左上
            break;
    }
    
    // 裁剪cornerRadius
    CGMutablePathRef path = CGPathCreateMutable();
    if (cornerRadius.width > 0 || cornerRadius.height > 0) {
        CGPathAddRoundedRect(path, NULL, imageFrame, cornerRadius.width, cornerRadius.height);
        CGContextAddPath(context, path);
        // 裁剪
        CGContextClip(context);
    } else {
        CGPathAddRect(path, NULL, imageFrame);
        CGContextAddPath(context, path);
    }
    
    
    // 绘制图片
    if (CGSizeEqualToSize(newSize, self.size)) {
        [self drawInRect:imageFrame];
    } else {
        // 裁剪图片
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
        // 绘制图片
        CGContextTranslateCTM(context, 0, newSize.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, imageFrame, imageRef);
        // 释放图片
        CGImageRelease(imageRef);
    }
    
    
    // 绘制边框
    if (borderWidth > 0 && borderColor) {
        CGRect borderRect = CGRectInset(imageFrame, borderWidth, borderWidth);
        CGPathAddRoundedRect(path, NULL, borderRect, cornerRadius.width - borderWidth, cornerRadius.height - borderWidth);
        CGContextAddPath(context, path);
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokePath(context);
    }
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 释放资源
    CFRelease(path);
    UIGraphicsEndImageContext();
    
    return image;
}





@end

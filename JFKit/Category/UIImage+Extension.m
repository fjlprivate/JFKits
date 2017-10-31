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
 裁剪圆角(包括圆形);
 按下列属性裁剪;
 
 @param contentMode 布局模式
 @param cornerRadius 圆角大小，分横竖
 @param borderWidth 边线宽度;
 @param borderColor 边线颜色
 @param backgroundColor 背景色
 @return 裁剪后的图片
 */
- (UIImage*) imageCutedWithContentMode:(UIViewContentMode)contentMode
                          cornerRadius:(CGSize)cornerRadius
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor*)borderColor
                       backgroundColor:(UIColor*)backgroundColor
{
    // 根据mode计算newSize和图片绘制位置的frame
    CGFloat newWidth;
    CGRect imageFrame = [self newImageFrameWithContentMode:contentMode newImageWidth:&newWidth];
    CGRect contextFrame = CGRectMake(0, 0, newWidth, newWidth);
    // 用newsize生成image context
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 绘制背景色
    if (backgroundColor) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    } else {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextFillRect(context, contextFrame);
    // 按圆角裁剪边框区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, contextFrame, cornerRadius.width, cornerRadius.height);
    CGContextAddPath(context, path);
    CGContextClip(context);
    // 绘制图片到frame
    [self drawInRect:imageFrame];
    // 绘制边框
    if (borderWidth > 0 && borderColor) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGPathAddRoundedRect(path, NULL, CGRectInset(contextFrame, borderWidth, borderWidth), cornerRadius.width - borderWidth, cornerRadius.height - borderWidth);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    CFRelease(path);
    UIGraphicsEndImageContext();
    return image;
}


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
    CGRect contextFrame = CGRectMake(0, 0, newSize.width, newSize.height);

    UIGraphicsBeginImageContextWithOptions(newSize, YES, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageFrame = [self newImageFrameWithContentMode:contentMode newSize:newSize];
 
    // 绘制背景色
    if (backgroundColor) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectInset(contextFrame, -2, -2));
    }
    
    // 裁剪cornerRadius
    CGMutablePathRef path = CGPathCreateMutable();
    if (cornerRadius.width > 0 || cornerRadius.height > 0) {
        CGPathAddRoundedRect(path, NULL, contextFrame, cornerRadius.width, cornerRadius.height);
        CGContextAddPath(context, path);
        // 裁剪
        CGContextClip(context);
    }
    
    // 绘制图片
    [self drawInRect:imageFrame];
    
    // 绘制边框
    if (borderWidth > 0 && borderColor) {
        CGRect borderRect = CGRectInset(contextFrame, borderWidth, borderWidth);
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




# pragma mask : tools


/**
 根据布局属性计算最终需要绘制的正方形矩形尺寸以及图片绘制区域frame;

 @param contentMode 图片的布局属性
 @param width 需要计算的正方形矩形尺寸(width);输出参数;
 @return 图片绘制区域;
 */
- (CGRect) newImageFrameWithContentMode:(UIViewContentMode)contentMode newImageWidth:(CGFloat*)width {
    CGSize imageSize = self.size;
    CGRect newFrame = CGRectZero;
    CGFloat newWidth = 0;
    switch (contentMode) {
        case UIViewContentModeScaleToFill: // 直接填充
        {
            newWidth = MIN(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = newWidth;
            newFrame.size.height = newWidth;
        }
            break;
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        case UIViewContentModeRedraw:
        case UIViewContentModeCenter:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            if (imageSize.width > imageSize.height) {
                newFrame.origin.y = (newWidth - imageSize.height)/2;
            } else {
                newFrame.origin.x = (newWidth - imageSize.width)/2;
            }
        }
            break;
        case UIViewContentModeTop:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.x = (newWidth - imageSize.width)/2;
        }
            break;
        case UIViewContentModeBottom:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.x = (newWidth - imageSize.width)/2;
            newFrame.origin.y = (newWidth - imageSize.height);
        }
            break;
        case UIViewContentModeLeft:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.y = (newWidth - imageSize.height)/2;
        }
            break;
        case UIViewContentModeRight:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.y = (newWidth - imageSize.height)/2;
            newFrame.origin.x = (newWidth - imageSize.width);
        }
            break;
        case UIViewContentModeTopLeft:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
        }
            break;
        case UIViewContentModeTopRight:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.x = (newWidth - imageSize.width);
        }
            break;
        case UIViewContentModeBottomLeft:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.y = (newWidth - imageSize.height);
        }
            break;
        case UIViewContentModeBottomRight:
        {
            newWidth = MAX(imageSize.width, imageSize.height);
            *width = newWidth;
            newFrame.size.width = imageSize.width;
            newFrame.size.height = imageSize.height;
            newFrame.origin.y = (newWidth - imageSize.height);
            newFrame.origin.x = (newWidth - imageSize.width);
        }
            break;
        default:
            break;
    }
    return newFrame;
}




/**
 根据长宽比，计算需要绘制的大小；并计算图片在绘制区的Frame；
 绘制大小通过width和height参数返回；

 @param contentMode 图片布局属性;
 @param w2h 长宽比;
 @param width 绘制区的width(回参);
 @param height 绘制区的height(回参);
 @return 图片在绘制区的frame;
 */
- (CGRect) newImageFrameWithContentMode:(UIViewContentMode)contentMode w2h:(CGFloat)w2h newImageWidth:(CGFloat*)width  newImageHeight:(CGFloat*)height{
    CGSize imageSize = self.size;
    CGRect newFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGFloat curW2H = imageSize.width / imageSize.height;
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill: // 直接填充
        {
            *width = MIN(imageSize.width, imageSize.height);
            *height = *width / w2h;
            newFrame.size.width = *width;
            newFrame.size.height = *height;
        }
            break;
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        case UIViewContentModeRedraw:
        case UIViewContentModeCenter:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
                newFrame.origin.y = (*width - newFrame.size.height)/2;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
                newFrame.origin.x = (*width - newFrame.size.width)/2;
            }
        }
            break;
        case UIViewContentModeTop:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
                newFrame.origin.x = (*width - newFrame.size.width)/2;
            }
        }
            break;
        case UIViewContentModeBottom:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
                newFrame.origin.y = *height - imageSize.height;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
                newFrame.origin.x = (*width - newFrame.size.width)/2;
            }
        }
            break;
        case UIViewContentModeLeft:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
                newFrame.origin.y = (*height - newFrame.size.height)/2;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
            }
        }
            break;
        case UIViewContentModeRight:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
                newFrame.origin.y = (*height - newFrame.size.height)/2;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
                newFrame.origin.x = (*width - newFrame.size.width);
            }
        }
            break;
        case UIViewContentModeTopLeft:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
            }
        }
            break;
        case UIViewContentModeTopRight:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
                newFrame.origin.x = (*width - newFrame.size.width);
            }
        }
            break;
        case UIViewContentModeBottomLeft:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
                newFrame.origin.y = (*height - newFrame.size.height);
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
            }
        }
            break;
        case UIViewContentModeBottomRight:
        {
            if (curW2H > w2h) {
                *width = imageSize.width;
                *height = *width / w2h;
                newFrame.origin.y = (*height - newFrame.size.height);
            } else {
                *height = imageSize.height;
                *width = *height * w2h;
                newFrame.origin.x = (*width - newFrame.size.width);
            }
        }
            break;
        default:
            break;
    }
    return newFrame;
}



/**
 根据提供的尺寸大小和布局生成图片的区域;
 图片需要按实际比例缩放，填充在指定的尺寸里面;

 @param contentMode 图片布局属性;
 @param newSize 指定的尺寸大小;
 @return 缩放后的图片在指定尺寸中的区域;
 */
- (CGRect) newImageFrameWithContentMode:(UIViewContentMode)contentMode newSize:(CGSize)newSize{
    CGSize imageSize = self.size;
    CGRect newFrame = CGRectZero;
    CGFloat w2h = newSize.width / newSize.height;
    CGFloat curW2H = imageSize.width / imageSize.height;
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill: // 直接填充
        {
            newFrame.size.width = newSize.width;
            newFrame.size.height = newSize.height;
        }
            break;
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        case UIViewContentModeRedraw:
        case UIViewContentModeCenter:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
                newFrame.origin.y = (newSize.height - newFrame.size.height)/2;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
                newFrame.origin.x = (newSize.width - newFrame.size.width)/2;
            }
        }
            break;
        case UIViewContentModeTop:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
                newFrame.origin.x = (newSize.width - newFrame.size.width)/2;
            }
        }
            break;
        case UIViewContentModeBottom:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
                newFrame.origin.y = newSize.height - newFrame.size.height;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
                newFrame.origin.x = (newSize.width - newFrame.size.width)/2;
            }
        }
            break;
        case UIViewContentModeLeft:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
                newFrame.origin.y = (newSize.height - newFrame.size.height)/2;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
            }
        }
            break;
        case UIViewContentModeRight:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
                newFrame.origin.y = (newSize.height - newFrame.size.height)/2;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
                newFrame.origin.x = (newSize.width - newFrame.size.width);
            }
        }
            break;
        case UIViewContentModeTopLeft:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
            }
        }
            break;
        case UIViewContentModeTopRight:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
                newFrame.origin.x = (newSize.width - newFrame.size.width);
            }
        }
            break;
        case UIViewContentModeBottomLeft:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
                newFrame.origin.y = (newSize.height - newFrame.size.height);
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
            }
        }
            break;
        case UIViewContentModeBottomRight:
        {
            if (curW2H > w2h) {
                newFrame.size.width = newSize.width;
                newFrame.size.height = newSize.width / curW2H;
                newFrame.origin.y = (newSize.height - newFrame.size.height);
            } else {
                newFrame.size.height = newSize.height;
                newFrame.size.width = newSize.height * curW2H;
                newFrame.origin.x = (newSize.width - newFrame.size.width);
            }
        }
            break;
        default:
            break;
    }
    return newFrame;
}


@end

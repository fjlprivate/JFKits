//
//  UIImage+Extension.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

# pragma mask : 缩放

# pragma mask : 裁剪形状

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
                       backgroundColor:(UIColor*)backgroundColor;



/**
 裁剪圆角(包括圆形);
 按下列属性裁剪;
 裁剪是以图片的实际尺寸在裁的，所以圆角和边框宽度都要按实际尺寸的比例来传递;
 
 @param contentMode 布局模式
 @param cornerRadius 圆角大小，分横竖
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 @param backgroundColor 背景色
 @return 裁剪后的图片
 */
- (UIImage*) imageCutedWithContentMode:(UIViewContentMode)contentMode
                          cornerRadius:(CGSize)cornerRadius
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor*)borderColor
                       backgroundColor:(UIColor*)backgroundColor;




# pragma mask : 裁剪部分图片

/**
 裁剪出指定size的图片;
 从左上角开始;

 @param newSize 裁剪size;
 @return 裁剪后的图片;
 */
- (UIImage*) imageCutedWithNewSize:(CGSize)newSize;


/**
 裁剪出指定size的图片;
 按指定的位置;
 
 @param newSize 裁剪size;
 @param contentMode 指定位置;
 @return 裁剪后的图片;
 */
- (UIImage*) imageCutedWithNewSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode;






@end

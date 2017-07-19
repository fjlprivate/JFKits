//
//  UIImage+Extension.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


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


@end

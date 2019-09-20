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
 裁剪+缩放+边框;
 相当于下面3个图片处理的集合;
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
                  backgroundColor:(UIColor*)backgroundColor;



/**
 等比缩放图片;不裁剪;
 @param size 缩放的尺寸(不考虑scale;处理中才考虑);
 @return 缩放后的图片;
 */
- (UIImage*) jf_imageScaledToSize:(CGSize)size;

/**
 裁剪图片;不缩放;
 @param contentMode 裁剪模式;
 @param inSize 裁剪的尺寸;图片中实际裁剪的尺寸;要计算image.scale?????
 @return 裁剪后的图片;
 */
- (UIImage*) jf_imageTrimedWithContentMode:(UIViewContentMode)contentMode
                                    inSize:(CGSize)inSize;


/**
 裁剪边框和圆角;
 @param cornerRadius 圆角值(含widthRadius,heightRadius);
 @param borderWidth 边框宽度;
 @param borderColor 边框颜色;
 @param backgroundColor 背景色;
 @return 裁剪后的图片;
 */
- (UIImage*) jf_imageTrimedWithCornerRadius:(CGSize)cornerRadius
                                 boderWidth:(CGFloat)borderWidth
                                borderColor:(UIColor*)borderColor
                            backgroundColor:(UIColor*)backgroundColor;



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
                     cornerRadius:(CGSize)cornerRadius;


@end

//
//  JFTextStorage.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * [文本缓存类]
 *
 * 缓存文本，以及文本属性，还有高亮属性:
 * 文本属性: 
 *      1. NSA
 */

@interface JFTextStorage : NSObject


/**
 生成textStorage

 @param text 文本
 @param frame 文本frame
 @return textStorage
 */
+ (instancetype) jf_textStorageWithText:(NSString*)text frame:(CGRect)frame;

@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UIFont* textFont; // 字体
@property (nonatomic, strong) UIColor* textColor; // 文本色

@property (nonatomic, strong) UIColor* backgroundColor; // 背景色

@property (nonatomic, assign) NSInteger numberOfLines; // 文本行数

// 字间距、行间距、对齐



/**
 给文本的指定位置设置属性;

 @param attributeName 属性名: NSFontAttributeName, NSForegroundAttributeName等;
 @param value 属性相关值;
 @param range 指定的区间;
 */
- (void) setAttribute:(NSString*)attributeName withValue:(id)value atRange:(NSRange)range;



/**
 设置[背景色]到指定的区间;

 @param backgroundColor 背景色;
 @param range 指定区间;
 */
- (void) setBackgroundColor:(UIColor*)backgroundColor atRange:(NSRange)range;


/**
 插入[图片]到指定的位置;
 如果指定的位置已经有图片了，则替换掉原来的图片;

 @param image 图片;
 @param imageSize 图片大小;
 @param position 指定的位置;
 */
- (void) setImage:(UIImage*)image imageSize:(CGSize)imageSize atPosition:(NSInteger)position;


/**
 添加[点击事件];
 指定区间和高亮颜色;
 绑定关联数据;

 @param data 关联数据: 比如，网址、电话号码等;在点击事件中，处理关联的数据;
 @param textSelectedColor 点击时的文本高亮色;
 @param backSelectedColor 点击时的文本背景色;
 @param range 指定区间;
 */
- (void) addLinkWithData:(id)data
       textSelectedColor:(UIColor*)textSelectedColor
       backSelectedColor:(UIColor*)backSelectedColor
                 atRange:(NSRange)range;





/**
 绘制文本缓存到上下文;
 分别绘制背景色、文本、边框、附件;

 @param context 图形上下文;
 */
- (void) drawInContext:(CGContextRef)context;

@end

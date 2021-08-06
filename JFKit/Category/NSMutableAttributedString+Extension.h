//
//  NSMutableAttributedString+Extension.h
//  JFKitDemo
//
//  Created by johnny feng on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSMutableAttributedString (Extension)

/**
 设置字体属性;
 没有range参数的方法代表整个文本区间;
 @param font 字体属性;
 @param range 指定要设置的区间;
 */
- (void) jf_setFont:(UIFont *)font atRange:(NSRange)range;
- (void) jf_setFont:(UIFont *)font;

/**
 设置文本颜色属性;
 没有range参数的方法代表整个文本区间;
 @param textColor 文本颜色;
 @param range 指定要设置的区间;
 */
- (void) jf_setTextColor:(UIColor *)textColor atRange:(NSRange)range;
- (void) jf_setTextColor:(UIColor *)textColor;

/**
 设置文本背景色;
 没有range参数的方法代表整个文本区间;
 @param backgroundColor 文字的背景色;
 @param range 指定要设置的区间;
 */
- (void) jf_setBackgroundColor:(UIColor*)backgroundColor atRange:(NSRange)range;
- (void) jf_setBackgroundColor:(UIColor*)backgroundColor;

/**
 设置文本字间距;
 没有range参数的方法代表整个文本区间;
 @param kern 字间距的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setKern:(CGFloat)kern atRange:(NSRange)range;
- (void) jf_setKern:(CGFloat)kern;

/**
 设置行间距;
 没有range参数的方法代表整个文本区间;
 @param lineSpacing 行间距的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setLineSpacing:(CGFloat)lineSpacing atRange:(NSRange)range;
- (void) jf_setLineSpacing:(CGFloat)lineSpacing;

/**
 设置文本排版;
 @param textAlignment 文本排版;
 @param range 指定要设置的区间;
 */
- (void) jf_setTextAlignment:(NSTextAlignment)textAlignment atRange:(NSRange)range;
- (void) jf_setTextAlignment:(NSTextAlignment)textAlignment;

/**
 设置段头缩进;
 没有range参数的方法代表整个文本区间;
 @param firstLineHeadIndent 段头缩进的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent atRange:(NSRange)range;
- (void) jf_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent;

/**
 设置行缩进;
 没有range参数的方法代表整个文本区间;
 @param lineHeadIndent 行缩进的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setLineHeadIndent:(CGFloat)lineHeadIndent atRange:(NSRange)range;
- (void) jf_setLineHeadIndent:(CGFloat)lineHeadIndent;

@end

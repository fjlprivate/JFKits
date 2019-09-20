//
//  NSMutableAttributedString+Extension.h
//  JFKitDemo
//
//  Created by johnny feng on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JFTextAttachmentImage;           // 图片附件
@class JFTextAttachmentHighlight;       // 高亮附件


@interface NSMutableAttributedString (Extension)

/**
 设置字体属性;
 没有range参数的方法代表整个文本区间;
 @param font 字体属性;
 @param range 指定要设置的区间;
 */
- (void) jf_setFont:(UIFont *)font atRange:(NSRange)range;
- (void) jf_setFont:(UIFont *)font;
/* getter */
//- (UIFont*) jf_getFontAtRange:(NSRange)range;
//- (UIFont*) jf_getFont;


/**
 设置文本颜色属性;
 没有range参数的方法代表整个文本区间;
 @param textColor 文本颜色;
 @param range 指定要设置的区间;
 */
- (void) jf_setTextColor:(UIColor *)textColor atRange:(NSRange)range;
- (void) jf_setTextColor:(UIColor *)textColor;
/* getter */
//- (UIColor*) jf_getTextColorAtRange:(NSRange)range;
//- (UIColor*) jf_getTextColor;


/**
 设置文本背景色;
 没有range参数的方法代表整个文本区间;
 @param backgroundColor 文字的背景色;
 @param range 指定要设置的区间;
 */
- (void) jf_setBackgroundColor:(UIColor*)backgroundColor atRange:(NSRange)range;
- (void) jf_setBackgroundColor:(UIColor*)backgroundColor;
/* getter */
//- (UIColor*) jf_getBackgroundColorAtRange:(NSRange)range;
//- (UIColor*) jf_getBackgroundColor;

/**
 设置文本字间距;
 没有range参数的方法代表整个文本区间;
 @param kern 字间距的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setKern:(CGFloat)kern atRange:(NSRange)range;
- (void) jf_setKern:(CGFloat)kern;
/* getter */
//- (CGFloat) jf_getKernAtRange:(NSRange)range;
//- (CGFloat) jf_getKern;

/**
 设置行间距;
 没有range参数的方法代表整个文本区间;
 @param lineSpacing 行间距的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setLineSpacing:(CGFloat)lineSpacing atRange:(NSRange)range;
- (void) jf_setLineSpacing:(CGFloat)lineSpacing;
/* getter */
//- (CGFloat) jf_getLineSpacingAtRange:(NSRange)range;
//- (CGFloat) jf_getLineSpacing;


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
/* getter */
//- (CGFloat) jf_getFirstLineHeadIndentAtRange:(NSRange)range;
//- (CGFloat) jf_getFirstLineHeadIndent;

/**
 设置行缩进;
 没有range参数的方法代表整个文本区间;
 @param lineHeadIndent 行缩进的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setLineHeadIndent:(CGFloat)lineHeadIndent atRange:(NSRange)range;
- (void) jf_setLineHeadIndent:(CGFloat)lineHeadIndent;
/* getter */
//- (CGFloat) jf_getLineHeadIndentAtRange:(NSRange)range;
//- (CGFloat) jf_getLineHeadIndent;

/**
 设置附件:高亮;
 实际就是对指定range的文本添加背景色;在指定的时机显示;
 所以用set而不是add;
 @param highlight 高亮附件;
 */
- (void) jf_setHighlight:(JFTextAttachmentHighlight*)highlight;


/**
 添加附件:图片;
 因为图片要插入到attributedString,会使range变动;
 **注意!注意!注意!:**所以要在其他属性设置前，添加图片;
 @param image 图片附件;
 */
- (void) jf_addImage:(JFTextAttachmentImage*)image;



@end

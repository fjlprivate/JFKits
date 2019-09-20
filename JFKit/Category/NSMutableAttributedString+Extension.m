//
//  NSMutableAttributedString+Extension.m
//  JFKitDemo
//
//  Created by johnny feng on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "NSMutableAttributedString+Extension.h"
#import <CoreText/CoreText.h>
#import "JFAsyncDisplayKit.h"


@implementation NSMutableAttributedString (Extension)

/**
 设置字体属性;
 没有range参数的方法代表整个文本区间;
 @param font 字体属性;
 @param range 指定要设置的区间;
 */
- (void) jf_setFont:(UIFont *)font atRange:(NSRange)range {
    if (!font) {
        return;
    }
    [self addAttribute:NSFontAttributeName value:font range:range];
}
- (void) jf_setFont:(UIFont *)font {
    if (!font) {
        return;
    }
    [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
}


/**
 设置文本颜色属性;
 没有range参数的方法代表整个文本区间;
 @param textColor 文本颜色;
 @param range 指定要设置的区间;
 */
- (void) jf_setTextColor:(UIColor *)textColor atRange:(NSRange)range {
    if (!textColor) {
        return;
    }
    [self addAttribute:NSForegroundColorAttributeName value:textColor range:range];
}
- (void) jf_setTextColor:(UIColor *)textColor {
    if (!textColor) {
        return;
    }
    [self jf_setTextColor:textColor atRange:NSMakeRange(0, self.length)];
}

/**
 设置文本背景色;
 没有range参数的方法代表整个文本区间;
 @param backgroundColor 文字的背景色;
 @param range 指定要设置的区间;
 */
- (void) jf_setBackgroundColor:(UIColor*)backgroundColor atRange:(NSRange)range {
    if (!backgroundColor) {
        return;
    }
    [self addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}
- (void) jf_setBackgroundColor:(UIColor*)backgroundColor {
    [self jf_setBackgroundColor:backgroundColor atRange:NSMakeRange(0, self.length)];
}

/**
 设置文本字间距;
 没有range参数的方法代表整个文本区间;
 @param kern 字间距的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setKern:(CGFloat)kern atRange:(NSRange)range {
    [self addAttribute:NSKernAttributeName value:@(kern) range:range];
}
- (void) jf_setKern:(CGFloat)kern {
    [self jf_setKern:kern atRange:NSMakeRange(0, self.length)];
}

/**
 设置行间距;
 没有range参数的方法代表整个文本区间;
 @param lineSpacing 行间距的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setLineSpacing:(CGFloat)lineSpacing atRange:(NSRange)range {
    if (range.location == NSNotFound || range.location + range.length > self.length) {
        range = NSMakeRange(0, 0);
    }
    NSParagraphStyle* paragraphStyle = [self attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
    NSMutableParagraphStyle* mutableParagraphStyle = [NSMutableParagraphStyle new];
    if (paragraphStyle) {
        mutableParagraphStyle = paragraphStyle.mutableCopy;
    }
    mutableParagraphStyle.lineSpacing = lineSpacing;
    [self addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle.copy range:range];
}
- (void) jf_setLineSpacing:(CGFloat)lineSpacing {
    [self jf_setLineSpacing:lineSpacing atRange:NSMakeRange(0, self.length)];
}

/**
 设置文本排版;
 @param textAlignment 文本排版;
 @param range 指定要设置的区间;
 */
- (void) jf_setTextAlignment:(NSTextAlignment)textAlignment atRange:(NSRange)range {
    if (range.location == NSNotFound || range.location + range.length > self.length) {
        range = NSMakeRange(0, 0);
    }
    NSParagraphStyle* paragraphStyle = [self attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
    NSMutableParagraphStyle* mutableParagraphStyle = [NSMutableParagraphStyle new];
    if (paragraphStyle) {
        mutableParagraphStyle = paragraphStyle.mutableCopy;
    }
    mutableParagraphStyle.alignment = textAlignment;
    [self addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle.copy range:range];
}
- (void) jf_setTextAlignment:(NSTextAlignment)textAlignment {
    [self jf_setTextAlignment:textAlignment atRange:NSMakeRange(0, self.length)];
}


/**
 设置段头缩进;
 没有range参数的方法代表整个文本区间;
 @param firstLineHeadIndent 段头缩进的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent atRange:(NSRange)range {
    if (range.location == NSNotFound || range.location + range.length > self.length) {
        range = NSMakeRange(0, 0);
    }
    NSParagraphStyle* paragraphStyle = [self attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
    NSMutableParagraphStyle* mutableParagraphStyle = [NSMutableParagraphStyle new];
    if (paragraphStyle) {
        mutableParagraphStyle = paragraphStyle.mutableCopy;
    }
    mutableParagraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    [self addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle.copy range:range];
}
- (void) jf_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self jf_setFirstLineHeadIndent:firstLineHeadIndent atRange:NSMakeRange(0, self.length)];
}

/**
 设置行缩进;
 没有range参数的方法代表整个文本区间;
 @param lineHeadIndent 行缩进的值;
 @param range 指定要设置的区间;
 */
- (void) jf_setLineHeadIndent:(CGFloat)lineHeadIndent atRange:(NSRange)range {
    if (range.location == NSNotFound || range.location + range.length > self.length) {
        range = NSMakeRange(0, 0);
    }
    NSParagraphStyle* paragraphStyle = [self attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
    NSMutableParagraphStyle* mutableParagraphStyle = [NSMutableParagraphStyle new];
    if (paragraphStyle) {
        mutableParagraphStyle = paragraphStyle.mutableCopy;
    }
    mutableParagraphStyle.headIndent = lineHeadIndent;
    [self addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle.copy range:range];
}
- (void) jf_setLineHeadIndent:(CGFloat)lineHeadIndent {
    [self jf_setLineHeadIndent:lineHeadIndent atRange:NSMakeRange(0, self.length)];
}


/**
 设置附件:高亮;
 实际就是对指定range的文本添加背景色;在指定的时机显示;
 所以用set而不是add;
 @param highlight 高亮附件;
 */
- (void) jf_setHighlight:(JFTextAttachmentHighlight*)highlight {
    if (!highlight) {
        return;
    }
    if (highlight.range.location == NSNotFound || highlight.range.location + highlight.range.length > self.length) {
        return;
    }
    // 先移除旧的高亮属性
    [self removeAttribute:JFTextAttachmentHighlightName range:highlight.range];
    // 背景色
//    [self removeAttribute:NSBackgroundColorAttributeName range:highlight.range];
//    [self addAttribute:NSBackgroundColorAttributeName
//                 value:highlight.isHighlight ? highlight.highlightBackgroundColor : highlight.normalBackgroundColor
//                 range:highlight.range];
    // 文本色
    [self removeAttribute:NSForegroundColorAttributeName range:highlight.range];
    [self addAttribute:NSForegroundColorAttributeName
                 value:highlight.isHighlight ? highlight.highlightTextColor : highlight.normalTextColor
                 range:highlight.range];
    // 添加高亮属性
    [self addAttribute:JFTextAttachmentHighlightName value:highlight range:highlight.range];
}


/**
 添加附件:图片;
 因为图片要插入到attributedString,会使range变动;
 **注意!注意!注意!:**所以要在其他属性设置前，添加图片;
 @param image 图片附件;
 */
- (void) jf_addImage:(JFTextAttachmentImage*)image {
    if (!image) {
        return;
    }
    if (!image.image) {
        return;
    }
    if (image.imageSize.width < 0.1 || image.imageSize.height < 0.1) {
        return;
    }
    if (image.index == NSNotFound || image.index < 0) {
        image.index = 0;
    }
    if (image.index > self.length) {
        image.index = self.length;
    }
    // 插入占位符
    NSString* placeholder = @"\ufffc";
    [self insertAttributedString:[[NSMutableAttributedString alloc] initWithString:placeholder] atIndex:image.index];
    // 给占位符设置字形属性
    CTRunDelegateCallbacks runDelegateCallBacks;
    memset(&runDelegateCallBacks, 0, sizeof(CTRunDelegateCallbacks));
    runDelegateCallBacks.getAscent = JFImageRunGetAscent;
    runDelegateCallBacks.getDescent = JFImageRunGetDescent;
    runDelegateCallBacks.getWidth = JFImageRunGetWidth;
    runDelegateCallBacks.version = kCTRunDelegateVersion1;
    CTRunDelegateRef imageRunDelegate = CTRunDelegateCreate(&runDelegateCallBacks, (__bridge void*)image);
    // 用CoreFoundation框架给富文本添加字形属性
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef)self, CFRangeMake(image.index, 1), kCTRunDelegateAttributeName, imageRunDelegate);
    // 将图片附件以属性方式添加到富文本
    [self addAttribute:JFTextAttachmentImageName value:image range:NSMakeRange(image.index, 1)];
}



@end

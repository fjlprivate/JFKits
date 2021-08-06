//
//  NSMutableAttributedString+JFAsyncDiaplayKit.m
//  JFKitDemo
//
//  Created by fjl on 2021/8/6.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "NSMutableAttributedString+JFAsyncDiaplayKit.h"
#import "JFAsyncDisplayKit.h"

@implementation NSMutableAttributedString (JFAsyncDiaplayKit)

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

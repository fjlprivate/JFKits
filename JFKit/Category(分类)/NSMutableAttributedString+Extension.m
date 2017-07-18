//
//  NSMutableAttributedString+Extension.m
//  JFKitDemo
//
//  Created by johnny feng on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "NSMutableAttributedString+Extension.h"
#import <CoreText/CoreText.h>


static CGFloat attachmentAscentCallBack(void* config) {
    JFTextAttachment* attachment = (__bridge JFTextAttachment*)config;
    return attachment.contentSize.height;
}
static CGFloat attachmentDesentCallBack(void* config) {
    return 0;
}
static CGFloat attachmentWidthCallBack(void* config) {
    JFTextAttachment* attachment = (__bridge JFTextAttachment*)config;
    return attachment.contentSize.width;
}
static void attachmentDeallocCallBack(void* config) {
    
}

@implementation NSMutableAttributedString (Extension)




- (void) setFont:(UIFont *)font {
    [self setAttribute:NSFontAttributeName withValue:font atRange:NSMakeRange(0, self.length)];
}
- (void) setFont:(UIFont *)font atRange:(NSRange)range {
    [self setAttribute:NSFontAttributeName withValue:font atRange:range];
}

- (void) setTextColor:(UIColor *)textColor {
    [self setAttribute:NSForegroundColorAttributeName withValue:textColor atRange:NSMakeRange(0, self.length)];
}
- (void) setTextColor:(UIColor *)textColor atRange:(NSRange)range {
    [self setAttribute:NSForegroundColorAttributeName withValue:textColor atRange:range];
}

- (void) addTextHighLight:(JFTextHighLight*)highLight {
    [self setAttribute:JFTextHighLightName withValue:highLight atRange:highLight.range];
}
- (void) addTextAttachment:(JFTextAttachment*)textAttachment {
    //在图片位置填充一个占位符
    NSString* placeholder = @"\ufffc";
    NSMutableAttributedString* spaceAttri = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [self insertAttributedString:spaceAttri atIndex:textAttachment.range.location];
    
    // run回调，负责提供字形属性
    CTRunDelegateCallbacks runCallBacks;
    memset(&runCallBacks, 0, sizeof(CTRunDelegateCallbacks));
    runCallBacks.getAscent = attachmentAscentCallBack;
    runCallBacks.getDescent = attachmentDesentCallBack;
    runCallBacks.getWidth = attachmentWidthCallBack;
    runCallBacks.dealloc = attachmentDeallocCallBack;
    runCallBacks.version = kCTRunDelegateVersion1;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&runCallBacks, (__bridge void*)textAttachment);
    // 给占位符设置runDelegate属性，这个属性提供占位符的字型属性:ascent,desent,width
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)self, CFRangeMake(textAttachment.range.location, textAttachment.range.length), kCTRunDelegateAttributeName, runDelegate);
    
    // 并给这个占位符添加一个包含附件对象的属性，用于后面获取附件并绘制
    [self setAttribute:JFTextAttachmentName withValue:textAttachment atRange:textAttachment.range];
}
- (void) addTextBackgroundColor:(JFTextBackgoundColor*)textBackgroundColor {
    [self setAttribute:JFTextBackgroundColorName withValue:textBackgroundColor atRange:textBackgroundColor.range];
}




/**
 设置[属性]到指定的区域;
 
 @param attributeName 属性名; 比如 NSFontAttributeName等
 @param value 属性值对象;
 @param range 指定的区域;
 */
- (void) setAttribute:(NSString*)attributeName withValue:(id)value atRange:(NSRange)range {
//    NSLog(@"======给attributeString设置属性range[%@]name[%@]:value{%@}", NSStringFromRange(range), attributeName, value);
    if (!attributeName) {
        return;
    }
    if (value) {
        [self addAttribute:attributeName value:value range:range];
    } else {
        [self removeAttribute:attributeName range:range];
    }
}



@end

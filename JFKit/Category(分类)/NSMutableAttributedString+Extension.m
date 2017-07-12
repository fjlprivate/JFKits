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
    CFDictionaryRef size = (CFDictionaryRef)config;
    NSDictionary* dic = (__bridge_transfer NSDictionary*)size;
    return [[dic objectForKey:@"height"] floatValue];
}
static CGFloat attachmentDesentCallBack(void* config) {
    return 0;
}
static CGFloat attachmentWidthCallBack(void* config) {
    CFDictionaryRef size = (CFDictionaryRef)config;
    NSDictionary* dic = (__bridge_transfer NSDictionary*)size;
    return [[dic objectForKey:@"width"] floatValue];
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
    NSString* placeholder = @"\ufffc";
    NSMutableAttributedString* spaceAttri = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [self insertAttributedString:spaceAttri atIndex:textAttachment.range.location];
    
    CTRunDelegateCallbacks runCallBacks;
    memset(&runCallBacks, 0, sizeof(CTRunDelegateCallbacks));
    runCallBacks.getAscent = attachmentAscentCallBack;
    runCallBacks.getDescent = attachmentDesentCallBack;
    runCallBacks.getWidth = attachmentWidthCallBack;
    runCallBacks.dealloc = attachmentDeallocCallBack;
    runCallBacks.version = kCTRunDelegateVersion1;
    
    NSDictionary* config = @{@"width":@(textAttachment.contentSize.width),@"height":@(textAttachment.contentSize.height)};
    CFDictionaryRef kConfig = (__bridge_retained CFDictionaryRef)config;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&runCallBacks, (void*)kConfig);
    // 给
    [self addAttribute:(__bridge NSString*)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:textAttachment.range];
    
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

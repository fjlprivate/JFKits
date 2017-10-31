//
//  NSMutableAttributedString+Extension.h
//  JFKitDemo
//
//  Created by johnny feng on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTextAttachment.h"

@interface NSMutableAttributedString (Extension)


/**
 设置[属性]到指定的区域;

 @param attributeName 属性名; 比如 NSFontAttributeName等
 @param value 属性值对象;
 @param range 指定的区域;
 */
- (void) setAttribute:(NSString *)attributeName withValue:(id)value atRange:(NSRange)range;

- (void) setFont:(UIFont *)font;
- (void) setFont:(UIFont *)font atRange:(NSRange)range;

- (void) setTextColor:(UIColor *)textColor;
- (void) setTextColor:(UIColor *)textColor atRange:(NSRange)range;


- (void) addTextHighLight:(JFTextHighLight*)highLight;
- (void) addTextAttachment:(JFTextAttachment*)textAttachment;
- (void) addTextBackgroundColor:(JFTextBackgoundColor*)textBackgroundColor;



/**
 用[附件]替换掉指定区间的文本;

 @param range 文本区间:指定要替换的;
 @param textAttachment 替换的附件;
 @return 有替换:返回YES;无替换:返回NO;
 */
- (BOOL) replayceTextAtRange:(NSRange)range withAttachment:(JFTextAttachment*)textAttachment;


@end

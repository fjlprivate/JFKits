//
//  JFTextStorage.h
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/25.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFTextAttachment.h"


@interface JFTextStorage : NSObject

+ (instancetype) storageWithText:(NSString*)text;

@property (nonatomic, strong) UIFont*   font;
@property (nonatomic, strong) UIColor*  textColor;
@property (nonatomic, assign) CGFloat   lineSpacing;
@property (nonatomic, assign) CGFloat   kern;
@property (nonatomic, assign) NSTextAlignment textAlignment;
// 用于显示文字的背景
@property (nonatomic, strong) UIColor*  backgroundColor;

- (void) setFont:(UIFont *)font atRange:(NSRange)range;
- (void) setTextColor:(UIColor *)textColor atRange:(NSRange)range;
- (void) setLineSpacing:(CGFloat)lineSpacing atRange:(NSRange)range;
- (void) setKern:(CGFloat)kern atRange:(NSRange)range;
- (void) setBackgroundColor:(UIColor *)backgroundColor atRange:(NSRange)range;
- (void) setTextAlignment:(NSTextAlignment)textAlignment atRange:(NSRange)range;

// 添加一个高亮附件
- (void) addHighlight:(JFTextAttachmentHighlight*)highlight;
// 缓存的高亮附件组
@property (nonatomic, strong) NSMutableArray* highlights;

// 添加一个图片附件
- (void) addImage:(JFTextAttachmentImage*)image;
// 缓存的图片附件组
@property (nonatomic, strong) NSMutableArray* images;

// 富文本
@property (nonatomic, strong, readonly) NSMutableAttributedString* text;

@end

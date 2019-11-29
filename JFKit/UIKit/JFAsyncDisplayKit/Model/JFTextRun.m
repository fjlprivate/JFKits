//
//  JFTextRun.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFTextRun.h"
#import "JFTextAttachment.h"

@implementation JFTextRun


+ (instancetype) textRunWithCTRun:(CTRunRef)ctRun
                     ctLineOrigin:(CGPoint)ctLineOrigin
                            frame:(CGRect)frame
                        cancelled:(IsCancelled)cancelled
{
    return [[JFTextRun alloc] initWithCTRun:ctRun ctLineOrigin:ctLineOrigin frame:frame cancelled:cancelled];
}

- (instancetype) initWithCTRun:(CTRunRef)ctRun
                  ctLineOrigin:(CGPoint)ctLineOrigin
                         frame:(CGRect)frame
                     cancelled:(IsCancelled)cancelled
{
    self = [super init];
    if (cancelled()) return nil;
    // 获取所有字形
    CFIndex glyphsCount = CTRunGetGlyphCount(ctRun);
    CGGlyph glyphs[glyphsCount];
    CTRunGetGlyphs(ctRun, CFRangeMake(0, 0), glyphs);
    if (cancelled()) return nil;
    // 获取所有字形的起点
    CGPoint glyphsOrigins[glyphsCount];
    CTRunGetPositions(ctRun, CFRangeMake(0, 0), glyphsOrigins);
    if (cancelled()) return nil;
    // 获取布局属性
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CGFloat width = CTRunGetTypographicBounds(ctRun, CFRangeMake(0, 0), &ascent, &descent, &leading);
    
    if (cancelled()) return nil;
    // 获取翻转的仿射矩阵
    CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    tt = CGAffineTransformScale(tt, 1, -1);
    CGRect ctFrame = CGRectMake(ctLineOrigin.x + glyphsOrigins[0].x,
                                ctLineOrigin.y - descent,
                                width,
                                ascent + descent);
    CGRect uiFrame = CGRectApplyAffineTransform(ctFrame, tt);
    if (cancelled()) return nil;
    // 获取富文本的附件属性
    CFDictionaryRef attributes = CTRunGetAttributes(ctRun);
    NSDictionary* attriDic = (__bridge NSDictionary*)attributes;
    // 缓存附件
    NSMutableArray* images = @[].mutableCopy;
    NSMutableArray* highlights = @[].mutableCopy;
    for (NSString* key in attriDic.allKeys) {
        if (cancelled()) return nil;
        // 计算高亮附件的UIFrame
        if ([key isEqualToString:JFTextAttachmentHighlightName]) {
            JFTextAttachmentHighlight* highlight = [attriDic objectForKey:key];
            [highlight.uiFrames addObject:[NSValue valueWithCGRect:uiFrame]];
            [highlights addObject:highlight];
        }
        // 计算图片附件的UIFrame&CTFrame
        else if ([key isEqualToString:JFTextAttachmentImageName]) {
            JFTextAttachmentImage* image = [attriDic objectForKey:key];
            if (image.imageSize.height > 0.01) {
                uiFrame.size.width = uiFrame.size.height * image.imageSize.width/image.imageSize.height;
                ctFrame.size.width = ctFrame.size.height * image.imageSize.width/image.imageSize.height;
            }
            // 如果不更新origin.y，在图片下面会超出汉字底部，很难看
            CGRect iframe = uiFrame;
            iframe.origin.y -= descent * 0.25;
            image.uiFrame = iframe;
            iframe = ctFrame;
            iframe.origin.y += descent * 0.25;
            image.ctFrame = iframe;
            [images addObject:image];
        }
        // 计算行间距
        else if ([key isEqualToString:NSParagraphStyleAttributeName]) {
            NSParagraphStyle* paragraphStyle = [attriDic objectForKey:key];
            _leading = paragraphStyle.lineSpacing;
        }
    }
    _imageAttachments = images.copy;
    return self;
}

@end

//
//  JFTextLine.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFTextLine.h"
#import "JFTextRun.h"

@interface JFTextLine()

@end

@implementation JFTextLine

/**
 创建并初始化JFTextLine;
 @param ctLine CoreText的行属性对象;
 @param origin 行的baseLine起点<CoreText坐标系>;
 @param frame 文本的frame;
 @param cancelled 退出初始化步骤;
 @return JFTextLine;cancelled退出时,返回nil;
 */
+ (instancetype) textLineWithCTLine:(CTLineRef)ctLine origin:(CGPoint)origin frame:(CGRect)frame cancelled:(IsCancelled)cancelled
{
    return [[self alloc] initWithCTLine:ctLine origin:origin frame:frame cancelled:cancelled];
}

- (instancetype) initWithCTLine:(CTLineRef)ctLine origin:(CGPoint)origin frame:(CGRect)frame cancelled:(IsCancelled)cancelled
{
    self = [super init];
    if (ctLine == NULL || frame.size.width < 0.1 || frame.size.height < 0.1) {
        return nil;
    }
    _ctLine = ctLine;
    _ctOrigin = origin;
    if (cancelled()) return nil;
    // 创建翻转坐标系的仿射
    CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, frame.origin.x, frame.origin.y + frame.size.height);
    tt = CGAffineTransformScale(tt, 1, -1);
    if (cancelled()) return nil;
    // 获取行的宽高等属性
    _width = CTLineGetTypographicBounds(ctLine, &_ascent, &_descent, &_leading);
    // 转换ctLine的<CoreText>起点到<UIKit>的起点
    CGRect ctFrame = CGRectMake(origin.x,
                                origin.y - _descent,
                                _width,
                                _ascent + _descent);
    CGRect uiFrame = CGRectApplyAffineTransform(ctFrame, tt);
    _uiOrigin = uiFrame.origin;
    if (cancelled()) return nil;
    //创建ctRun组
    CFArrayRef ctRuns = CTLineGetGlyphRuns(ctLine);
    CFIndex ctRunsCount = CFArrayGetCount(ctRuns);
    if (cancelled()) return nil;
    NSMutableArray* textRuns = @[].mutableCopy;
    CGFloat maxLeading = 0;
    for (CFIndex i = 0; i < ctRunsCount; i++) {
        if (cancelled()) return nil;
        CTRunRef ctRun = CFArrayGetValueAtIndex(ctRuns, i);
        JFTextRun* textRun = [JFTextRun textRunWithCTRun:ctRun ctLineOrigin:_ctOrigin frame:frame cancelled:cancelled];
        if (maxLeading < textRun.leading) {
            maxLeading = textRun.leading;
        }
        if (textRun) {
            [textRuns addObject:textRun];
        } else {
            return nil;
        }
    }
    _leading = maxLeading;
    _ctRuns = textRuns.copy;
    return self;
}

@end

//
//  JFTextLine.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/13.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFTextLine.h"

@interface JFTextLine()
@property (nonatomic, assign) CGRect textFrame; // 当前line所在文本的实际frame<UIKit坐标系>
@end

@implementation JFTextLine

- (instancetype) initWithLine:(CTLineRef)lineRef origin:(CGPoint)position textFrame:(CGRect)textFrame{
    self = [super init];
    if (self) {
        _lineRef = lineRef;
        _lineOrigin = position;
        _textFrame = textFrame;
        [self calculateRuns];
    }
    return self;
}

- (void) calculateRuns {
    
    // 获取当前行的尺寸等属性
    CGFloat lineAscent; // 上部
    CGFloat lineDesent; // 下部
    CGFloat lineLeading; // 行间距
    _typographicWidth = CTLineGetTypographicBounds(self.lineRef, &lineAscent, &lineDesent, &lineLeading); // 行实际排版的宽度
    
    // 生成坐标系翻转
    CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, _textFrame.origin.x, _textFrame.origin.y + _textFrame.size.height);
    tt = CGAffineTransformScale(tt, 1, -1);
    
    // 创建<core text坐标系>的base line底线，并转换坐标系后，得出<UIKit坐标系>的base line起点坐标
    CGRect lineBaseLineRect = CGRectMake(_lineOrigin.x, _lineOrigin.y, _typographicWidth, 0);
    lineBaseLineRect = CGRectApplyAffineTransform(lineBaseLineRect, tt);
    _uiLineOrigin = lineBaseLineRect.origin;
    
    // 生成run
    CFArrayRef runs = CTLineGetGlyphRuns(_lineRef);
    CFIndex runCount = CFArrayGetCount(runs);
    NSMutableArray* lineRuns = [NSMutableArray array];
    for (CFIndex i = 0; i < runCount; i++) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, i);
        JFTextRun* textRun = [[JFTextRun alloc] initWithRun:run linePosition:_lineOrigin textFrame:_textFrame];
        [lineRuns addObject:textRun];
    }
    _glyphRuns = [lineRuns copy];
    
}


@end

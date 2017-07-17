//
//  JFTextRun.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/17.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFTextRun.h"


@interface JFTextRun()
@property (nonatomic, assign) CGRect textFrame;
@end

@implementation JFTextRun

- (instancetype)initWithRun:(CTRunRef)runRef linePosition:(CGPoint)linePosition textFrame:(CGRect)textFrame {
    self = [super init];
    if (self) {
        _runRef = runRef;
        _linePosition = linePosition;
        _textFrame = textFrame;
        [self calculateGlyphs];
    }
    return self;
}

- (void) calculateGlyphs {
    CGFloat ascent;
    CGFloat desent;
    CGFloat runWidth = CTRunGetTypographicBounds(_runRef, CFRangeMake(0, 0), &ascent, &desent, NULL);

    // 获取所有字形的起点坐标
    CFIndex glyphCount = CTRunGetGlyphCount(_runRef);
    CGPoint glyphPositions[glyphCount];
    CTRunGetPositions(_runRef, CFRangeMake(0, 0), glyphPositions);
    // 获取所有字形的advances
    CGSize glyphSizes[glyphCount];
    CTRunGetAdvances(_runRef, CFRangeMake(0, 0), glyphSizes);

    // 坐标系转换
    CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, _textFrame.origin.x, _textFrame.origin.y + _textFrame.size.height);
    tt = CGAffineTransformScale(tt, 1, -1);

    // run frame
    _runFrame = CGRectMake(_linePosition.x + glyphPositions[0].x,
                           _linePosition.y - desent,
                           runWidth,
                           ascent + desent);
    _runFrame = CGRectApplyAffineTransform(_runFrame, tt);
        
    // 生成所有字形
    NSMutableArray* glyphRects = [NSMutableArray array];
    for (CFIndex i = 0; i < glyphCount; i++) {
        JFTextGlyph* glyph = [JFTextGlyph new];
        CGRect glyphFrame = CGRectMake(_linePosition.x + glyphPositions[i].x,
                                       _linePosition.y - desent,
                                       glyphSizes[i].width,
                                       ascent + desent);
        glyph.ctGlyphFrame = glyphFrame;
        glyphFrame = CGRectApplyAffineTransform(glyphFrame, tt);
        glyph.uiGlyphFrame = glyphFrame;
    }
    _glyphs = [glyphRects copy];
}

@end

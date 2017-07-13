//
//  JFTextLayout.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFTextLayout.h"
#import "JFTextAttachment.h"
#import "JFTextLine.h"

@interface JFTextLayout()

@property (nonatomic, assign) CGRect originFrame; // 原始frame
@property (nonatomic, assign) NSInteger linesCount; // 行数

@property (nonatomic, assign) NSMutableArray<JFTextLine*>* lines; // 保存CTLine的数组,用于绘制;绘制任务是逐行绘制;

@property (nonatomic, strong) NSMutableArray<JFTextHighLight*>* highLights; // 高亮组
@property (nonatomic, strong) NSMutableArray<JFTextBackgoundColor*>* backgrounds; // 背景色组
@property (nonatomic, strong) NSMutableArray<JFTextAttachment*>* attachments; // 附件组

@end

@implementation JFTextLayout

/**
 文本布局生成器;
 
 @param attributedString 富文本; 包含文本属性、附件、高亮等属性;
 @param textFrame 文本绘制区域;
 @param linesCount 文本行数;如果小于文本实际行数，则截取;
 @return 文本布局对象;
 */
+ (instancetype) jf_textLayoutWithAttributedString:(NSAttributedString*)attributedString
                                             frame:(CGRect)textFrame
                                        linesCount:(NSInteger)linesCount
{
    JFTextLayout* textLayout = [JFTextLayout new];
    textLayout.originFrame = textFrame;
    textLayout.linesCount = linesCount;
    
    // 创建frameSetter
    /*
     创建frameSetter
     生成frame
     遍历lines
        遍历runs
            遍历run的属性
            给每个属性设置frame
            并将属性添加到本地列表(保存的是引用)
     */
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGPathRef path = CGPathCreateWithRect(textFrame, NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    // 获取所有行属性
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex originLinesCount = CFArrayGetCount(lines);
    CGPoint linesOrigins[originLinesCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), linesOrigins);
    
    // 计算最大行数,外部参数有限制or无限制
    CFIndex maxLinesCount = linesCount == 0 ? originLinesCount : MIN(linesCount, originLinesCount);
    // 遍历到最大行
    for (CFIndex i = 0; i < maxLinesCount; i++) {
        // new a textLine & add it
        JFTextLine* textLine = [JFTextLine new];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        textLine.lineRef = line;
        textLine.lineOrigin = linesOrigins[i];
        [textLayout.lines addObject:textLine];
        
        // 遍历run
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runsCount = CFArrayGetCount(runs);
        for (CFIndex j = 0; j < runsCount; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            CGFloat ascent;
            CGFloat desent;
            CGFloat leading;
            CGSize size;
            CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desent, &leading);
            CTRunGetAdvances(run, CFRangeMake(0, 0), &size);
            CTRunGetPositions(run, <#CFRange range#>, <#CGPoint *buffer#>)
            size.height = ascent + desent;
            
            // 检查是属性项
            CFDictionaryRef attribute = CTRunGetAttributes(run);
            NSDictionary* attriDic = (__bridge NSDictionary*)attribute;
            
            // 高亮
            // 背景
            // 附件
        }
        
    }
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
    return textLayout;
}


# pragma mask 4 getter

- (NSMutableArray *)highLights {
    if (!_highLights) {
        _highLights = [NSMutableArray array];
    }
    return _highLights;
}

- (NSMutableArray *)backgrounds {
    if (!_backgrounds) {
        _backgrounds = [NSMutableArray array];
    }
    return _backgrounds;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray array];
    }
    return _attachments;
}

- (NSMutableArray<JFTextLine *> *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

@end

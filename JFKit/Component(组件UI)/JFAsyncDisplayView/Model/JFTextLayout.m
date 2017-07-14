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

@property (nonatomic, strong) NSMutableArray<JFTextLine*>* lines; // 保存CTLine的数组,用于绘制;绘制任务是逐行绘制;

@property (nonatomic, strong) NSMutableArray<JFTextHighLight*>* highLights; // 高亮组
@property (nonatomic, strong) NSMutableArray<JFTextBackgoundColor*>* backgrounds; // 背景色组
@property (nonatomic, strong) NSMutableArray<JFTextAttachment*>* attachments; // 附件组

@property (nonatomic, assign) CGContextRef context; // 绘制用的上下文
@property (nonatomic, copy) isCanceledBlock isCanceled; // 判断是否退出绘制任务

@property (nonatomic, assign) CTFramesetterRef frameSetter;
@property (nonatomic, assign) CGPathRef path;
@property (nonatomic, assign) CTFrameRef frameRef;

@end

@implementation JFTextLayout

/**
 文本布局生成器;
 
 @param attributedString 富文本; 包含文本属性、附件、高亮等属性;
 @param textFrame 文本绘制区域; frame.size.height最好是无限大，如果小于了按width的预设的高度，生成的frameRef会截掉超出的height部分
 @param linesCount 文本行数;如果小于文本实际行数，则截取;
 @return 文本布局对象;
 */
+ (instancetype) jf_textLayoutWithAttributedString:(NSAttributedString*)attributedString
                                             frame:(CGRect)textFrame
                                        linesCount:(NSInteger)linesCount
{
    JFTextLayout* textLayout = [[JFTextLayout alloc] init];
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
    textLayout.frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    textLayout.path = CGPathCreateWithRect(textFrame, NULL);
    textLayout.frameRef = CTFramesetterCreateFrame(textLayout.frameSetter, CFRangeMake(0, attributedString.length), textLayout.path, NULL);
    
    // 获取所有行属性
    CFArrayRef lines = CTFrameGetLines(textLayout.frameRef);
    CFIndex originLinesCount = CFArrayGetCount(lines);
    CGPoint linesOrigins[originLinesCount];
    CTFrameGetLineOrigins(textLayout.frameRef, CFRangeMake(0, attributedString.length), linesOrigins);
    
    // 计算最大行数,外部参数有限制or无限制
    CFIndex maxLinesCount = linesCount == 0 ? originLinesCount : MIN(linesCount, originLinesCount);
    
    NSLog(@"---0, attributedString[%@]", attributedString);
    // 遍历到最大行
    NSLog(@"---------line行数:%d", maxLinesCount);
    for (CFIndex i = 0; i < maxLinesCount; i++) {
        // new a textLine & add it
        JFTextLine* textLine = [JFTextLine new];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        textLine.lineRef = line;
        textLine.lineOrigin = linesOrigins[i];
        [textLayout.lines addObject:textLine];
        CGFloat lineAscent;
        CGFloat lineDescent;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
//        CFRange lineRange = CTLineGetStringRange(line);

        // 遍历run
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runsCount = CFArrayGetCount(runs);
        NSLog(@"---当前行:%ld, run个数:%ld", i, runsCount);
        for (CFIndex j = 0; j < runsCount; j++) {
            NSLog(@"  --当前run:%ld", j);
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            CFIndex glyphCount = CTRunGetGlyphCount(run);
            CGPoint glyphOrigins[glyphCount];
            CGFloat ascent;
            CGFloat desent;
            CGFloat leading;
            CGSize size[glyphCount];

            CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desent, &leading);

            CTRunGetAdvances(run, CFRangeMake(0, 0), size); // 一定要注意，这里的size参数一定要为数组类型，否则会报错,而且没有错误日志，很难排查
            for (int g = 0; g < glyphCount; g++) {
                size[g].height = ascent + desent;
            }
            // 获取每个glyph的起点坐标
            CTRunGetPositions(run, CFRangeMake(0, 0), glyphOrigins);
            // 计算frame

            CGRect runFrame = CGRectMake(glyphOrigins[0].x, glyphOrigins[0].y - desent, size[0].width, size[0].height);
            runFrame.origin.x += linesOrigins[i].x;
            runFrame.origin.y = linesOrigins[i].y - lineDescent + runFrame.origin.y;
            // 翻转坐标系，需要的是整个view的size
            CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, textFrame.size.height);
            tt = CGAffineTransformScale(tt, 1, -1);
            runFrame = CGRectApplyAffineTransform(runFrame, tt);
            
            // 获取当前run的range
            CFRange runRange = CTRunGetStringRange(run);
            // 检查是属性项
            CFDictionaryRef attribute = CTRunGetAttributes(run);
            if (attribute) {
                NSDictionary* attriDic = (__bridge NSDictionary*)attribute;
                
                // 高亮
                JFTextHighLight* highLight = [attriDic objectForKey:JFTextHighLightName];
                if (highLight) {
                    if (runRange.location == highLight.range.location) {
                        highLight.positions = [NSArray array];
                    }
                    NSMutableArray* frames = [NSMutableArray arrayWithArray:highLight.positions];
                    [frames addObject:[NSValue valueWithCGRect:runFrame]];
                    highLight.positions = [frames copy];
                    // 添加高亮对象到缓存
                    if (![textLayout.highLights containsObject:highLight]) {
                        [textLayout.highLights addObject:highLight];
                    }
                }
                // 背景
                JFTextBackgoundColor* background = [attriDic objectForKey:JFTextBackgroundColorName];
                if (background) {
                    if (runRange.location == background.range.location) {
                        background.positions = [NSArray array];
                    }
                    NSMutableArray* frames = [NSMutableArray arrayWithArray:background.positions];
                    [frames addObject:[NSValue valueWithCGRect:runFrame]];
                    background.positions = [frames copy];
                    // 添加背景块到缓存
                    if (![textLayout.backgrounds containsObject:background]) {
                        [textLayout.backgrounds addObject:background];
                    }
                }
                // 附件
                JFTextAttachment* attachment = [attriDic objectForKey:JFTextAttachmentName];
                if (attachment) {
                    attachment.frame = runFrame;
                    // 添加附件到缓存
                    if (![textLayout.attachments containsObject:attachment]) {
                        [textLayout.attachments addObject:attachment];
                    }
                }
            }
        }
        
    }
    
    return textLayout;
}

- (void)dealloc {
    if (self.frameRef) {
        CFRelease(self.frameRef);
    }
    if (self.path) {
        CFRelease(self.path);
    }
    if (self.frameSetter) {
        CFRelease(self.frameSetter);
    }
}



- (void)drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled{
    self.context = context;
    self.isCanceled = canceled;
    // 绘制背景
    [self __drawBackgroundColors];
    // 绘制高亮
    [self __drawHighLights];
    // 绘制文本
    [self __drawTexts];
    // 绘制附件
    [self __drawAttachments];
}


# pragma mask 2 tools

- (void) __drawBackgroundColors {
    NSLog(@"绘制背景色");
    if (self.backgrounds.count > 0) {
        CGContextSaveGState(self.context);
        for (JFTextBackgoundColor* background in self.backgrounds) {
            for (NSNumber* frameValue in background.positions) {
                NSLog(@" 绘制:%@", frameValue);
                if (self.isCanceled()) {
                    CGContextRestoreGState(self.context);
                    return;
                }
                CGRect frame = [frameValue CGRectValue];
                UIColor* backgroundColor = background.backgroundColor;
                if (!backgroundColor) {
                    backgroundColor = [UIColor clearColor];
                }
                CGContextSetFillColorWithColor(self.context, backgroundColor.CGColor);
                CGContextFillRect(self.context, frame);
            }
        }
        CGContextRestoreGState(self.context);
    }
}

- (void) __drawHighLights {
    if (self.highLights.count > 0) {
        CGContextSaveGState(self.context);
        for (JFTextHighLight* highLight in self.highLights) {
            for (NSNumber* frameValue in highLight.positions) {
                if (self.isCanceled()) {
                    CGContextRestoreGState(self.context);
                    return;
                }
//                CGRect frame = [frameValue CGRectValue];
//                UIColor* backgroundColor = highLight.backSelectedColor;
//                if (!backgroundColor) {
//                    backgroundColor = [UIColor clearColor];
//                }
//                CGContextSetFillColorWithColor(self.context, backgroundColor.CGColor);
//                CGContextFillRect(self.context, frame);
            }
        }
        CGContextRestoreGState(self.context);
    }
}

- (void) __drawTexts {
    
}

- (void) __drawAttachments {
    
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

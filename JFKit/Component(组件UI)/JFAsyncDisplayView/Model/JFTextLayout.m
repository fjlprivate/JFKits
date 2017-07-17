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


@property (nonatomic, assign) CTFramesetterRef frameSetter; // 用来生成frameRef
@property (nonatomic, assign) CGPathRef path; // 用来生成frameRef
@property (nonatomic, assign) CTFrameRef frameRef; // 缓存了core text的布局属性，包括lines

@property (nonatomic, strong) NSMutableArray<NSNumber*>* lineOrigins; // 每行的起点
@property (nonatomic, strong) NSMutableArray<NSNumber*>* lineWidths; // 每行的实际宽度

@end

@implementation JFTextLayout


# pragma mask 1


/**
 执行绘制任务

 @param context 要绘制的上下文
 @param canceled 判断是否退出绘制
 */
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
    
    return [[JFTextLayout alloc] initWithAttributedString:attributedString frame:textFrame linesCount:linesCount];
}



# pragma mask 2 life cycle

- (instancetype) initWithAttributedString:(NSAttributedString*)attributedString
                                    frame:(CGRect)textFrame
                               linesCount:(NSInteger)linesCount
{
    self = [super init];
    if (self) {
        _backgrounds = [NSMutableArray array];
        _highLights = [NSMutableArray array];
        _lines = [NSMutableArray array];
        _attachments = [NSMutableArray array];
        
        
        _originFrame = textFrame;
        _linesCount = linesCount;
        
        // 创建frameSetter
        _frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        _path = CGPathCreateWithRect(textFrame, NULL);
        _frameRef = CTFramesetterCreateFrame(_frameSetter, CFRangeMake(0, 0), _path, NULL);
        
        // 获取所有行属性
        CFArrayRef lines = CTFrameGetLines(_frameRef);
        CFIndex originLinesCount = CFArrayGetCount(lines);
        CGPoint linesOrigins[originLinesCount];
        CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), linesOrigins);
        
        // 计算最大行数,外部参数有限制or无限制
        CFIndex maxLinesCount = linesCount == 0 ? originLinesCount : MIN(linesCount, originLinesCount);
        
        // 实际文本高度
        CGFloat activeTextHeight = 0;
        
        NSLog(@"***************0, frame[%@]\nattributedString[%@]",NSStringFromCGRect(textFrame), attributedString);
        // 遍历到最大行
        NSLog(@"---------line行数:%ld", maxLinesCount);
        for (CFIndex i = 0; i < maxLinesCount; i++) {
            // new a textLine & add it
            JFTextLine* textLine = [JFTextLine new];
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            textLine.lineRef = line;
            textLine.lineOrigin = linesOrigins[i];
            [_lines addObject:textLine];
            // 获取当前行的上部、下部、行间距、排版行宽度
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CGFloat lineTypographicWidth = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            activeTextHeight += (lineAscent + lineDescent + lineLeading);
            
            //        // 当前行的起始坐标
            CGFloat curOriLineX = linesOrigins[i].x;
            CGFloat curOriLineY = linesOrigins[i].y;
            
            // 获取当前行的run属性
            CFArrayRef runs = CTLineGetGlyphRuns(line);
            CFIndex runsCount = CFArrayGetCount(runs);
            NSLog(@"#当前行:%ld,origin[%lf,%lf] run个数:%ld", i,linesOrigins[i].x,linesOrigins[i].y, runsCount);
            
            // 遍历run
            for (CFIndex j = 0; j < runsCount; j++) {
                CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                // 获取run的上部、下部、排版宽度
                CGFloat ascent;
                CGFloat desent;
                CGFloat leading;
                CGFloat typographicWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desent, &leading);
                // 获取glyph组属性
                CFIndex glyphCount = CTRunGetGlyphCount(run);
                CGPoint glyphOrigins[glyphCount]; // glyph起点坐标
                CTRunGetPositions(run, CFRangeMake(0, 0), glyphOrigins);
                //            // 获取每个glyph的起点坐标
                //            CGSize size[glyphCount];
                NSLog(@" -当前run:%ld, glyph个数:%ld, ", j, glyphCount);
                //            // 获取run的size属性
                //            CTRunGetAdvances(run, CFRangeMake(0, 0), size); // 一定要注意，这里的size参数一定要为数组类型，否则会报错,而且没有错误日志，很难排查
                //            for (int g = 0; g < glyphCount; g++) {
                //                size[g].height = ascent + desent;
                //                NSLog(@"  .当前glyph:%d, ascent:%lf, desent:%lf,width:%lf, origin[%lf,%lf]", g, ascent, desent, size[g].width,glyphOrigins[g].x,glyphOrigins[g].y);
                //            }
                
                // 计算run frame
                CGRect runFrame = CGRectMake(curOriLineX + glyphOrigins[0].x,
                                             curOriLineY - desent,
                                             typographicWidth,
                                             ascent + desent);
                // 翻转坐标系，需要的是整个view的size
                CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, textFrame.size.height);
                tt = CGAffineTransformTranslate(tt, textFrame.origin.x, textFrame.origin.y);
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
                        if (![_highLights containsObject:highLight]) {
                            [_highLights addObject:highLight];
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
                        if (![self.backgrounds containsObject:background]) {
                            [self.backgrounds addObject:background];
                        }
                    }
                    // 附件
                    JFTextAttachment* attachment = [attriDic objectForKey:JFTextAttachmentName];
                    if (attachment) {
                        attachment.frame = runFrame;
                        // 添加附件到缓存
                        if (![_attachments containsObject:attachment]) {
                            [_attachments addObject:attachment];
                        }
                    }
                }
            }
            
        }
        textFrame.size.height = activeTextHeight;
        _suggestFrame = textFrame;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"*********text layout被释放了***********");
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



# pragma mask 2 tools

- (void) __drawBackgroundColors {
    NSLog(@".....textLayouot:绘制背景色");
    if (self.backgrounds.count > 0) {
        CGContextSaveGState(self.context);
        for (JFTextBackgoundColor* background in self.backgrounds) {
            for (NSNumber* frameValue in background.positions) {
                NSLog(@" 绘制背景,frame:%@", frameValue);
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
    NSLog(@"##绘制文本");
    CGContextSaveGState(self.context);
    CGContextSetFillColorWithColor(self.context, [UIColor colorWithWhite:0 alpha:0.1].CGColor);
    CGContextFillRect(self.context, self.suggestFrame);
    
    CGContextTranslateCTM(self.context, self.originFrame.origin.x, self.originFrame.origin.y);
    CGContextTranslateCTM(self.context, 0, self.originFrame.size.height);
    CGContextScaleCTM(self.context, 1, -1);
    for (int i = 0; i < self.lines.count; i++) {
        if (self.isCanceled()) {
            CGContextRestoreGState(self.context);
            return;
        }
        JFTextLine* line = [self.lines objectAtIndex:i];
        CGContextSetTextPosition(self.context, line.lineOrigin.x, line.lineOrigin.y);
        CTLineDraw(line.lineRef, self.context);
        NSLog(@"  +绘制第[%d]行文本:[%lf,%lf]", i, line.lineOrigin.x, line.lineOrigin.y);
    }
    CGContextRestoreGState(self.context);
}

- (void) __drawAttachments {
    
}



@end

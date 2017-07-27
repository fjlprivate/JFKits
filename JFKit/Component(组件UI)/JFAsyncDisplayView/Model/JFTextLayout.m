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
#import "JFKit.h"

@interface JFTextLayout()

@property (nonatomic, assign) CGRect originFrame; // 原始frame
@property (nonatomic, assign) CGRect textFrame; // 内嵌的文本frame
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


@property (nonatomic, assign) CGFloat debugLineWidth;
@property (nonatomic, strong) UIColor* debugColor;

@end

@implementation JFTextLayout


# pragma mask 1


/**
 执行绘制任务
 顺序要正确

 @param context 要绘制的上下文
 @param canceled 判断是否退出绘制
 */
- (void)drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled{
    self.context = context;
    self.isCanceled = canceled;
    // 绘制背景
    [self __drawBackgroundColors];
    // 绘制debug
    [self __drawDebugs];
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
 @param textFrame 文本绘制区域;
 @param linesCount 文本行数;如果小于文本实际行数，则截取;
 @param insets 横竖的内嵌距离;
 @return 文本布局对象;
 */
+ (instancetype) jf_textLayoutWithAttributedString:(NSAttributedString*)attributedString
                                             frame:(CGRect)textFrame
                                        linesCount:(NSInteger)linesCount
                                            insets:(UIEdgeInsets)insets
{
    return [[JFTextLayout alloc] initWithAttributedString:attributedString frame:textFrame linesCount:linesCount insets:insets];
}



/**
 判断是否点击了高亮区;
 逐个比较当前缓存中的所有高亮区;
 
 @param position 点击坐标
 @return 存在任意一个高亮区，则返回YES;否则返回NO;
 */
- (CGRect) didClickedHighLightPosition:(CGPoint)position {
    for (JFTextHighLight* highLight in self.highLights) {
        for (NSValue* frameValue in highLight.positions) {
            CGRect frame = [frameValue CGRectValue];
            if (CGRectContainsPoint(frame, position)) {
                return frame;
            }
        }
    }
    return CGRectZero;
}


/**
 获取指定坐标点的高亮属性;
 
 @param position 指定坐标点<UIKit坐标系>;
 @return 返回符合条件的高亮属性;没有则返回nil;
 */
- (JFTextHighLight*) highLightAtPosition:(CGPoint)position {
    for (JFTextHighLight* highLight in self.highLights) {
        for (NSValue* frameValue in highLight.positions) {
            CGRect frame = [frameValue CGRectValue];
            if (CGRectContainsPoint(frame, position)) {
                return highLight;
            }
        }
    }
    return nil;
}



/**
 更新高亮区的显示开关;
 在执行这个方法前，最好先执行上面的判断;
 
 @param switchOn 高亮开关;
 @param position 高亮区所在的坐标;
 */
- (void) turnningHightLightSwitch:(BOOL)switchOn atPosition:(CGPoint)position {
    for (JFTextHighLight* highLight in self.highLights) {
        for (NSValue* frameValue in highLight.positions) {
            CGRect frame = [frameValue CGRectValue];
            if (CGRectContainsPoint(frame, position)) {
                highLight.showHighLight = switchOn;
                return;
            }
        }
    }
}

/**
 获取指定坐标对应的高亮对象的绑定数据;
 
 @param position 指定坐标;
 @return 高亮对象绑定的数据;
 */
- (id) bindingDataWithHighLightAtPosition:(CGPoint)position {
    for (JFTextHighLight* highLight in self.highLights) {
        for (NSValue* frameValue in highLight.positions) {
            CGRect frame = [frameValue CGRectValue];
            if (CGRectContainsPoint(frame, position)) {
                return highLight.content;
            }
        }
    }
    return nil;
}


# pragma mask 2 life cycle

- (instancetype) initWithAttributedString:(NSAttributedString*)attributedString
                                    frame:(CGRect)textFrame
                               linesCount:(NSInteger)linesCount
                                   insets:(UIEdgeInsets)insets
{
    self = [super init];
    if (self) {
        _backgrounds = [NSMutableArray array];
        _highLights = [NSMutableArray array];
        _lines = [NSMutableArray array];
        _attachments = [NSMutableArray array];
        _debugLineWidth = 0.7;
        _debugColor = JFHexColor(0xEA6956, 1);
        _originFrame = textFrame;
        _linesCount = linesCount;
        // 裁剪内嵌边距
        CGRect newTextFrame = textFrame;
        newTextFrame.origin.x += insets.left;
        newTextFrame.size.width -= (insets.left + insets.right);
        newTextFrame.origin.y += insets.top;
        newTextFrame.size.height -= (insets.top + insets.bottom);
        _textFrame = newTextFrame;
        
        // 创建frameSetter
        _frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        _path = CGPathCreateWithRect(_textFrame, NULL);
        _frameRef = CTFramesetterCreateFrame(_frameSetter, CFRangeMake(0, 0), _path, NULL);
                
        // 获取所有行属性
        CFArrayRef lines = CTFrameGetLines(_frameRef);
        CFIndex originLinesCount = CFArrayGetCount(lines);
        _originNumberOfLines = originLinesCount; // 保存文本原始行数
        CGPoint linesOrigins[originLinesCount];
        CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), linesOrigins);
        
        // 计算最大行数,外部参数有限制or无限制
        CFIndex maxLinesCount = linesCount == 0 ? originLinesCount : MIN(linesCount, originLinesCount);
        _isTrancated = maxLinesCount < originLinesCount;
        // 用来缓存最大的line的实际width
        CGFloat maxLineWidth = 0;
        // 实际文本高度
        CGFloat activeTextHeight = insets.top;

        // 遍历到最大行
        for (CFIndex i = 0; i < maxLinesCount; i++) {
            // 创建一个line对象，并添加到数组
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            JFTextLine* textLine = [[JFTextLine alloc] initWithLine:line origin:linesOrigins[i] textFrame:_textFrame];
            [_lines addObject:textLine];
            // 总和当前行的有效高度: 上部+下部+行间距; (最后一行不计算行间距)
            activeTextHeight += (textLine.ascent + textLine.desent + (i == maxLinesCount - 1 ? 0 : textLine.leading));
            // 比较并保存最大行width到缓存
            maxLineWidth = MAX(maxLineWidth, textLine.typographicWidth);
            
            for (int j = 0; j < textLine.glyphRuns.count; j++) {
                JFTextRun* run = [textLine.glyphRuns objectAtIndex:j];
                
                CFRange runRange = CTRunGetStringRange(run.runRef);
                CFDictionaryRef attribute = CTRunGetAttributes(run.runRef);
                
                if (attribute) {
                    NSDictionary* attriDic = (__bridge NSDictionary*)attribute;
                    // 高亮
                    JFTextHighLight* highLight = [attriDic objectForKey:JFTextHighLightName];
                    if (highLight) {
                        if (runRange.location == highLight.range.location) {
                            highLight.positions = [NSArray array];
                        }
                        NSMutableArray* frames = [NSMutableArray arrayWithArray:highLight.positions];
                        [frames addObject:[NSValue valueWithCGRect:run.runFrame]];
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
                        [frames addObject:[NSValue valueWithCGRect:run.runFrame]];
                        background.positions = [frames copy];
                        // 添加背景块到缓存
                        if (![self.backgrounds containsObject:background]) {
                            [self.backgrounds addObject:background];
                        }
                    }
                    // 附件
                    JFTextAttachment* attachment = [attriDic objectForKey:JFTextAttachmentName];
                    if (attachment) {
                        attachment.frame = run.ctRunFrame;
                        // 添加附件到缓存
                        if (![_attachments containsObject:attachment]) {
                            [_attachments addObject:attachment];
                        }
                    }
                }
            }
        }
        // 计算文本最终的建议尺寸
        activeTextHeight += insets.bottom;
        textFrame.size.height = activeTextHeight;
        textFrame.size.width = maxLineWidth + insets.left + insets.right;
        _suggestFrame = textFrame;
    }
    return self;
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



# pragma mask 2 tools

- (void) __drawBackgroundColors {
    if (self.backgroundColor) {
        CGContextSaveGState(self.context);
        CGContextSetFillColorWithColor(self.context, self.backgroundColor.CGColor);
        CGContextFillRect(self.context, self.suggestFrame);
        CGContextRestoreGState(self.context);
    }
    if (self.backgrounds.count > 0) {
        CGContextSaveGState(self.context);
        for (JFTextBackgoundColor* background in self.backgrounds) {
            for (NSValue* frameValue in background.positions) {
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
                CGMutablePathRef path = CGPathCreateMutable();
                if (CGRectGetWidth(frame) >= 4 && CGRectGetHeight(frame) >= 4) {
                    CGPathAddRoundedRect(path, NULL, frame, 2, 2);
                } else {
                    CGPathAddRect(path, NULL, frame);
                }
                CGContextAddPath(self.context, path);
                CGContextFillPath(self.context);
                CGPathRelease(path);
            }
        }
        CGContextRestoreGState(self.context);
    }
}

- (void) __drawHighLights {
    if (self.highLights.count > 0) {
        CGContextSaveGState(self.context);
        for (JFTextHighLight* highLight in self.highLights) {
            if (!highLight.showHighLight) {
                continue;
            }
            for (NSValue* frameValue in highLight.positions) {
                if (self.isCanceled()) {
                    CGContextRestoreGState(self.context);
                    return;
                }
                CGRect frame = [frameValue CGRectValue];
                UIColor* backgroundColor = highLight.backSelectedColor;
                if (!backgroundColor) {
                    backgroundColor = [UIColor clearColor];
                }
                CGContextSetFillColorWithColor(self.context, backgroundColor.CGColor);
                CGMutablePathRef path = CGPathCreateMutable();
                if (CGRectGetWidth(frame) >= 4 && CGRectGetHeight(frame) >= 4) {
                    CGPathAddRoundedRect(path, NULL, frame, 2, 2);
                } else {
                    CGPathAddRect(path, NULL, frame);
                }
                CGContextAddPath(self.context, path);
                CGContextFillPath(self.context);
                CGPathRelease(path);
            }
        }
        CGContextRestoreGState(self.context);
    }
}

- (void) __drawTexts {
    CGContextSaveGState(self.context);
    CGContextTranslateCTM(self.context, self.textFrame.origin.x, self.textFrame.origin.y);
    CGContextTranslateCTM(self.context, 0, self.textFrame.size.height);
    CGContextScaleCTM(self.context, 1, -1);
    for (int i = 0; i < self.lines.count; i++) {
        if (self.isCanceled()) {
            CGContextRestoreGState(self.context);
            return;
        }
        JFTextLine* line = [self.lines objectAtIndex:i];
        CGContextSetTextPosition(self.context, line.lineOrigin.x, line.lineOrigin.y);
        CTLineDraw(line.lineRef, self.context);
    }
    CGContextRestoreGState(self.context);
}

- (void) __drawAttachments {
    CGContextSaveGState(self.context);
    CGContextTranslateCTM(self.context, self.textFrame.origin.x, self.textFrame.origin.y);
    CGContextTranslateCTM(self.context, 0, self.textFrame.size.height);
    CGContextScaleCTM(self.context, 1, -1);

    for (JFTextAttachment* attachment in self.attachments) {
        if (self.isCanceled()) {
            CGContextRestoreGState(self.context);
            return;
        }
        if ([attachment.contents isKindOfClass:[UIImage class]]) { // UIImage
            UIImage* image = attachment.contents;
            CGContextDrawImage(self.context, attachment.frame, image.CGImage);
        } else { // NSURL
            
        }
    }
    CGContextRestoreGState(self.context);
}

- (void) __drawDebugs {
    if (self.debugMode) {
        CGContextSaveGState(self.context);
        for (JFTextLine* line in self.lines) {
            CGRect baseLineFrame = CGRectMake(line.uiLineOrigin.x, line.uiLineOrigin.y, line.typographicWidth, _debugLineWidth);
            CGContextSetFillColorWithColor(self.context, self.debugColor.CGColor);
            CGContextFillRect(self.context, baseLineFrame);
            for (JFTextRun* run in line.glyphRuns) {
                for (JFTextGlyph* glyph in run.glyphs) {
                    CGContextSetStrokeColorWithColor(self.context, self.debugColor.CGColor);
                    CGContextStrokeRect(self.context, glyph.uiGlyphFrame);
                }
            }
        }
        CGContextRestoreGState(self.context);
    }
}



@end

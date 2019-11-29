//
//  JFTextLayout.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFTextLayout.h"
#import "JFAsyncFlag.h"
#import "JFTextLine.h"
#import "JFTextRun.h"
#import "JFTextAttachment.h"
#import <CoreText/CoreText.h>


@interface JFTextLayout()
@property (nonatomic, strong) JFAsyncFlag* asyncFlag;
@property (nonatomic, assign) CTFramesetterRef frameSetter;
@property (nonatomic, assign) CGPathRef framePath;
@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, strong) NSArray<JFTextLine*>* ctLines;
@end

@implementation JFTextLayout

# pragma mark - 绘制
/**
 绘制文本到上下文;
 @param context 指定上下文;
 @param cancelled 退出操作的回调;
 */
- (void) drawInContext:(CGContextRef)context cancelled:(IsCancelled)cancelled {
    CGContextSaveGState(context);
    // 绘制背景色、边框
    UIColor* bgColor = self.backgroundColor;
    UIColor* textBgColor = self.textStorage.backgroundColor;
    UIColor* borderColor = self.borderColor;
    // layout背景色默认:白色
    if (!bgColor) {
        bgColor = [UIColor whiteColor];
    }
    // 未设置文本背景色，默认为layout背景色
    if (!textBgColor) {
        textBgColor = bgColor;
    }
    if (cancelled()) {
        CGContextRestoreGState(context);
        return;
    }
    
    // 绘制layout背景色、边框
    {
        CGMutablePathRef path = CGPathCreateMutable();
        if (self.cornerRadius.width > 0 && self.cornerRadius.height > 0) {
            CGFloat cornerW = self.cornerRadius.width;
            CGFloat cornerH = self.cornerRadius.height;
            // 圆角 * 2 不能超过layout的size
            if (cornerW * 2 > CGRectGetWidth(self.frame)) {
                cornerW = CGRectGetWidth(self.frame) * 0.5;
            }
            if (cornerH * 2 > CGRectGetHeight(self.frame)) {
                cornerH = CGRectGetHeight(self.frame) * 0.5;
            }
            CGPathAddRoundedRect(path, NULL, self.frame, cornerW, cornerH);
        } else {
            CGPathAddRect(path, NULL, self.frame);
        }
        CGContextAddPath(context, path);
        if (cancelled()) {
            CGContextRestoreGState(context);
            CGPathRelease(path);
            return;
        }

        // fill
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextFillPath(context);
        if (cancelled()) {
            CGContextRestoreGState(context);
            CGPathRelease(path);
            return;
        }

        // strock
        if (borderColor && self.borderWidth > 0) {
            CGContextAddPath(context, path);
            CGContextSetLineWidth(context, self.borderWidth);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextStrokePath(context);
        }
        CGPathRelease(path);
    }
    
    if (cancelled()) {
        CGContextRestoreGState(context);
        return;
    }

    // 文本背景色跟layout背景色不一致才需要填充文本背景色
    if (textBgColor != bgColor) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.contentFrame);
        CGContextAddPath(context, path);
        CGPathRelease(path);
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
        CGContextSetFillColorWithColor(context, textBgColor.CGColor);
        CGContextFillPath(context);
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
    }
    
    // 绘制高亮附件
    for (JFTextAttachmentHighlight* highlight in self.textStorage.highlights) {
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
        // 获取选中|非选中背景色
        UIColor* bgColor = highlight.isHighlight ? highlight.highlightBackgroundColor : highlight.normalBackgroundColor;
        if (bgColor) {
            CGContextSetFillColorWithColor(context, bgColor.CGColor);
            // 每个高亮附件可能有多个frame
            for (NSValue* framevalue in highlight.uiFrames) {
                if (cancelled()) {
                    CGContextRestoreGState(context);
                    return;
                }
                CGContextFillRect(context, [framevalue CGRectValue]);
            }
        }
    }
    
    // 转换矩阵:<UIKit> -> <CoreText>
    // 翻转矩阵时，要用originSize:CTLine等都是在原始size生成的
    CGContextTranslateCTM(context, CGRectGetMinX(self.contentFrame), CGRectGetMaxY(self.contentFrame));
    CGContextScaleCTM(context, 1, -1);
    if (cancelled()) {
        CGContextRestoreGState(context);
        return;
    }
    // 逐行绘制line
    for (JFTextLine* line in self.ctLines) {
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
        // 绘制行
        CGContextSetTextPosition(context, line.ctOrigin.x, line.ctOrigin.y);
        CTLineDraw(line.ctLine, context);
        // 如果有附件,要绘制附件
        for (JFTextRun* run in line.ctRuns) {
            if (cancelled()) {
                CGContextRestoreGState(context);
                return;
            }
            // 图片附件
            for (JFTextAttachmentImage* imageAttachment in run.imageAttachments) {
                if (cancelled()) {
                    CGContextRestoreGState(context);
                    return;
                }
                CGRect imageCtFrame = imageAttachment.ctFrame;
//                imageCtFrame.origin.y += -line.descent + (line.ascent + line.descent - imageCtFrame.size.height) * 0.5;
                // 绘制背景色
                if (imageAttachment.backgroundColor) {
                    CGContextSetFillColorWithColor(context, imageAttachment.backgroundColor.CGColor);
                    CGPathRef path = CGPathCreateWithRoundedRect(imageCtFrame, imageAttachment.cornerRadius.width, imageAttachment.cornerRadius.height, NULL);
                    CGContextAddPath(context, path);
                    CGContextFillPath(context);
                    CGPathRelease(path);
                }
                // 绘制图片
                UIImage* image = nil;
                if ([imageAttachment.image isKindOfClass:[UIImage class]]) {
                    image = imageAttachment.image;
                }
                else if ([imageAttachment.image isKindOfClass:[NSString class]]) {
                    image = [UIImage imageNamed:imageAttachment.image];
                }
                if (image) {
                    CGContextDrawImage(context, imageCtFrame, image.CGImage);
                }
            }
        }
    }
    
    CGContextRestoreGState(context);
    
//    CGContextSaveGState(context);
//    for (JFTextAttachmentImage* imageAttachment in self.textStorage.images) {
//        UIImage* image = nil;
//        if ([imageAttachment.image isKindOfClass:[UIImage class]]) {
//            image = imageAttachment.image;
//        }
//        else if ([imageAttachment.image isKindOfClass:[NSString class]]) {
//            image = [UIImage imageNamed:imageAttachment.image];
//        }
//        if (image) {
//            [image drawInRect:imageAttachment.uiFrame];
////            CGContextDrawImage(context, imageCtFrame, image.CGImage);
//        }
//
//    }
//    CGContextRestoreGState(context);

    

    // 测试时:绘制行边框
    if (self.debug) {
        CGContextSaveGState(context);
        for (JFTextLine* line in self.ctLines) {
            if (cancelled()) {
                break;
            }
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
            CGContextStrokeRect(context, CGRectMake(line.uiOrigin.x,
                                                    line.uiOrigin.y,
                                                    line.width,
                                                    line.descent + line.ascent));
        }
        CGContextRestoreGState(context);
    }
}

# pragma mark - 计算布局
- (void) relayouting {
    // 先计算frame等
    [super relayouting];
    if (self.width< 0.1 || self.height < 0.1 || !self.textStorage) {
        return;
    }
    CGFloat startX = self.left == CGFLOAT_MIN ? 0 : self.left;
    CGFloat startY = self.top == CGFLOAT_MIN ? 0 : self.top;
    
    // 准备工作: 定义布局退出block
    [_asyncFlag incrementFlag];
    int curFlag = self.asyncFlag.curFlag;
    __weak JFAsyncFlag* weakFlag = self.asyncFlag;
    IsCancelled layoutCancelled = ^ BOOL {
        return curFlag != weakFlag.curFlag;
    };
    
    // 先释放历史生成的 framesetter等
    [self freeFramer];
    [self clearHighlightsFrames];
    
    /* --- 计算布局 --- */
    CGRect frame = CGRectMake(startX + self.insets.left,
                              startY + self.insets.top,
                              self.width - self.insets.left - self.insets.right,
                              self.height - self.insets.top - self.insets.bottom + 1);
    self.frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.textStorage.text);
    self.framePath = CGPathCreateWithRect(frame, NULL);
    self.frameRef = CTFramesetterCreateFrame(_frameSetter, CFRangeMake(0, 0), _framePath, NULL);
    if (layoutCancelled()) return;
    
    // 计算所有的行
    CFArrayRef lines = CTFrameGetLines(_frameRef);
    CFIndex linesCount = CFArrayGetCount(lines);
    CFIndex numberOfLines = linesCount;
    if (self.shouldSuggustingSize && self.numberOfLines > 0 && numberOfLines > self.numberOfLines) {
        numberOfLines = self.numberOfLines;
    }
    CGPoint linesOrigins[linesCount];
    // 获取所有行的起点
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), linesOrigins);
    if (layoutCancelled()) return;
    // 缓存suggustFrame.height,suggustFrame.width
    CGFloat suggustHeight = 0;
    CGFloat suggustWidth = 0;
    // 遍历行
    NSMutableArray* ctLines = @[].mutableCopy;
    for (CFIndex i = 0; i < numberOfLines; i++) {
        if (layoutCancelled()) return;
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        JFTextLine* ctLine = nil;
        
        // 需要截断,且已到截断行 : 生成并替换截断行
        if (i == numberOfLines - 1 && numberOfLines < linesCount) {
            CTLineRef truncatedLine = [self truncatedLine:line frame:frame cancelled:layoutCancelled];
            if (layoutCancelled()) return;
            // 创建 JFTextLine
            ctLine = [JFTextLine textLineWithCTLine:truncatedLine
                                             origin:linesOrigins[i]
                                              frame:frame
                                          cancelled:layoutCancelled];
        }
        // 不需要截断,或未到截断行
        else {
            // 创建 JFTextLine
            ctLine = [JFTextLine textLineWithCTLine:line
                                             origin:linesOrigins[i]
                                              frame:frame
                                          cancelled:layoutCancelled];
        }
        
        if (layoutCancelled()) return;
        // 创建JFTextLine直接退出
        if (!ctLine) {
            return;
        }
        // 取最宽的行宽
        suggustWidth = suggustWidth < ctLine.width ? ctLine.width : suggustWidth;
        // 如果追加当前行时，实际高度已经超过了frame.height，则退出循环
        if (suggustHeight > frame.size.height) {
            break;
        }
        // 累加当前行高:非最后一行,需要加上行间距
        suggustHeight += ctLine.ascent + ctLine.descent + ((i == numberOfLines - 1) ? 0 : ctLine.leading);

        [ctLines addObject:ctLine];
    }

    CGFloat lastHeight = self.height;
    CGFloat width = ceil(suggustWidth + self.insets.left + self.insets.right);
    CGFloat height = ceil(suggustHeight + self.insets.top + self.insets.bottom);

    [super updateWidthWithoutRelayouting:width];
    [super updateHeightWithoutRelayouting:height];
    
    // 实际高度有更新:ctLine的origin也要更新，因为它在绘制的时候是要翻转的
    if (lastHeight != self.height) {
        CGFloat heightRemain = lastHeight - self.height;
        for (JFTextLine* line in ctLines) {
            if (layoutCancelled()) return;
            CGPoint origin = line.ctOrigin;
            origin.y -= heightRemain;
            line.ctOrigin = origin;
            // 所有图片附件的ctOrigin也要更新
            for (JFTextRun* run in line.ctRuns) {
                if (layoutCancelled()) return;
                for (JFTextAttachmentImage* image in run.imageAttachments) {
                    if (layoutCancelled()) return;
                    CGRect ctFrame = image.ctFrame;
                    ctFrame.origin.y -= heightRemain;
                    image.ctFrame = ctFrame;
                }
            }
        }
    }
        
    // 保存行对象
    self.ctLines = ctLines.copy;
}

// 清理所有高亮附件的frames
- (void) clearHighlightsFrames {
    NSMutableArray* list = @[].mutableCopy;
    for (JFTextAttachmentHighlight* highlight in self.textStorage.highlights) {
        if ([highlight.linkData isKindOfClass:[NSString class]] && [highlight.linkData isEqualToString:JFTextViewAll]) {
            [list addObject:highlight];
        }
    }
    [self.textStorage.highlights removeObjectsInArray:list];
//    for (JFTextAttachmentHighlight* highlight in self.textStorage.highlights) {
//        [highlight.uiFrames removeAllObjects];
//    }
}

- (CTLineRef) truncatedLine:(CTLineRef)line frame:(CGRect)frame cancelled:(IsCancelled)cancelled {
    // 获取最后一行在全文本的range
    CFRange lastLineRange = CTLineGetStringRange(line);
    // 获取最后一个字符的属性
    NSDictionary* tokenAttri = [self.textStorage.text attributesAtIndex:lastLineRange.location + lastLineRange.length - 1 effectiveRange:NULL];
    // 省略号
    NSString* JFEllipsesCharacter = [NSString stringWithFormat:@"%@%@", @"\u2026", self.shouldShowMoreAct ? JFTextViewAll : @""];
    // 创建省略号富文本
    NSMutableAttributedString* tokenString = [[NSMutableAttributedString alloc] initWithString:JFEllipsesCharacter attributes:tokenAttri];
    if (cancelled()) return nil;
    
    if (self.shouldShowMoreAct) {
        // 添加高亮属性
        JFTextAttachmentHighlight* highLight = [JFTextAttachmentHighlight new];
        highLight.linkData = JFTextViewAll;
        highLight.normalBackgroundColor = self.textStorage.backgroundColor;
        highLight.highlightBackgroundColor = self.textStorage.backgroundColor;
        if (self.showMoreActColor) {
            highLight.normalTextColor = self.showMoreActColor;
            highLight.highlightTextColor = tokenAttri[NSForegroundColorAttributeName];//self.showMoreActColor;
        } else {
            highLight.normalTextColor = tokenAttri[NSForegroundColorAttributeName];
            highLight.highlightTextColor = tokenAttri[NSForegroundColorAttributeName];
        }
        // 因为'全文'高亮总是新创建的，所以无法区分isHighlight;固定显示默认色
        [tokenString addAttribute:NSForegroundColorAttributeName
                            value:highLight.normalTextColor
                            range:[JFEllipsesCharacter rangeOfString:JFTextViewAll]];

        highLight.range = NSMakeRange(NSNotFound, JFTextViewAll.length);
        // 添加高亮到textStorage;但location==NSNotfound,所以还要添加到attributeString中,让生成run时能取到这个highlight
        [self.textStorage addHighlight:highLight];
        [tokenString addAttribute:JFTextAttachmentHighlightName value:highLight range:[JFEllipsesCharacter rangeOfString:JFTextViewAll]];
    }
    if (cancelled()) return nil;
    // 生成line : '…全文'
    CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
    
    
    // 将最后一行富文本复制一份出来
    NSAttributedString* originAttriString = [self.textStorage.text attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)];
    NSMutableAttributedString* truncationString = [[NSMutableAttributedString alloc] initWithAttributedString:originAttriString];
    // 去掉末尾的空白字符 ---- 留给业务层去处理
//    while (truncationString.length > 0) {
//        unichar lastCharacter = [[truncationString string] characterAtIndex:truncationString.length - 1];
//        NSCharacterSet* whiteSpaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//        if ([whiteSpaceSet characterIsMember:lastCharacter]) {
//            [truncationString deleteCharactersInRange:NSMakeRange(truncationString.length - 1, 1)];
//        }
//        else {
//            break;
//        }
//    }
    
//    if (lastLineRange.length > 0) {
//        unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
//        NSCharacterSet* whiteSpaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//        if ([whiteSpaceSet characterIsMember:lastCharacter]) {
//            [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
//        }
//    }
    // 拼接省略号
    [truncationString appendAttributedString:tokenString];
    if (cancelled()) {
        CFRelease(truncationToken);
        return nil;
    }

    
    // 将拼接后的string转成CTLine
    CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
    // 截断
    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, frame.size.width, kCTLineTruncationEnd, truncationToken);
    /* 更新'全文'高亮的location */
    CFArrayRef runs = CTLineGetGlyphRuns(truncatedLine);
    for (int i = 0; i < CFArrayGetCount(runs); i++) {
        if (cancelled()) {
            CFRelease(truncationLine);
            CFRelease(truncationToken);
            return nil;
        }
        CTRunRef run = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes = CTRunGetAttributes(run);
        NSDictionary* attriDic = (__bridge NSDictionary*)attributes;
        JFTextAttachmentHighlight* highlight = attriDic[JFTextAttachmentHighlightName];
        if (highlight && highlight.range.location == NSNotFound) {
            CFRange runRange = CTRunGetStringRange(run);
            highlight.range = NSMakeRange(runRange.location + lastLineRange.location, highlight.range.length);
            break;
        }

    }
    
    
    if (!truncatedLine) {
        truncatedLine = CFRetain(truncationToken);
    }
    CFRelease(truncationLine);
    CFRelease(truncationToken);
    
    return truncatedLine;
}



# pragma mark - setter
- (void)setTextStorage:(JFTextStorage *)textStorage {
    _textStorage = textStorage;
    [self relayouting];
}
- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self relayouting];
}
//- (void)setShowMoreActColor:(UIColor *)showMoreActColor {
//    _showMoreActColor = showMoreActColor;
//    [self relayouting];
//}


# pragma mark - getter

- (JFAsyncFlag *)asyncFlag {
    if (!_asyncFlag) {
        _asyncFlag = [JFAsyncFlag new];
    }
    return _asyncFlag;
}

# pragma mark - life cycle

/**
 创建并初始化textLayout;
 @param frame           :位置和尺寸;
 @param text            :富文本;
 @param insets          :content内嵌边距;
 @param backgroundColor :背景色
 @return layout;
 */
+ (instancetype) textLayoutWithFrame:(CGRect)frame text:(JFTextStorage*)text insets:(UIEdgeInsets)insets backgroundColor:(UIColor*)backgroundColor
{
    JFTextLayout* textLayout = [[JFTextLayout alloc] initWithFrame:frame insets:insets backgroundColor:backgroundColor];
    
    textLayout.textStorage = text;
    textLayout.shouldShowMoreAct = YES;
    return textLayout;
}
+ (instancetype) textLayoutWithFrame:(CGRect)frame text:(JFTextStorage*)text insets:(UIEdgeInsets)insets
{
    return [self textLayoutWithFrame:frame text:text insets:insets backgroundColor:nil];
}
+ (instancetype) textLayoutWithFrame:(CGRect)frame text:(JFTextStorage*)text
{
    return [self textLayoutWithFrame:frame text:text insets:UIEdgeInsetsZero backgroundColor:nil];
}
+ (instancetype) textLayoutWithText:(JFTextStorage*)text
{
    return [self textLayoutWithFrame:CGRectZero text:text insets:UIEdgeInsetsZero backgroundColor:nil];
}

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets backgroundColor:(UIColor *)backgroundColor {
    if (self = [super initWithFrame:frame insets:insets backgroundColor:backgroundColor]) {
    }
    return self;
}

- (void)dealloc {
    [self freeFramer];
}
- (void) freeFramer {
    if (self.frameRef) {
        CFRelease(self.frameRef);
    }
    if (self.framePath) {
        CFRelease(self.framePath);
    }
    if (self.frameSetter) {
        CFRelease(self.frameSetter);
    }
}

@end

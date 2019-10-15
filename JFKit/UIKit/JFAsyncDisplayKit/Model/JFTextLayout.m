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
@synthesize suggustSize = _suggustSize;

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
    // 背景色默认:白色
    if (!bgColor) {
        bgColor = [UIColor whiteColor];
    }
    // 文本背景色默认:
    if (!textBgColor) {
        textBgColor = bgColor;
    }
    if (cancelled()) {
        CGContextRestoreGState(context);
        return;
    }
    CGRect frame = CGRectMake(self.left,
                              self.top,
                              self.suggustSize.width,
                              self.suggustSize.height);
    // 绘制layout背景色
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, frame);
    if (cancelled()) {
        CGContextRestoreGState(context);
        return;
    }
    
    // 设置了边框颜色才绘制
    if (borderColor) {
        CGMutablePathRef path = CGPathCreateMutable();
        if (self.cornerRadius.width > 0 || self.cornerRadius.height > 0) {
            CGFloat radius = MAX(self.cornerRadius.width, self.cornerRadius.height);
            CGFloat halfBorderWidth = self.borderWidth * 0.5;
            CGPathMoveToPoint(path, NULL, self.left + halfBorderWidth, self.top + radius);
            CGPathAddArc(path, NULL, self.left + radius, self.top + radius, radius - halfBorderWidth, M_PI, M_PI * 1.5, NO);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame) - radius, self.top + halfBorderWidth);
            CGPathAddArc(path, NULL, CGRectGetMaxX(frame) - radius, self.top + radius, radius - halfBorderWidth, M_PI * 1.5, M_PI * 2, NO);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame) - halfBorderWidth, CGRectGetMaxY(frame) - radius);
            CGPathAddArc(path, NULL, CGRectGetMaxX(frame) - radius, CGRectGetMaxY(frame) - radius, radius - halfBorderWidth, M_PI * 0, M_PI * 0.5, NO);
            CGPathAddLineToPoint(path, NULL, self.left + radius, CGRectGetMaxY(frame) - halfBorderWidth);
            CGPathAddArc(path, NULL, self.left + radius, CGRectGetMaxY(frame) - radius, radius - halfBorderWidth, M_PI * 0.5, M_PI * 1, NO);
            CGPathAddLineToPoint(path, NULL, self.left + halfBorderWidth, self.top + radius);
        } else {
            CGPathAddRect(path, NULL, CGRectInset(frame, self.borderWidth * 0.5, self.borderWidth * 0.5));
        }
        CGContextAddPath(context, path);
        CGPathRelease(path);
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextStrokePath(context);
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
    }

    // 文本背景色跟layout背景色不一致才需要填充文本背景色
    if (textBgColor != bgColor) {
        CGMutablePathRef path = CGPathCreateMutable();
        if (self.cornerRadius.width > 0 || self.cornerRadius.height > 0) {
            CGFloat radius = MAX(self.cornerRadius.width, self.cornerRadius.height);
            CGFloat halfBorderWidth = self.borderWidth * 0.5;
            CGPathMoveToPoint(path, NULL, self.left + halfBorderWidth, self.top + radius);
            CGPathAddArc(path, NULL, self.left + radius, self.top + radius, radius - halfBorderWidth, M_PI, M_PI * 1.5, NO);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame) - halfBorderWidth, self.top + halfBorderWidth);
            CGPathAddArc(path, NULL, CGRectGetMaxX(frame) - radius, self.top + radius, radius - halfBorderWidth, M_PI * 1.5, M_PI * 2, NO);
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame) - halfBorderWidth, CGRectGetMaxY(frame) - radius);
            CGPathAddArc(path, NULL, CGRectGetMaxX(frame) - radius, CGRectGetMaxY(frame) - radius, radius - halfBorderWidth, M_PI * 0, M_PI * 0.5, NO);
            CGPathAddLineToPoint(path, NULL, self.left + radius, CGRectGetMaxY(frame) - halfBorderWidth);
            CGPathAddArc(path, NULL, self.left + radius, CGRectGetMaxY(frame) - radius, radius - halfBorderWidth, M_PI * 0.5, M_PI * 1, NO);
            CGPathAddLineToPoint(path, NULL, self.left + halfBorderWidth, self.top + radius);
        } else {
            CGPathAddRect(path, NULL, CGRectInset(frame, self.borderWidth * 0.5, self.borderWidth * 0.5));
        }
        
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
                CGRect highlightframe = [framevalue CGRectValue];
                highlightframe.origin.x += CGRectGetMinX(frame);
                highlightframe.origin.y += CGRectGetMinY(frame);
                CGContextFillRect(context, highlightframe);
            }
        }
    }

    
    // 转换矩阵:<UIKit> -> <CoreText>
    // 翻转矩阵时，要用originSize:CTLine等都是在原始size生成的
    CGContextTranslateCTM(context, self.left + self.insets.left, self.top + self.viewSize.height - self.insets.bottom);
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
        CGContextSetTextPosition(context, line.ctOrigin.x, line.ctOrigin.y);
        // 绘制行
        CTLineDraw(line.ctLine, context);
        // 如果有附件,要绘制附件
        for (JFTextRun* run in line.ctRuns) {
            // 图片附件
            for (JFTextAttachmentImage* imageAttachment in run.imageAttachments) {
                CGRect imageCtFrame = imageAttachment.ctFrame;
                imageCtFrame.origin.y += -line.descent + (line.ascent + line.descent - imageCtFrame.size.height) * 0.5;
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
    
    // 测试时:绘制行边框
    if (self.debug) {
        CGContextTranslateCTM(context, - self.left - self.insets.left, self.top + self.viewSize.height - self.insets.bottom);
        CGContextScaleCTM(context, 1, -1);
        if (cancelled()) {
            CGContextRestoreGState(context);
            return;
        }
        for (JFTextLine* line in self.ctLines) {
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
            CGContextStrokeRect(context, CGRectMake(line.uiOrigin.x,
                                                    line.uiOrigin.y,
                                                    line.width,
                                                    line.descent + line.ascent));
            if (cancelled()) {
                CGContextRestoreGState(context);
                return;
            }
        }
    }
    CGContextRestoreGState(context);
}

# pragma mark - 计算布局
- (void) relayouting {
    // 判断是否需要计算布局:尺寸过小||文本为空;就不用布局了
    if (self.viewSize.width < 0.1 ||
        self.viewSize.height < 0.1 ||
        !self.textStorage //|| self.textStorage.text.length == 0
        )
    {
        return;
    }
    
    // 准备工作: 定义布局退出block
    [_asyncFlag incrementFlag];
    int curFlag = self.asyncFlag.curFlag;
    __weak JFAsyncFlag* weakFlag = self.asyncFlag;
    IsCancelled layoutCancelled = ^ BOOL {
        return curFlag != weakFlag.curFlag;
    };
    
    // 先释放历史生成的 framesetter等
    [self freeFramer];
    
    /* --- 计算布局 --- */
    CGRect frame = CGRectMake(self.left +  self.insets.left,
                              self.top + self.insets.top,
                              self.viewSize.width - self.insets.left - self.insets.right,
                              self.viewSize.height - self.insets.top - self.insets.bottom);
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
        
        // 需要截断,且已到截断行
        if (i == numberOfLines - 1 && numberOfLines < linesCount) {
            // 省略号
            NSString* JFEllipsesCharacter = self.shouldShowMoreAct ? @"\u2026全文" : @"\u2026";
            CFRange lastLineRange = CTLineGetStringRange(line);
            // 截断模式:截末尾
            CTLineTruncationType truncationType = kCTLineTruncationEnd;
            // 最后一个截断的字符的位置
            NSUInteger truncationPosition = lastLineRange.location + lastLineRange.length - 1;
            // 获取最后一个字符的属性
            NSDictionary* tokenAttri = [self.textStorage.text attributesAtIndex:truncationPosition effectiveRange:NULL];
            // 创建省略号富文本
            NSMutableAttributedString* tokenString = [[NSMutableAttributedString alloc] initWithString:JFEllipsesCharacter attributes:tokenAttri];
            if (layoutCancelled()) return;
            if (self.shouldShowMoreAct && self.showMoreActColor) {
                [tokenString addAttribute:NSForegroundColorAttributeName value:self.showMoreActColor range:[JFEllipsesCharacter rangeOfString:@"全文"]];
                // 添加高亮属性
                JFTextAttachmentHighlight* highLight = [JFTextAttachmentHighlight new];
//                highLight.isHighlight = YES;
                highLight.linkData = @"全文";
                highLight.normalBackgroundColor = self.textStorage.backgroundColor;
                highLight.range = NSMakeRange(NSNotFound, 0);
                [self.textStorage addHighlight:highLight];
                [tokenString addAttribute:JFTextAttachmentHighlightName value:highLight range:[JFEllipsesCharacter rangeOfString:@"全文"]];
            }
            if (layoutCancelled()) return;
            // 生成line
            CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
            // 将当前行富文本复制一份
            NSMutableAttributedString* truncationString = [[self.textStorage.text attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
            // 去掉末尾的空白字符
            if (lastLineRange.length > 0) {
                unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
                NSCharacterSet* whiteSpaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                if ([whiteSpaceSet characterIsMember:lastCharacter]) {
                    [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                }
            }
            // 拼接省略号
            [truncationString appendAttributedString:tokenString];
            if (layoutCancelled()) return;

            // 将拼接后的string转成CTLine
            CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
            // 截断
            CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, frame.size.width, truncationType, truncationToken);
            if (!truncatedLine) {
                truncatedLine = CFRetain(truncationToken);
            }
            CFRelease(truncationLine);
            CFRelease(truncationToken);
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
    // 根据布局重置实际的文本size,可以用于重置label的frame
    if (self.shouldSuggustingSize) {
        self.suggustSize = CGSizeMake(floor(suggustWidth + self.insets.left + self.insets.right),
                                      floor(suggustHeight + self.insets.top + self.insets.bottom));
    } else {
        self.suggustSize = self.viewSize;
    }
    // 保存行对象
    self.ctLines = ctLines.copy;
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
- (void)setViewSize:(CGSize)viewSize {
    [super setViewSize:viewSize];
    [self relayouting];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self relayouting];
}
- (void)setInsets:(UIEdgeInsets)insets {
    [super setInsets:insets];
    [self relayouting];
}
- (void)setShowMoreActColor:(UIColor *)showMoreActColor {
    _showMoreActColor = showMoreActColor;
    [self relayouting];
}
- (void)setShouldShowMoreAct:(BOOL)shouldShowMoreAct {
    _shouldShowMoreAct = shouldShowMoreAct;
    [self relayouting];
}
- (void)setViewOrigin:(CGPoint)viewOrigin {
    [super setViewOrigin:viewOrigin];
    [self relayouting];
}


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
    JFTextLayout* textLayout = [[self alloc] initWithFrame:frame insets:insets backgroundColor:backgroundColor];
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

//
//  TextView2.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/9.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "TextView2.h"
#import "JFKit.h"
#import <CoreText/CoreText.h>

@interface TextView2()
@property (nonatomic, strong) NSMutableAttributedString* attriText;
@end

@implementation TextView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self initializeAttriText];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSaveGState(context);
//    // 有效的
//    CGRect suggustFrame = rect;
//    suggustFrame.size.height = 0;
//
//    // 背景色:没有就用浅灰色
//    UIColor* backgroundColor = self.backgroundColor ? self.backgroundColor : JFRGBAColor(0xf5f5f5, 1);
//    //
//    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
//    // 背景色填充原始的frame
//    CGContextFillRect(context, rect);
//
//    // 文本绘制区域
//    CGRect textFrame = CGRectInset(rect, 5, 5);
//    suggustFrame.size.height += 5;
//    CFRange allRange = CFRangeMake(0, 0);
//    CGPathRef path = CGPathCreateWithRect(textFrame, NULL);
//    // 创建frame属性
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attriText.copy);
//    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, allRange, path, NULL);
//
//    // 获取所有行
//    CFArrayRef linesArray = CTFrameGetLines(frameRef);
//    CFIndex linesCount = CFArrayGetCount(linesArray);
//    // 缓存每行的起点坐标:<core text>坐标系,而且是baseLine的起点
//    CGPoint linesOrigin[linesCount];
//    CTFrameGetLineOrigins(frameRef, allRange, linesOrigin);
//
//    // 绘制前转换坐标系:UIKit -> CoreText
//    CGContextTranslateCTM(context, textFrame.origin.x, textFrame.origin.y);
//    CGContextTranslateCTM(context, 0, textFrame.size.height);
//    CGContextScaleCTM(context, 1, -1);
//
//    CGContextSetLineWidth(context, 0.5);
//    // 只绘制前4行
//    for (CFIndex i = 0; i < 4; i++) {
//        // 获取指定行的line
//        CTLineRef line = CFArrayGetValueAtIndex(linesArray, i);
//        // 这个是获取的:是整个line的宽度
//        CGFloat ascent;
//        CGFloat descent;
//        CGFloat leading;
//        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
//        CGRect lineFrame = CGRectMake(linesOrigin[i].x,
//                                      linesOrigin[i].y - descent,
//                                      lineWidth,
//                                      ascent + descent);
//        // 绘制行的边框
//        CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
//        CGContextStrokeRect(context, lineFrame);
//        // 移动context到行的起点坐标
//        CGContextSetTextPosition(context, linesOrigin[i].x, linesOrigin[i].y);
//        NSLog(@"---line[%ld],ascent[%.02lf],descent[%.02lf],leading[%.02lf]",i,ascent,descent,leading);
//        suggustFrame.size.height += ascent + descent + leading ;
//        // 绘制行
//        CTLineDraw(line, context);
//
//        // 访问line的run属性
//        CFArrayRef runs = CTLineGetGlyphRuns(line);
//        CFIndex runsCount = CFArrayGetCount(runs);
//        for (CFIndex j = 0; j < runsCount; j++) {
//            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
//            CFIndex glyphCount = CTRunGetGlyphCount(run);
//            CGPoint glyphPositions[glyphCount];
//            CGFloat runAs;
//            CGFloat runDes;
//            CTRunGetPositions(run, CFRangeMake(0, 0), glyphPositions);
//            CGFloat runWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAs, &runDes, NULL);
//
//
//
//            CFDictionaryRef attribute = CTRunGetAttributes(run);
//            NSDictionary* runAttri = (__bridge NSDictionary*)attribute;
//            for (NSString* key in runAttri.allKeys) {
////                if ([key isEqualToString:JFTextAttachmentName]) {
////                    // 绘制附件的边框
////                    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
////                    CGContextStrokeRect(context, CGRectMake(linesOrigin[i].x + glyphPositions[j].x,
////                                                            linesOrigin[i].y - glyphPositions[j].y,
////                                                            runWidth, runAs + runDes));
////
////
////                    JFTextAttachment* attachment = [runAttri objectForKey:key];
////                    CGFloat maxheight = ascent + descent;
////                    // 附件图片的frame
////                    /*
////                     图片的y坐标: line.baseline.y - line.下部 + (整个行高 - 附件高) * 0.5
////                     */
////                    attachment.frame = CGRectMake(linesOrigin[i].x + glyphPositions[0].x ,
////                                                  linesOrigin[i].y - descent + (maxheight - attachment.contentSize.height) * 0.5,
////                                                  attachment.contentSize.width,
////                                                  attachment.contentSize.height);
////                    CGContextDrawImage(context, attachment.frame, ((UIImage*)attachment.contents).CGImage);
////                }
//            }
//        }
//    }
//
//
//    suggustFrame.size.height += 5 + 2/*行间距*/ * 3;
//    CGContextRestoreGState(context);
//
//    CGContextSetLineWidth(context, 0.5);
//    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//    // 像素对齐,不然,绘制的线条有的跟实际线宽不一致
//    CGContextStrokeRect(context, CGRectInset(suggustFrame, 0.5, 0.5));
//
//    // 直接绘制frame属性
////    CTFrameDraw(frameRef, context);
//
//
//    // 释放资源
//    CGPathRelease(path);
//    CFRelease(frameRef);
//    CFRelease(frameSetter);
//
//}

//- (void) initializeAttriText {
//    NSString* text = @"我们将字体设置为BodoniSvtyTwoITCTT。这是字体的PostScript名。如果想寻找字体名，我们可以使用+[UIFont familyNames]首先得到可用的字体系列集合。一个字体系列就是我们所熟知的字型。每个字型或字体系列有一个或多个字体。";
//    NSRange allRange = NSMakeRange(0, text.length);
//    self.attriText = [[NSMutableAttributedString alloc] initWithString:text];
//    // 字体
//    [self.attriText addAttribute:NSFontAttributeName value:JFFontWithName(@"Heiti SC", 17) range:allRange];
//    // 图片附件1
//    JFTextAttachment* attachment = [JFTextAttachment new];
//    UIImage* image = [UIImage imageNamed:@"personal_icon_attention"]; // icon_robot_orange personal_icon_attention
//    attachment.contents = image;
//    attachment.range = NSMakeRange(2, 1);
//    attachment.kern = 1;
//    CGFloat textHeight = JFTextSizeInFont(@"我们", JFFontWithName(@"Heiti SC", 17)).height ;
//    attachment.contentSize = CGSizeMake(textHeight * image.size.width/image.size.height, textHeight);
//    [self.attriText addTextAttachment:attachment];
//    // 图片附件1
//    JFTextAttachment* attachment2 = [JFTextAttachment new];
//    UIImage* image2 = [UIImage imageNamed:@"detail_icon_collection_selected"];
//    attachment2.contents = image2;
//    attachment2.range = NSMakeRange(3, 1);
//    attachment2.kern = 2;
//    CGFloat textHeight2 = JFTextSizeInFont(@"我们", JFFontWithName(@"Heiti SC", 17)).height ;
//    attachment2.contentSize = CGSizeMake(textHeight2 * image2.size.width/image2.size.height, textHeight2);
//    [self.attriText addTextAttachment:attachment2];
//
//    // 字颜色
//    [self.attriText addAttribute:NSForegroundColorAttributeName value:JFRGBAColor(0x28374b, 1) range:allRange];
//    // 背景颜色
////    [self.attriText addAttribute:NSBackgroundColorAttributeName value:JFRGBAColor(0x00ff00, 1) range:NSMakeRange(2, 1)];
//    // 字间距:汉字才有字间距
//    [self.attriText addAttribute:NSKernAttributeName value:@(1) range:allRange];
//    // 附件两边都要加上更宽的字间距
//    [self.attriText addAttribute:NSKernAttributeName value:@(2) range:NSMakeRange(2 - 1, 1)];
//
//
//    [self.attriText removeAttribute:NSKernAttributeName range:[text rangeOfString:@"BodoniSvtyTwoITCTT"]];
//    [self.attriText removeAttribute:NSKernAttributeName range:[text rangeOfString:@"PostScript"]];
//    [self.attriText removeAttribute:NSKernAttributeName range:[text rangeOfString:@"UIFont"]];
//    [self.attriText removeAttribute:NSKernAttributeName range:[text rangeOfString:@"familyNames"]];
//    // 段落
//    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
//    para.lineSpacing = 2;
//    para.firstLineHeadIndent = 20;
//    para.lineBreakMode = NSLineBreakByCharWrapping;
//    [self.attriText addAttribute:NSParagraphStyleAttributeName value:para.copy range:allRange];
//}




@end

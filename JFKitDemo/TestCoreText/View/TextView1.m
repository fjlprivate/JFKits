//
//  TextView1.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/8.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "TextView1.h"
#import "JFKit.h"
#import <CoreText/CoreText.h>
#import "JFTextAttachment.h"

@implementation TextView1


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 绘制背景色: f5f5f5
    CGContextSetFillColorWithColor(context, JFRGBAColor(0xf5f5f5, 1).CGColor);
    CGContextFillRect(context, rect);
    
    // 创建富文本
    NSString* text = @"百度AI开放平台,是面向企业/机构/创业者/开发者,将百度在人工智能领域积累的技术以API或SDK等形式对外共享的在线平台";

    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    // 图片附件
    CGFloat textHeight = JFTextSizeInFont(nil, JFFontWithName(@"Heiti SC", 17)).height;
    UIImage* image = [UIImage imageNamed:@"icon_robot_orange"];
    JFTextAttachmentImage* imageAttach = [JFTextAttachmentImage new];
    imageAttach.image = image;
    imageAttach.imageSize = CGSizeMake(textHeight, textHeight * image.size.width/image.size.height);
    imageAttach.index = 4;
    imageAttach.kern = 4;
    [attributedText jf_addImage:imageAttach];
    [attributedText jf_setBackgroundColor:JFRGBAColor(0, 0.2) atRange:NSMakeRange(4, 1)];
    
    NSRange totalRange = NSMakeRange(0, attributedText.length);
    NSRange apiRange = [attributedText.string rangeOfString:@"API"];
    NSRange sdkRange = [attributedText.string rangeOfString:@"SDK"];
    NSRange aiRange = [attributedText.string rangeOfString:@"AI"];

    
    // 字体
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Heiti SC" size:17] range:totalRange];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:17] range:apiRange];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:17] range:apiRange];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:17] range:sdkRange];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:17] range:NSMakeRange(sdkRange.location+sdkRange.length, totalRange.length - sdkRange.location-sdkRange.length)];


    // 段落
    NSMutableParagraphStyle* parapgraph = [NSMutableParagraphStyle new];
//    parapgraph.lineSpacing = 2;
    parapgraph.firstLineHeadIndent = 20; // 段头缩进
    parapgraph.headIndent = 5; // 每行的头缩进??
//    parapgraph.baseWritingDirection = NSWritingDirectionRightToLeft; // 从右往左写,跟rightAlignment比较像
//    parapgraph.alignment = NSTextAlignmentRight;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:parapgraph range:totalRange];
    // 文字颜色
    [attributedText addAttribute:NSForegroundColorAttributeName value:JFRGBAColor(0x27384b, 1) range:totalRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:apiRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:sdkRange];

    // 背景颜色
//    [attributedText addAttribute:NSBackgroundColorAttributeName value:JFHexColor(0, 0.2) range:NSMakeRange(0, 1)];
    // 文字间距
    [attributedText addAttribute:NSKernAttributeName value:@(1) range:totalRange];
    [attributedText removeAttribute:NSKernAttributeName range:apiRange];
    [attributedText removeAttribute:NSKernAttributeName range:sdkRange];
    [attributedText removeAttribute:NSKernAttributeName range:aiRange];
    [attributedText addAttribute:NSKernAttributeName value:@(4) range:NSMakeRange(apiRange.location - 1, 1)];
    [attributedText addAttribute:NSKernAttributeName value:@(4) range:NSMakeRange(apiRange.location+apiRange.length - 1, 1)];
    [attributedText jf_setKern:4 atRange:NSMakeRange(3, 1)];

    // 删除线
//    NSRange strikethroughRange = NSMakeRange(20, 5);
//    [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@(3) range:totalRange];
//    [attributedText addAttribute:NSStrikethroughColorAttributeName value:[UIColor orangeColor] range:totalRange];
//    [attributedText addAttribute:NSBaselineOffsetAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:totalRange];
    // 描边
//    [attributedText addAttribute:NSStrokeWidthAttributeName value:@(2) range:strikethroughRange];
    // 阴影
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(3, 3);
    shadow.shadowColor = [UIColor blackColor];
    [attributedText addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(30, 6)];

    // 下划线
//    [attributedText addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(20, 5)];
//    [attributedText addAttribute:NSUnderlineColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(20, 5)];

    // link
//    [attributedText addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"www.baidu.com"] range:NSMakeRange(text.length - 5, 5)];
//    NSTextContainer
    
    // 生成文本frame，并绘制
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText.copy);
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, text.length), path, nil);
//    CTFrame
    // 绘制前先翻转矩阵
    CGContextTranslateCTM(context, 0, CGRectGetHeight(rect));
    CGContextScaleCTM(context, 1, -1);
    CTFrameDraw(frameRef, context);
    
    
    CFRelease(frameRef);
    CFRelease(path);
    CFRelease(frameSetter);
    
    //
    NSRange longestRange;
    id fontAttributes = [attributedText attribute:NSFontAttributeName atIndex:0 longestEffectiveRange:&longestRange inRange:apiRange];
    

}


@end

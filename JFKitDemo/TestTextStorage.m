//
//  TestTextStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/13.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestTextStorage.h"
#import "JFAsyncDisplayLayer.h"
#import "NSMutableAttributedString+Extension.h"
#import <CoreText/CoreText.h>
#import "JFKit.h"

@interface TestTextStorage() <JFAsyncDisplayDelegate>

@end

@implementation TestTextStorage

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.frame = self.frame;
    self.backgroundColor = JFHexColor(0, 0.1);
    [self.layer setNeedsDisplay];
}


- (JFAsyncDisplayCallBacks*) asyncDisplayCallBacks {
    JFAsyncDisplayCallBacks* callBack = [JFAsyncDisplayCallBacks new];
    
    callBack.willDisplay = ^(JFAsyncDisplayLayer *layer) {
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.displayedAsyncchronous = YES;
    };
    
    callBack.display = ^(CGContextRef context, CGSize size, IsCanceled isCanceled) {
        
        
        
        
        NSString* text = @"束带结发垃圾的说法";
        NSMutableAttributedString* attriStr = [[NSMutableAttributedString alloc] initWithString:text];
        
        JFTextAttachment* attachment = [JFTextAttachment new];
        attachment.range = NSMakeRange(0, 1);
        attachment.contents = [[UIImage imageNamed:@"selectedBlue"] copy];
        attachment.contentSize = CGSizeMake(20, 20);
        attachment.frame = CGRectMake(0, 0, 20, 20);

        [attriStr addTextAttachment:attachment];
        
        CGRect frame = CGRectMake(10, 10, 50, 30);
        
        CGContextSetFillColorWithColor(context, JFHexColor(0x27384b, 1).CGColor);
        CGContextFillRect(context, frame);
        
        NSMutableArray* aaray = [NSMutableArray array];
        [aaray addObject:attachment];
        
        
        
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriStr);
        CGPathRef path = CGPathCreateWithRect(frame, NULL);
        CTFrameRef textframe = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
        
        CFArrayRef lines = CTFrameGetLines(textframe);
        CFIndex linesCount = CFArrayGetCount(lines);
        BOOL hasCount = NO;
        for (CFIndex i = 0; i < linesCount; i++) {
            if (hasCount) {
                break;
            }
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            CFArrayRef runs = CTLineGetGlyphRuns(line);
            CFIndex runsCount = CFArrayGetCount(runs);
            for (CFIndex j= 0; j < runsCount; j++) {
                CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                CFDictionaryRef attri = CTRunGetAttributes(run);
                if (attri) {
                    NSDictionary* dic = (__bridge NSDictionary*)attri;
                    JFTextAttachment* attach = [dic objectForKey:JFTextAttachmentName];
                    if (attach) {
                        
                        NSLog(@"---对比数组中的附件地址[%p]和文本属性中的附件地址[%p]", [aaray objectAtIndex:0], attach);
                        // 经对比发现，这两个附件对象是同一个对象，内存地址都相同
                        
                        hasCount = YES;
                        break;
                    }
                }
                
            }
        }
        
        
        
        UIImage* image = attachment.contents;
        [image drawInRect:attachment.frame];

        
        
    };
    
    callBack.didDisplayed = ^(JFAsyncDisplayLayer *layer, BOOL finished) {
        
    };
    
    return callBack;
}

+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}


@end

//
//  AsyncGView.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/11.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "AsyncGView.h"
#import "Gallop.h"
#import "JFKit.h"


@interface AsyncGView() <LWAsyncDisplayLayerDelegate>

@end
@implementation AsyncGView



- (LWAsyncDisplayTransaction *)asyncDisplayTransaction {
    LWAsyncDisplayTransaction* trans = [LWAsyncDisplayTransaction new];
    
    trans.willDisplayBlock = ^(CALayer *layer) {
        
    };
    
    trans.displayBlock = ^(CGContextRef context, CGSize size, LWAsyncDisplayIsCanclledBlock isCancelledBlock) {
        NSLog(@"--正在绘制layer");
        
        CGContextSaveGState(context);
        
//        UIFont* font1 = [UIFont fontWithName:@"Heiti SC" size:14];
//        NSString* text1 = @"文本1";
//        CGSize textSize1 = JFTextSizeInFont(text1, font1);
//        
//        [text1 drawInRect:CGRectMake(20, 20, textSize1.width, textSize1.height)
//           withAttributes:@{NSFontAttributeName:font1,
//                            NSForegroundColorAttributeName:JFHexColor(0x00a1dc, 1)}];
//        
//        NSString* text2 = @"文本2";
//        CGSize textSize2 = JFTextSizeInFont(text2, font1);
//        [text2 drawInRect:CGRectMake(20, 80, textSize2.width, textSize2.height)
//           withAttributes:@{NSFontAttributeName:font1,
//                            NSForegroundColorAttributeName:JFHexColor(0x27384b, 1)}];
        
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 60, 40, 10) cornerRadius:2];
        CGContextSetFillColorWithColor(context, JFHexColor(0xef454b, 1).CGColor);
        CGContextAddPath(context, path.CGPath);
        CGContextFillPath(context);
        
        path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5];
        CGContextSetStrokeColorWithColor(context, JFHexColor(0x27384b, 1).CGColor);
        CGContextSetLineWidth(context, 0.8);
        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
    };
    
    trans.didDisplayBlock = ^(CALayer *layer, BOOL finished) {
        
    };
    
    return trans;
}



+ (Class)layerClass {
    return [LWAsyncDisplayLayer class];
}

@end

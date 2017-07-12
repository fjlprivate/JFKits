//
//  AsyncDView.m
//  JFKit
//
//  Created by warmjar on 2017/7/11.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "AsyncDView.h"
#import "JFKit.h"


@interface AsyncDView() <JFAsyncDisplayDelegate>

@property (nonatomic, strong) JFAsyncDisplayCallBacks* asyncDisplayCallBack;

@end

@implementation AsyncDView


# pragma mask 2 JFAsyncDisplayDelegate
- (JFAsyncDisplayCallBacks *)asyncDisplayCallBacks {
    return self.asyncDisplayCallBack;
}


# pragma mask 3 life cycle

+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}

# pragma mask 4

- (JFAsyncDisplayCallBacks *)asyncDisplayCallBack {
    if (!_asyncDisplayCallBack) {
        __weak typeof(self) wself = self;
        _asyncDisplayCallBack = [[JFAsyncDisplayCallBacks alloc] init];
        // 即将显示layer
        _asyncDisplayCallBack.willDisplay = ^(JFAsyncDisplayLayer *layer) {
            NSLog(@"--即将开始绘制layer");
            layer.displayedAsyncchronous = wself.asynchronously;
            layer.contentsScale = [UIScreen mainScreen].scale;
        };
        
        // 正在绘制layer
        _asyncDisplayCallBack.display = ^(CGContextRef context, CGSize size, IsCanceled isCanceled) {
            NSLog(@"--正在绘制layer");
            
            CGContextSaveGState(context);
            
            UIFont* font1 = [UIFont fontWithName:@"Heiti SC" size:14];
            UIImage* image = [UIImage imageNamed:@"selectedBlue"];

            
            // 文本1
            NSString* text1 = @"文本1";
            CGSize textSize1 = JFTextSizeInFont(text1, font1);
            
            CGRect frame = CGRectMake(10, 5, textSize1.width, textSize1.height);
            
            [text1 drawInRect:frame
               withAttributes:@{NSFontAttributeName:font1,
                                NSForegroundColorAttributeName:JFHexColor(0x00a1dc, 1)}];

            // 间隔
            frame.origin.x += frame.size.width + 4;
            frame.size.width = 8;
            UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:2];
            CGContextSetFillColorWithColor(context, JFHexColor(0xef454b, 1).CGColor);
            CGContextAddPath(context, path.CGPath);
            CGContextFillPath(context);
            
            // 文本2
            NSString* text2 = @"文本2";
            CGSize textSize2 = JFTextSizeInFont(text2, font1);
            frame.origin.x += frame.size.width + 4;
            frame.size.width = textSize2.width;
            
            [text2 drawInRect:frame
               withAttributes:@{NSFontAttributeName:font1,
                                NSForegroundColorAttributeName:JFHexColor(0x27384b, 1)}];
            
            // 翻转坐标系
            CGContextTranslateCTM(context, 0, size.height);
            CGContextScaleCTM(context, 1, -1);
            CGAffineTransform tt = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, size.height);
            tt = CGAffineTransformScale(tt, 1, -1);
            CGRect imageRect;
            // 图片
            frame.origin.x += frame.size.width + 4;
            frame.size.width = frame.size.height = 20;
            // 图片的frame也要翻转
            imageRect = CGRectApplyAffineTransform(frame, tt);
            CGContextDrawImage(context, imageRect, image.CGImage);
            
            // 图片
            frame.origin.x += frame.size.width + 4;
            frame.size.width = frame.size.height = 20;
            // 图片的frame也要翻转
            imageRect = CGRectApplyAffineTransform(frame, tt);
            CGContextDrawImage(context, imageRect, image.CGImage);

            // 图片
            frame.origin.x += frame.size.width + 4;
            frame.size.width = frame.size.height = 20;
            // 图片的frame也要翻转
            imageRect = CGRectApplyAffineTransform(frame, tt);
            CGContextDrawImage(context, imageRect, image.CGImage);
            // 图片
            frame.origin.x += frame.size.width + 4;
            frame.size.width = frame.size.height = 20;
            // 图片的frame也要翻转
            imageRect = CGRectApplyAffineTransform(frame, tt);
            CGContextDrawImage(context, imageRect, image.CGImage);

            
            // 边框
            CGFloat borderWidth = 0.8;
            CGRect borderRect = CGRectInset(wself.bounds, borderWidth, borderWidth);
            path = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:5];
            CGContextSetStrokeColorWithColor(context, JFHexColor(0x27384b, 1).CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextAddPath(context, path.CGPath);
            CGContextStrokePath(context);
            
            CGContextRestoreGState(context);
            
        };
        
        // 绘制layer完毕
        _asyncDisplayCallBack.didDisplayed = ^(JFAsyncDisplayLayer *layer, BOOL finished) {
            NSLog(@"--绘制layer完毕");
        };

    }
    return _asyncDisplayCallBack;
}

@end

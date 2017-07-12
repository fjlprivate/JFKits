//
//  JFAsyncDisplayLayer.m
//  JFKit
//
//  Created by warmjar on 2017/7/10.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFAsyncDisplayLayer.h"
#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>

@interface JFAsyncDisplayLayer() {
    int32_t displayFlag_; // 显示标记
}

@end

@implementation JFAsyncDisplayLayer


# pragma mask 1 flag 

- (int32_t) curFlag {
    return displayFlag_;
}

- (void) increaseFlag {
    OSAtomicIncrement32(&displayFlag_);
}


# pragma mask 2 display

- (void)setNeedsDisplay {
    [self increaseFlag];
    [super setNeedsDisplay];
}

- (void)display {
    [self displayAsynchronous:self.displayedAsyncchronous];
}

# pragma mask 3

- (void) displayAsynchronous:(BOOL)asynchronous {
    // 获取delegate(UIView)提供的异步绘制任务block
    id<JFAsyncDisplayDelegate> view = (id)self.delegate;
    JFAsyncDisplayCallBacks* asyncDisplayBlock = [view asyncDisplayCallBacks];
    
    // 执行绘制前任务
    if (asyncDisplayBlock.willDisplay) {
        asyncDisplayBlock.willDisplay(self);
    }
    
    
    // 生成判断绘制是否中断的block
    int32_t flag = displayFlag_;
    IsCanceled isCanceled = ^BOOL() {
        return flag != displayFlag_;
    };
    
    
    if (asynchronous) {
        NSLog(@"--异步绘制");
        // 清除原来的contents
        CGImageRef image = (__bridge_retained CGImageRef)self.contents;
        self.contents = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CGImageRelease(image);
        });

        
        BOOL opaque = self.opaque;
        CGColorRef backcolor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        CGSize size = self.bounds.size;
        CGFloat scale = self.contentsScale;
        
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //
            if (isCanceled()) {
                if (asyncDisplayBlock.didDisplayed) {
                    asyncDisplayBlock.didDisplayed(self, NO);
                }
                return ;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();

            // 注意opaque属性,yes为不透明，no为透明，默认为no
            // 如果在no，即透明的情况下来绘制背景色，会报错
            if (opaque) {
                CGContextSaveGState(context);
                
                if (backcolor && CGColorGetAlpha(backcolor) == 1.0) {
                    CGContextSetFillColorWithColor(context, backcolor);
                } else {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                }
                // 绘制背景色
                CGContextFillRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                CGContextRestoreGState(context);
                CGColorRelease(backcolor);
            }

            // 调用绘制block绘制任务
            asyncDisplayBlock.display(context, size, isCanceled);

            if (isCanceled()) {
                UIGraphicsEndImageContext();
                if (asyncDisplayBlock.didDisplayed) {
                    asyncDisplayBlock.didDisplayed(self, NO);
                }
                return ;
            }

            // 取出图片
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            if (isCanceled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (asyncDisplayBlock.didDisplayed) {
                        asyncDisplayBlock.didDisplayed(self, NO);
                    }
                });
            }
            
            // 回主线程更新contents，并回调
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(wself) sself = wself;
                sself.contents = (__bridge id)image.CGImage;
                if (asyncDisplayBlock.didDisplayed) {
                    asyncDisplayBlock.didDisplayed(self, NO);
                }
            });
        });
    }
    else {
        NSLog(@"--同步绘制");
        if (asyncDisplayBlock.display) {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            if (self.opaque) {
                // 背景色
                CGColorRef backColor = self.backgroundColor && CGColorGetAlpha(self.backgroundColor) >= 1.0 ? CGColorRetain(self.backgroundColor) : CGColorRetain([UIColor whiteColor].CGColor);
                
                // 绘制背景色
                CGContextSetFillColorWithColor(context, backColor);
                CGContextFillRect(context, self.bounds);
                CGColorRelease(backColor);
                
            }

            // 调用绘制block绘制任务
            asyncDisplayBlock.display(context, self.bounds.size, isCanceled);
            
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.contents = (__bridge id)image.CGImage;
            
        }
        // 执行绘制后任务
        if (asyncDisplayBlock.didDisplayed) {
            asyncDisplayBlock.didDisplayed(self, YES);
        }
    }
    
    
    
}


# pragma mask 4



@end



@implementation JFAsyncDisplayCallBacks


@end

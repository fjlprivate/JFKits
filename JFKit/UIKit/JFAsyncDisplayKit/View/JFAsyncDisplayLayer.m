//
//  JFAsyncDisplayLayer.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFAsyncDisplayLayer.h"
#import "JFAsyncFlag.h"
#import "JFMacro.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


@interface JFAsyncDisplayLayer()
@property (nonatomic, strong) JFAsyncFlag* asyncFlag;
@end

@implementation JFAsyncDisplayLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.asynchronized = YES;
    }
    return self;
}

- (void)display {
    [self displayingAsynchronized:self.asynchronized];
}

// 取消当前绘制
- (void) cancelDisplaying {
    [self.asyncFlag incrementFlag];
}


// 是否异步绘制: YES[异步];NO[同步];
- (void) displayingAsynchronized:(BOOL)asynchronized {
    [self.asyncFlag incrementFlag];
    int curFlag = self.asyncFlag.curFlag;
    WeakSelf(wself);
    IsCancelled cancelled = ^BOOL {
        return curFlag != wself.asyncFlag.curFlag;
    };
    // 通知:即将开始绘制
    [self.delegate asyncDisplayLayerWillDisplay:self];
    // 绘制前的准备
    CGColorRef bgColor = self.backgroundColor;
    CGFloat alpha = CGColorGetAlpha(bgColor);
    BOOL opaque = self.opaque ? (alpha >= 1 ? YES : NO) : NO;
    CGRect bounds = self.bounds;
    // 如果是透明或者无背景色:默认白色
    if (!opaque || !bgColor) {
        bgColor = [UIColor whiteColor].CGColor;
    }
    if (cancelled()) {
        return;
    }
    // 异步绘制
    if (asynchronized) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 创建并获取上下文
            UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (cancelled()) {
                UIGraphicsEndImageContext();
                return;
            }
            // 绘制背景色
            CGContextSetFillColorWithColor(context, bgColor);
            CGContextFillRect(context, bounds);
            if (cancelled()) {
                UIGraphicsEndImageContext();
                return;
            }
            // delegate发起绘制
            [wself.delegate asyncDisplayLayer:wself displayingInContext:context cancelled:cancelled];
            if (cancelled()) {
                UIGraphicsEndImageContext();
                return;
            }
            // 获取绘制的图片
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (cancelled()) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.contents = (__bridge id)image.CGImage;
                // 通知:绘制完毕
                [wself.delegate asyncDisplayLayerDidEndDisplay:wself];
            });
        });
    }
    // 同步绘制
    else {
        // 创建并获取上下文
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (cancelled()) {
            UIGraphicsEndImageContext();
            return;
        }
        // 绘制背景色
        CGContextSetFillColorWithColor(context, bgColor);
        CGContextFillRect(context, bounds);
        if (cancelled()) {
            UIGraphicsEndImageContext();
            return;
        }
        // delegate发起绘制
        [self.delegate asyncDisplayLayer:self displayingInContext:context cancelled:cancelled];
        if (cancelled()) {
            UIGraphicsEndImageContext();
            return;
        }
        // 获取绘制的图片
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        self.contents = (__bridge id)image.CGImage;
        UIGraphicsEndImageContext();
        // 通知:绘制完毕
        [self.delegate asyncDisplayLayerDidEndDisplay:self];
    }
}

# pragma mark - setter

- (void)setAsynchronized:(BOOL)asynchronized
{
    _asynchronized = asynchronized;
    [self.asyncFlag incrementFlag];
}


# pragma mark - getter
- (JFAsyncFlag *)asyncFlag {
    if (!_asyncFlag) {
        _asyncFlag = [JFAsyncFlag new];
    }
    return _asyncFlag;
}

@end

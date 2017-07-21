//
//  JFAsyncDisplayView.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFAsyncDisplayView.h"
#import "JFAsyncDisplayLayer.h"
#import "JFMacro.h"

@interface JFAsyncDisplayView() <JFAsyncDisplayDelegate>

@end

@implementation JFAsyncDisplayView


# pragma mask 2 JFAsyncDisplayDelegate

- (JFAsyncDisplayCallBacks*) asyncDisplayCallBacks {
    __weak typeof(self) wself = self;
    JFAsyncDisplayCallBacks* callBack = [JFAsyncDisplayCallBacks new];
    // 即将绘制
    callBack.willDisplay = ^(JFAsyncDisplayLayer *layer) {
        layer.contentsScale = JFSCREEN_SCALE;
        if (wself.backgroundColor) {
            layer.backgroundColor = wself.backgroundColor.CGColor;
        }
    };
    // 执行绘制任务
    callBack.display = ^(CGContextRef context, CGSize size, isCanceledBlock isCanceled) {
        __strong typeof(wself) sself = wself;
        for (JFStorage* storage in sself.layout.storages) {
            [storage drawInContext:context isCanceled:isCanceled];
        }
    };
    // 绘制完毕
    callBack.didDisplayed = ^(JFAsyncDisplayLayer *layer, BOOL finished) {
        
    };
    
    return callBack;
}

# pragma mask 3 life cycle

+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}

# pragma mask 4 setter

- (void)setLayout:(JFLayout *)layout {
    if (_layout != layout) {
        _layout = layout;
        // 先绘制可以绘制的
        [self.layer setNeedsDisplay];
    }
}


@end

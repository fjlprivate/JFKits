//
//  JFAsyncDisplayLayer.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JFConstant.h"

@class JFAsyncDisplayLayer;

@protocol JFAsyncDisplayLayerDelegate


/**
 即将开始绘制;
 @param layer 异步绘制layer;
 */
- (void) asyncDisplayLayerWillDisplay:(JFAsyncDisplayLayer*)layer;

/**
 正在绘制;
 @param layer 异步绘制layer;
 @param context 绘制所在上下文;
 @param cancelled 退出绘制的回调;
 */
- (void) asyncDisplayLayer:(JFAsyncDisplayLayer*)layer
       displayingInContext:(CGContextRef)context
                 cancelled:(IsCancelled)cancelled;


/**
 绘制结束了;
 @param layer 异步绘制layer;
 */
- (void) asyncDisplayLayerDidEndDisplay:(JFAsyncDisplayLayer*)layer;


@end


@interface JFAsyncDisplayLayer : CALayer
// 是否异步绘制: YES[异步];NO[同步];
@property (nonatomic, assign) BOOL asynchronized;
// 
@property (nonatomic, weak) id<JFAsyncDisplayLayerDelegate> delegate;

// 取消当前绘制
- (void) cancelDisplaying;

@end

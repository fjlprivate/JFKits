//
//  JFAsyncDisplayLayer.h
//  JFKit
//
//  Created by warmjar on 2017/7/10.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>

// 判断是否退出的block
typedef BOOL (^ isCanceledBlock) ();


@interface JFAsyncDisplayLayer : CALayer
@property (nonatomic, assign) BOOL displayedAsyncchronous;

@end


// 接口类: 提供绘制任务接口;
@interface JFAsyncDisplayCallBacks : NSObject

// 即将开始绘制
@property (nonatomic, copy) void (^ willDisplay) (JFAsyncDisplayLayer* layer);

// 正在绘制
@property (nonatomic, copy) void (^ display) (CGContextRef context, CGSize size, isCanceledBlock isCanceled);

// 绘制结束
@property (nonatomic, copy) void (^ didDisplayed) (JFAsyncDisplayLayer* layer, BOOL finished);


@end



/**
 异步绘制的回调;
 用于在上层UIView中提供绘制任务;
 */
@protocol JFAsyncDisplayDelegate <NSObject>

@required
- (JFAsyncDisplayCallBacks*) asyncDisplayCallBacks;

@end







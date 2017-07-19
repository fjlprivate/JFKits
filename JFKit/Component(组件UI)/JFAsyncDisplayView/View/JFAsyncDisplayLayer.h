//
//  JFAsyncDisplayLayer.h
//  JFKit
//
//  Created by warmjar on 2017/7/10.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>


//typedef BOOL (^IsCanceled)(void); // 退出block


@interface JFAsyncDisplayLayer : CALayer
@property (nonatomic, assign) BOOL displayedAsyncchronous;

@end



@interface JFAsyncDisplayCallBacks : NSObject

@property (nonatomic, copy) void (^ willDisplay) (JFAsyncDisplayLayer* layer);

@property (nonatomic, copy) void (^ display) (CGContextRef context, CGSize size, IsCanceled isCanceled);

@property (nonatomic, copy) void (^ didDisplayed) (JFAsyncDisplayLayer* layer, BOOL finished);


@end




@protocol JFAsyncDisplayDelegate <NSObject>

@required
- (JFAsyncDisplayCallBacks*) asyncDisplayCallBacks;

@end







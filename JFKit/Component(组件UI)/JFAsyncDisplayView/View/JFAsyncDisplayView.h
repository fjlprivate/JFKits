//
//  JFAsyncDisplayView.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFLayout.h"


@class JFAsyncDisplayView;

@protocol JFAsyncDisplayViewDelegate <NSObject>

// 即将开始绘制
- (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView willBeginDrawingInContext:(CGContextRef)context;
// 即将结束绘制
- (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView willEndDrawingInContext:(CGContextRef)context;

@end




@interface JFAsyncDisplayView : UIView

@property (nonatomic, strong) JFLayout* layout; // 混排布局对象;setter中刷新绘制;

@property (nonatomic, weak) id<JFAsyncDisplayViewDelegate> delegate;

@end

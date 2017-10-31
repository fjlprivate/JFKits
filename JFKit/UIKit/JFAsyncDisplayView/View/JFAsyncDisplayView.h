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

/**
 回调: 即将开始绘制;

 @param asyncView 异步绘制视图;
 @param context 绘制所在的上下文;
 */
- (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView willBeginDrawingInContext:(CGContextRef)context;

/**
 回调: 即将结束绘制;

 @param asyncView 异步绘制视图;
 @param context 绘制所在的上下文;
 */
- (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView willEndDrawingInContext:(CGContextRef)context;

/**
 回调: 点击了文本的高亮区;

 @param asyncView 异步绘制视图;
 @param textStorage 点击事件所在的textStorage;
 @param linkData 点击事件对应绑定的数据;
 */
- (void) asyncDisplayView:(JFAsyncDisplayView*)asyncView didClickedTextStorage:(JFTextStorage*)textStorage withLinkData:(id)linkData;


/**
 回调: 点击了图片;

 @param asyncView 异步绘制视图;
 @param imageStorage 点击事件所在的imageStorage;
 */
- (void) asyncDIsplayView:(JFAsyncDisplayView*)asyncView didClickedImageStorage:(JFImageStorage*)imageStorage;


@end




@interface JFAsyncDisplayView : UIView

@property (nonatomic, strong) JFLayout* layout; // 混排布局对象;setter中刷新绘制;

@property (nonatomic, weak) id<JFAsyncDisplayViewDelegate> delegate;

@end

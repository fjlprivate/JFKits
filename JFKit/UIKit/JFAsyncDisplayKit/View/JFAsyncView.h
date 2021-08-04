//
//  JFAsyncView.h
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/18.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFAsyncViewLayouts.h"


@class JFAsyncView;

@protocol JFAsyncViewDelegate <NSObject>
@optional
/**
 点击了文本区;
 如果highlight为空，则点击的是整个textLayout文本区;

 @param asyncView 当前异步加载视图;
 @param textLayout 文本布局对象;
 @param highlight 高亮属性;
 */
- (void) asyncView:(JFAsyncView*)asyncView didClickedAtTextLayout:(JFTextLayout*)textLayout withHighlight:(JFTextAttachmentHighlight*)highlight;


/**
 长按文本区;
 如果highlight为空，则点击的是整个textLayout文本区;
 
 @param asyncView 当前异步加载视图;
 @param textLayout 文本布局对象;
 @param highlight 高亮属性;
 */
- (void) asyncView:(JFAsyncView*)asyncView didLongpressAtTextLayout:(JFTextLayout*)textLayout withHighlight:(JFTextAttachmentHighlight*)highlight;


/**
 长按视图;
 */
- (void) didLongPressAtAsyncView;

/**
 点击了图片区;
 @param asyncView 当前异步加载视图;
 @param imageLayout 图片布局对象;
 */
- (void) asyncView:(JFAsyncView*)asyncView didClickedAtImageLayout:(JFImageLayout*)imageLayout;

// 即将开始布局:setLayouts时
- (void) willRelayoutInAsyncView:(JFAsyncView*)asyncView;
// 布局完毕:setLayouts后
- (void) didRelayoutInAsyncView:(JFAsyncView*)asyncView;


/// 即将开始绘制
/// @param asyncView  当前异步加载视图
/// @param context  当前即将绘制的上下文
/// @param cancelled  退出绘制的回调；在外部绘制时，要不时判断当前绘制是否结束
- (void) asyncView:(JFAsyncView*)asyncView willDrawInContext:(CGContextRef)context cancelled:(IsCancelled)cancelled;

@end


@interface JFAsyncView : UIView

@property (nonatomic, strong) JFAsyncViewLayouts* layouts;

// 是否按填充内容截取宽度;默认:NO
@property (nonatomic, assign) BOOL shouldTruncateWidth;
// 是否按填充内容截取高度;默认:YES
@property (nonatomic, assign) BOOL shouldTruncateHeight;

@property (nonatomic, weak) id<JFAsyncViewDelegate> delegate;

@end

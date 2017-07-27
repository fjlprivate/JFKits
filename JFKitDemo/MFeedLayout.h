//
//  MFeedLayout.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/26.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFKit.h"

#define ChatBubbleTriWidth 10  // 回复背景框三角的宽
#define ChatBubbleTriHeight 5 // 回复背景框三角的高

#define ContentTruncateYES  @"全文" 
#define ContentTruncateNO  @"收起"


@class TMFeedNode;
@interface MFeedLayout : JFLayout

// 使用数据元来初始化layout
+ (instancetype) layoutWithFeedNode:(TMFeedNode*)feedNode contentTruncated:(BOOL)contentTruncated;

// 网页内容的背景边框
@property (nonatomic, assign, readonly) CGRect webFrame;
@property (nonatomic, strong, readonly) UIColor* webBackColor;

// 评论的背景边框
@property (nonatomic, assign, readonly) CGRect commentFrame;
@property (nonatomic, strong, readonly) UIColor* commentBackColor;

// 点评分割线属性
@property (nonatomic, assign, readonly) CGPoint seperateLineStartP; // 分割线起点坐标
@property (nonatomic, assign, readonly) CGPoint seperateLineEndP; // 分割线终点坐标
@property (nonatomic, assign, readonly) CGFloat seperateLineWidth; // 分割线宽度
@property (nonatomic, strong, readonly) UIColor* seperateLineColor;

@property (nonatomic, assign, readonly) CGFloat cellHeight;


@property (nonatomic, assign, readonly) BOOL isContentTruncated; // 正文是否被折叠

@end

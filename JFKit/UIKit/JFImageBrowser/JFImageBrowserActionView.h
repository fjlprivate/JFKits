//
//  JFImageBrowserActionView.h
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const JFImageBrowserNavigationHeight = 44.f;     // 导航栏高
static CGFloat const JFImageBrowserActionCellHeight = 54.f;     // 操作栏cell高
static CGFloat const JFImageBrowserActionHeaderHeight = 6.f;    // 操作栏间隔行高

@class JFImageBrowserHandler;

@interface JFImageBrowserActionView : UIView
- (instancetype) initWithFrame:(CGRect)frame items:(NSArray<JFImageBrowserHandler*>*)items;
- (void) showActionSheet;
- (void) hideActionSheet;
@property (nonatomic, copy) void (^ didSelectWithItem) (JFImageBrowserHandler* item);
@property (nonatomic, assign, readonly) BOOL isShown;
@end

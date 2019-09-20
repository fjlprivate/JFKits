//
//  JFLabel.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFTextLayout;
@class JFLabel;
@class JFTextAttachmentHighlight;

@protocol JFLabelDelegate <NSObject>

/**
 点击了文本区;
 如果highlight为空，则点击的是整个textLayout文本区;
 @param label 文本控件;
 @param highlight 高亮属性;
 */
- (void) label:(JFLabel*)label didClickedTextAtHighlight:(JFTextAttachmentHighlight*)highlight;


/**
 长按了文本区;
 如果highlight为空，则点击的是整个textLayout文本区;

 @param label 文本控件;
 @param highlight 高亮属性;
 */
- (void) label:(JFLabel*)label didLongPressAtHighlight:(JFTextAttachmentHighlight*)highlight;

@end

@interface JFLabel : UIView

// 是否异步绘制: YES[异步];NO[同步];
@property (nonatomic, assign) BOOL asynchronized;
// setter引发重绘
@property (nonatomic, strong) JFTextLayout* textLayout;

@property (nonatomic, weak) id<JFLabelDelegate> delegate;

@end

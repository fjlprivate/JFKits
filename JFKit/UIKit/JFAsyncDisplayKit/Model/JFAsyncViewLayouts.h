//
//  JFAsyncViewLayouts.h
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/18.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFTextLayout.h"
#import "JFImageLayout.h"

@interface JFAsyncViewLayouts : NSObject

/**
 布局视图的frame;
 根据需求手动设置;
 */
@property (nonatomic, assign) CGRect viewFrame;

# pragma mark - 高亮相关
// 被高亮的高亮属性和它相关的textLayout
@property (nonatomic, weak) JFTextLayout* highlightedTextLayout;
@property (nonatomic, weak) JFTextAttachmentHighlight* selectedHighlight;

// 点亮指定坐标point的高亮;点亮成功返回:JFTextAttachmentHighlight;否则返回:nil;
- (JFTextAttachmentHighlight*) raiseHighlightAtPoint:(CGPoint)point;
// 恢复被点亮的高亮
- (void) resetHighlightWhichRaised;


# pragma mark - ** 必须使用下面的n个方法来[增、减、更新]layout
- (void) addLayout:(JFLayout*)layout;
- (void) removeLayout:(JFLayout*)layout;
- (void) removeAllLayouts;
- (void) replaceLayout:(JFLayout*)layout atIndex:(NSInteger)index;

- (NSInteger) indexForLayout:(JFLayout*)layout;
@property (nonatomic, strong) NSMutableArray<JFLayout*>* layouts;


@end

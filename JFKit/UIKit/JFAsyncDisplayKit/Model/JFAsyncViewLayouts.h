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


/**
 所有layouts内容的尺寸，包括间距;
 自动设置;
 */
@property (nonatomic, assign) CGSize contentSize;

# pragma mark - ** 必须使用下面的n个方法来[增、减、更新]layout
- (void) addLayout:(JFLayout*)layout;
- (void) removeLayout:(JFLayout*)layout;
- (void) removeAllLayouts;
- (void) replaceLayout:(JFLayout*)layout atIndex:(NSInteger)index;

- (NSInteger) indexForLayout:(JFLayout*)layout;
@property (nonatomic, strong) NSMutableArray<JFLayout*>* layouts;


@end

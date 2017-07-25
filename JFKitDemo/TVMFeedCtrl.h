//
//  TVMFeedCtrl.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMFeedNode.h"

@class JFLayout;
@interface TVMFeedCtrl : NSObject

// 提供数据获取接口
- (void) requestFeedDataOnFinished:(void (^) (void))finishedBlock
                           orError:(void (^) (NSError* error))errorBlock;


// 数据节点个数
- (NSInteger) numberOfFeedNodes;

// 获取指定序号的布局属性
- (JFLayout*) layoutAtIndex:(NSInteger)index;


@end

//
//  TMFeedNode.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TMFeedNode.h"
#import "MJExtension.h"

@implementation TMFeedNode

- (void)setCommentList:(NSArray<TMFeedCommentNode *> *)commentList {
    if (commentList && commentList.count > 0) {
        _commentList = [TMFeedCommentNode mj_objectArrayWithKeyValuesArray:commentList];
    }
}


@end

@implementation TMFeedCommentNode



@end

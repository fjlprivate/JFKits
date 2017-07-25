//
//  TMFeedNode.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>

// 回复节点
@interface TMFeedCommentNode : NSObject
@property (nonatomic, strong) NSString* from; // 谁回复的
@property (nonatomic, strong) NSString* to; // 回复给谁的
@property (nonatomic, strong) NSString* content; // 回复的内容
@end

@interface TMFeedNode : NSObject

@property (nonatomic, strong) NSString* type; // 类型
@property (nonatomic, strong) NSString* name; // 姓名
@property (nonatomic, strong) NSString* avatar; // 头像url
@property (nonatomic, strong) NSString* content; // 发布的内容，最多5行
@property (nonatomic, strong) NSString* date; // 发布日期时间
@property (nonatomic, strong) NSString* detail; // 当type ==website时显示的内容,最多3行
@property (nonatomic, strong) NSArray<NSString*>* imgs; // 发布的图片
@property (nonatomic, strong) NSArray<NSString*>* thumbnail; // 发布图片的缩略图
@property (nonatomic, strong) NSString* statusID; //
@property (nonatomic, strong) NSArray<TMFeedCommentNode*>* commentList; // 回复列表
@property (nonatomic, strong) NSNumber* isLike; // 是否点赞
@property (nonatomic, strong) NSArray<NSString*>* likeList; // 点赞用户列表


@end

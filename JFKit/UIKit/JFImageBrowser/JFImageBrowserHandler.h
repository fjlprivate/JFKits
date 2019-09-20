//
//  JFImageBrowserHandler.h
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JFIBHandlerType) {
    JFIBHandlerTypeCancel,
    JFIBHandlerTypeDefault
};

@interface JFImageBrowserHandler : NSObject
+ (instancetype) jf_handlerWithTitle:(NSString*)title
                                type:(JFIBHandlerType)type
                              handle:(void (^) (NSInteger index))handleBlock;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) void (^ handleBlock) (NSInteger index);
@property (nonatomic, assign) JFIBHandlerType type;

@end

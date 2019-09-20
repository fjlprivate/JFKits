//
//  JFImageBrowserHandler.m
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFImageBrowserHandler.h"

@implementation JFImageBrowserHandler

+ (instancetype) jf_handlerWithTitle:(NSString*)title
                                type:(JFIBHandlerType)type
                              handle:(void (^) (NSInteger index))handleBlock
{
    JFImageBrowserHandler* model = [JFImageBrowserHandler new];
    model.title = title;
    model.type = type;
    model.handleBlock = handleBlock;
    return model;
}

@end

//
//  JFImageBrowserItem.m
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFImageBrowserItem.h"

@implementation JFImageBrowserItem


/**
 构建多媒体对象
 @param mediaType                   多媒体类型
 @param thumbnail                   缩略图
 @param mediaDisplaying             显示图(展示图,比缩略图清晰;如不传,则用mediaOrigin来展示)
 @param mediaOrigin                 原始图|视频路径;(如果是图片,则用来展示|下载)
 @param originFrame                 原始位置(在UIScreen中)
 @param cornerRadius                圆角(原始状态,动画会缩放成矩形)
 @param mediaSize                   尺寸(可以是等比缩放尺寸,用于计算)
 @param originContentMode           填充模式(图片用的字段)
 @return 多媒体对象
 */
+ (instancetype) jf_itemWithMediaType:(JFMediaType)mediaType
                            thumbnail:(id)thumbnail
                      mediaDisplaying:(id)mediaDisplaying
                          mediaOrigin:(id)mediaOrigin
                          originFrame:(CGRect)originFrame
                         cornerRadius:(CGFloat)cornerRadius
                            mediaSize:(CGSize)mediaSize
                    originContentMode:(UIViewContentMode)originContentMode
{
    JFImageBrowserItem* item = [JFImageBrowserItem new];
    item.mediaType = mediaType;
    item.thumbnail = thumbnail;
    item.mediaDisplaying = mediaDisplaying;
    item.mediaOrigin = mediaOrigin;
    item.originFrame = originFrame;
    item.cornerRadius = cornerRadius;
    item.mediaSize = mediaSize;
    item.originContentMode = originContentMode;
    return item;
}


@end

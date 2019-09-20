//
//  JFImageBrowserItem.h
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

// 多媒体类型
typedef NS_ENUM(NSInteger, JFMediaType) {
    JFMediaTypeNormalImage          = 1,            // 普通图片
    JFMediaTypeGifImage             = 2,            // GIF图片
    JFMediaTypeVideo                = 3             // 视频
};

@interface JFImageBrowserItem : NSObject

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
                    originContentMode:(UIViewContentMode)originContentMode;

// 多媒体类型
@property (nonatomic, assign) JFMediaType mediaType;

// 缩略图:缩略图<UIImage|NSURL>;用于加载时的动画
@property (nonatomic, copy) id thumbnail;
// 显示图:<UIImage|NSURL>;比缩略图清晰;如不传,则用mediaOrigin来展示
@property (nonatomic, copy) id mediaDisplaying;
// 原始图|视频路径:<UIImage|NSURL>;如果是图片,则用来展示|下载
@property (nonatomic, copy) id mediaOrigin;

// 原始位置:<UIScreen坐标系>
@property (nonatomic, assign) CGRect originFrame;
// 圆角(原始状态,动画会缩放成矩形)
@property (nonatomic, assign) CGFloat cornerRadius;
// 图片尺寸;用于计算全屏时的frame;可以是等比缩放的尺寸;
@property (nonatomic, assign) CGSize mediaSize;

// 填充模式(图片用的字段);加载完毕的图片统一用AspectFill模式
@property (nonatomic, assign) UIViewContentMode originContentMode;

@end

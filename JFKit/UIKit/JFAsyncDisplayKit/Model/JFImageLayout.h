//
//  JFImageLayout.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFLayout.h"

@interface JFImageLayout : JFLayout
/**
 图片内容;
 UIImage|NSURL|NSString
 */
@property (nonatomic, strong) id image;


/**
 图片内容的布局类型
 */
@property (nonatomic, assign) UIViewContentMode contentMode;

/**
 图片的实际尺寸;不是imageView的尺寸;
 */
@property (nonatomic, assign) CGSize imageSize;

/**
 占位图片;
 UIImage*
 */
@property (nonatomic, strong) UIImage* placeHolder;


/**
 内容url链接:NSString|NSURL|NSData
 可以是视频、图片、网页等都行
 */
@property (nonatomic, strong) id contentURL;

@end

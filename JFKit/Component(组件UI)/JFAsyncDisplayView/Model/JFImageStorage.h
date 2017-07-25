//
//  JFImageStorage.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFStorage.h"



@interface JFImageStorage : JFStorage

+ (instancetype) jf_imageStroageWithContents:(id)contents frame:(CGRect)frame;

@property (nonatomic, strong, readonly) id contents; // 图片内容; UIImage or NSURL

@property (nonatomic, strong) UIImage* placeHolder; // 占用图

@property (nonatomic, assign) UIViewContentMode contentMode; // 图片布局类型;默认:UIViewContentModeScaleAspectFit;

@property (nonatomic, strong) UIColor* backgroundColor; // 背景色

@property (nonatomic, assign) CGSize cornerRadius; // 圆角值

@property (nonatomic, assign) CGFloat borderWidth; // 边框宽度

@property (nonatomic, strong) UIColor* borderColor; // 边框颜色


@end

//
//  JFImageStorage.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFStorage.h"

// 判断是否退出的block
typedef BOOL (^ isCanceledBlock) ();


@interface JFImageStorage : JFStorage

+ (instancetype) jf_imageStroageWithContents:(id)contents frame:(CGRect)frame;

@property (nonatomic, strong) id contents; // 图片内容; UIImage or NSURL


/**
 图片布局类型;默认:UIViewContentModeScaleAspectFit;
 UIViewContentModeScaleAspectFill同UIViewContentModeScaleAspectFit效果一样;
 */
@property (nonatomic, assign) UIViewContentMode contentMode;

@property (nonatomic, strong) UIColor* backgroundColor; // 背景色


@property (nonatomic, assign) CGSize cornerRadius; // 圆角值

@property (nonatomic, assign) CGFloat borderWidth; // 边框宽度
@property (nonatomic, strong) UIColor* borderColor; // 边框颜色


/**
 绘制图片到图形上下文;
 只有当contents是UIImage类型时才允许绘制;

 @param context 图形上下文;
 @param canceled 是否取消绘制的校验方法;
 */
- (void) drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled;

@end

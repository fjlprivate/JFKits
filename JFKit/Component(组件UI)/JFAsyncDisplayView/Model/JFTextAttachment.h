//
//  JFTextAttachment.h
//  JFKitDemo
//
//  Created by johnny feng on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const JFTextAttachmentName         = @"JFTextAttachmentName";
static NSString* const JFTextBackgroundColorName    = @"JFTextBackgroundColorName";
static NSString* const JFTextHighLightName          = @"JFTextHighLightName";


/**
 图片附件
 */
@interface JFTextAttachment : NSObject

@property (nonatomic, strong) id contents; // UIImage or NSURL
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) CGSize contentSize; // 附件尺寸
@property (nonatomic, assign) CGRect frame;

@end

/**
 背景色属性
 */
@interface JFTextBackgoundColor : NSObject

@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSArray<NSValue*>* positions; // CGRect in NSValue,可以有多个背景色块,每个对应一个CTRunRef

@end



/**
 高亮属性(点击事件)
 */
@interface JFTextHighLight : NSObject

@property (nonatomic, assign) BOOL showHighLight; // 是否显示高亮
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) UIColor* textSelectedColor; // 文本高亮色
@property (nonatomic, strong) UIColor* backSelectedColor; // 文本背景色
@property (nonatomic, strong) id content; // 链接数据
@property (nonatomic, strong) NSArray<NSValue*>* positions; // CGRect in NSValue,可以有多个背景色块,每个对应一个CTRunRef

@end



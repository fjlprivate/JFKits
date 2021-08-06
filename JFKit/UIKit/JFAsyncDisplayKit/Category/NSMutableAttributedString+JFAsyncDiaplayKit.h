//
//  NSMutableAttributedString+JFAsyncDiaplayKit.h
//  JFKitDemo
//
//  Created by fjl on 2021/8/6.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (JFAsyncDiaplayKit)

/**
 设置附件:高亮;
 实际就是对指定range的文本添加背景色;在指定的时机显示;
 所以用set而不是add;
 @param highlight 高亮附件;
 */
- (void) jf_setHighlight:(JFTextAttachmentHighlight*)highlight;


/**
 添加附件:图片;
 因为图片要插入到attributedString,会使range变动;
 **注意!注意!注意!:**所以要在其他属性设置前，添加图片;
 @param image 图片附件;
 */
- (void) jf_addImage:(JFTextAttachmentImage*)image;

@end

NS_ASSUME_NONNULL_END

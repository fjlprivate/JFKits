//
//  JFTextAttachment.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


// 高亮属性的key
static NSString* const JFTextAttachmentHighlightName = @"JFTextAttachmentHighlightName";
// 图片属性的key
static NSString* const JFTextAttachmentImageName = @"JFTextAttachmentImageName";



# pragma mark - 图片附件

@interface JFTextAttachmentImage : NSObject
// 图片属性在文本中的位置
@property (nonatomic, assign) NSInteger index;
/**
 图片数据;分如下3种;
 NSString:本地图片名;
 UIImage:图片;
 NSURL:网络图片url;
 */
@property (nonatomic, copy) id image;
// 字间距
@property (nonatomic, assign) CGFloat kern;
// 图片在文本中的尺寸
@property (nonatomic, assign) CGSize imageSize;
// 图片在view中的frame
@property (nonatomic, assign) CGRect uiFrame;
// 图片在<CoreText>中的frame
@property (nonatomic, assign) CGRect ctFrame;
// 背景色
@property (nonatomic, copy) UIColor* backgroundColor;
// 圆角
@property (nonatomic, assign) CGSize cornerRadius;
@end



# pragma mark - 高亮附件

@interface JFTextAttachmentHighlight : NSObject
// 是否高亮
@property (nonatomic, assign) BOOL isHighlight;
// 高亮属性在文本中的区间
@property (nonatomic, assign) NSRange range;
// 正常时文本色
@property (nonatomic, copy) UIColor* normalTextColor;
// 高亮时文本色
@property (nonatomic, copy) UIColor* highlightTextColor;
// 正常时背景色
@property (nonatomic, copy) UIColor* normalBackgroundColor;
// 高亮时背景色
@property (nonatomic, copy) UIColor* highlightBackgroundColor;
/**
 高亮属性绑定的数据;
 一般为NSString,用于点击到高亮时,用于识别要处理的数据;
 */
@property (nonatomic, copy) id linkData;
// 高亮属性在view中的frame
@property (nonatomic, strong) NSMutableArray* uiFrames;
@end



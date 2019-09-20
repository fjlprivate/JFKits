//
//  NSString+Extension.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JFImageStringName) {
    JFImageStringNameImage,         // 图片
    JFImageStringNameGif,           // 动图
    JFImageStringNameMP4,           // 视频
    JFImageStringNameUnkown         // 不识别
};

@interface NSString (Extension)

/**
 计算文本区域size;
 @param width 给定宽度;
 @param font 字体;
 @return size;
 */
- (CGSize) sizeWithWidth:(CGFloat)width
                    font:(UIFont*)font;


// 识别当前字符串url属于什么媒体类型
- (JFImageStringName) imageType;



/**
 汉字 -> 拼音;
 @return 拼音;不带音标;大写;
 */
- (NSString*) jf_pinyin;


/**
 将指定区间的字母替换为*
 @param range 指定区间
 @return 替换后的
 */
- (NSString*) jf_transferXingAtRange:(NSRange)range;

// base64编码
- (NSString*) jf_base64Coding;
// base64解码
- (NSString*) jf_base64Decoding;



@end

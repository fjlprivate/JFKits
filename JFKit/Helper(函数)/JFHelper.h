//
//  JFHelper.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 十六进制颜色

 @param hexColor 十六进制值,如：0x00a1dc(支付宝蓝色)
 @param alpha alpha值通道, 0.f~1.f
 @return RGB颜色对象
 */
static inline UIColor* JFHexColor(NSInteger hexColor, CGFloat alpha) {
    return [UIColor colorWithRed:(CGFloat)((hexColor & 0xff0000) >> (8 * 2))/(CGFloat)0xff
                           green:(CGFloat)((hexColor & 0x00ff00) >> (8 * 1))/(CGFloat)0xff
                            blue:(CGFloat)((hexColor & 0x0000ff) >> (8 * 0))/(CGFloat)0xff
                           alpha:alpha];
}




/**
 生成字体大小，用于生成UIFont;
 按系统标准字体，根据指定的文本高度的比例，来计算最终的字体大小；

 @param height 指定文本高度
 @param scale 文本实际高度占比
 @return 字体大小值(systemFontSize)
 */
static inline CGFloat JFFontSizeWithHeight(CGFloat height, CGFloat scale) {
    NSString* text = @"text";
    CGFloat fontSize = 14;
    CGRect textBounds = [text boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:NULL];
    return height * scale  * fontSize / textBounds.size.height;
}



/**
 计算文本指定字体的文本区域大小

 @param text 文本
 @param font 字体
 @return 文本尺寸
 */
static inline CGSize JFTextSizeInFont(NSString* text, UIFont* font) {
    return [text boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:NULL].size;
}



@interface JFHelper : NSObject




@end

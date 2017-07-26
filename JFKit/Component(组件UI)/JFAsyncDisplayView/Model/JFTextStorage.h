//
//  JFTextStorage.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFStorage.h"


/**
 * [文本缓存类]
 *
 * 缓存文本，以及文本属性，还有高亮属性:
 */

@interface JFTextStorage : JFStorage


/**
 生成textStorage

 @param text 文本
 @param frame 文本frame
 @param insets 四边内嵌距离
 @return textStorage

 */
+ (instancetype) jf_textStorageWithText:(NSString*)text frame:(CGRect)frame insets:(UIEdgeInsets)insets;

@property (nonatomic, strong, readonly) NSMutableAttributedString* attributedString; // 富文本

@property (nonatomic, strong) UIFont* textFont; // 字体
@property (nonatomic, strong) UIColor* textColor; // 文本色

@property (nonatomic, strong) UIColor* backgroundColor; // 背景色

@property (nonatomic, assign) NSInteger numberOfLines; // 文本行数

@property (nonatomic, assign, readonly) BOOL isTrancated; // 被截取行数

// 字间距、行间距、对齐
@property (nonatomic, assign) CGFloat lineSpace; // 行间距
@property (nonatomic, assign) CGFloat kernSpace; // 字间距


// 调试模式
@property (nonatomic, assign) BOOL debugMode; // 是否开启调试模式



# pragma mask : 设置属性方法


/**
 设置[字体]到文本的指定位置;

 @param textFont 字体;
 @param range 指定的区间;
 */
- (void) setTextFont:(UIFont *)textFont atRange:(NSRange)range;

/**
 设置[字颜色]到文本的指定位置;
 
 @param textColor 字颜色;
 @param range 指定的区间;
 */
- (void) setTextColor:(UIColor *)textColor atRange:(NSRange)range;

/**
 插入[图片]到指定的位置;
 如果指定的位置已经有图片了，则替换掉原来的图片;
 
 @param image 图片;
 @param imageSize 图片大小;
 @param position 指定的位置;
 */
- (void) setImage:(UIImage*)image imageSize:(CGSize)imageSize atPosition:(NSInteger)position;

- (void) replaceTextAtRange:(NSRange)range withImage:(UIImage*)image imageSize:(CGSize)imageSize;

/**
 设置[背景色]到指定的区间;

 @param backgroundColor 背景色;
 @param range 指定区间;
 */
- (void) setBackgroundColor:(UIColor*)backgroundColor atRange:(NSRange)range;


/**
 添加[点击事件];
 指定区间和高亮颜色;
 绑定关联数据;

 @param data 关联数据: 比如，网址、电话号码等;在点击事件中，处理关联的数据;
 @param textSelectedColor 点击时的文本高亮色;
 @param backSelectedColor 点击时的文本背景色;
 @param range 指定区间;
 */
- (void) addLinkWithData:(id)data
       textSelectedColor:(UIColor*)textSelectedColor
       backSelectedColor:(UIColor*)backSelectedColor
                 atRange:(NSRange)range;


# pragma mask : 校验和开关方法


/**
 判断是否点击了高亮区;
 逐个比较当前缓存中的所有高亮区;

 @param position 点击坐标
 @return 存在任意一个高亮区，则返回YES;否则返回NO;
 */
- (BOOL) didClickedHighLightPosition:(CGPoint)position;



/**
 更新高亮区的显示开关;
 在执行这个方法前，最好先执行上面的判断;

 @param switchOn 高亮开关;
 @param position 高亮区所在的坐标;
 */
- (void) turnningHightLightSwitch:(BOOL)switchOn atPosition:(CGPoint)position;



@end

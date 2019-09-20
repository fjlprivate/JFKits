//
//  UIButton+JFExtension.h
//  JFButtonDemo
//
//  Created by johnny feng on 2017/9/2.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>

# pragma mark -- 图文排版支持


/**
 图文排版类型;

 - JFButtonTypeNormal: 默认的左图右文排版;
 */
typedef NS_ENUM(NSInteger, JFButtonType) {
    JFButtonTypeNormal,                 // 左图右文
    JFButtonTypeTitleLeftImageRight,    // 左文右图
    JFButtonTypeTitleDownImageUp,       // 上图下文
    JFButtonTypeTitleUpImageDown       // 上文下图
};


/**
 方位类型;

 - JFButtonAlignmentNormal: 默认的中心位置;
 */
typedef NS_ENUM(NSInteger, JFButtonAlignment) {
    JFButtonAlignmentNormal,            // 中心
    JFButtonAlignmentLeft,              // 左边
    JFButtonAlignmentRight,             // 右边
    JFButtonAlignmentTop,               // 上边
    JFButtonAlignmentBottom,            // 下边
    JFButtonAlignmentTopLeft,           // 左上
    JFButtonAlignmentTopRight,          // 右上
    JFButtonAlignmentBottomLeft,        // 左下
    JFButtonAlignmentBottomRight        // 右下
};


@interface UIButton (JFExtension)


/**
 初始化按钮，以指定的排版方式排版;

 @param title       标题(normal);
 @param image       图片(normal);
 @param font        标题字体;
 @param type        图文排版类型;
 @param alignment   方位类型;
 @param padding     图片跟标题的间隔;
 @return            初始化后的按钮;
 */
- (instancetype) initWithTitle:(NSString*)title
                         image:(UIImage*)image
                          font:(UIFont*)font
                          type:(JFButtonType)type
                     alignment:(JFButtonAlignment)alignment
                       padding:(CGFloat)padding;

- (void) jf_setType:(JFButtonType)type;
- (void) jf_setAlignment:(JFButtonAlignment)alignment;
- (void) jf_setPadding:(CGFloat)padding;


/**
 更新布局;
 */
- (void) updateContentsLayout;


@end

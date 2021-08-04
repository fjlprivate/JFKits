//
//  JFToast.h
//  JFTools
//
//  Created by 冯金龙 on 2021/5/11.
//  Copyright © 2021 冯金龙. All rights reserved.
//


#import "JFPresenter.h"
#import "NSString+FontAwesome.h"

NS_ASSUME_NONNULL_BEGIN

// toast类型
typedef NS_ENUM(NSInteger, JFToastStyle) {
    JFToastStyleActivity,           // 仅指示器
    JFToastStyleText,               // 仅文字
    JFToastStyleImage,              // 仅图片
    JFToastStyleActivityText,       // 指示器+文字
    JFToastStyleImageText,          // 图片+文字
};


@interface JFToast : JFPresenter

/// 等待：指示器+文字；需要主动hide；
/// @param text  没有文字时，只显示指示器；
+ (instancetype) waitingWithText:(nullable NSString*)text;

/// 仅显示文字；2s后消失
+ (instancetype) toastWithText:(NSString*)text;
/// 仅显示文字；
/// @param text  【必须】要显示的文字
/// @param secs  几秒后消失；0时不消失；需要主动hide
+ (instancetype) toastWithText:(NSString*)text hideAfterSecs:(NSTimeInterval)secs;

/// 仅显示图片；2s后消失
+ (instancetype) toastWithImage:(UIImage*)image;
/// 仅显示图片
/// @param image  【必须】要显示的图片
/// @param secs  几秒后消失；0时不消失；需要主动hide
+ (instancetype) toastWithImage:(UIImage*)image hideAfterSecs:(NSTimeInterval)secs;


/// 显示图片+文字
/// @param image 【必须】图片
/// @param text  【必须】文字
/// @param secs 几秒后消失；0时不消失；需要主动hide
+ (instancetype) toastWithImage:(UIImage*)image text:(NSString*)text hideAfterSecs:(NSTimeInterval)secs;


/// 创建并加载toast
/// @param style  toast类型
/// @param text  文字
/// @param image  图片
/// @param view  加载在哪个视图;nil则为window
+ (instancetype) tostWithStyle:(JFToastStyle)style text:(nullable NSString*)text image:(nullable UIImage*)image inView:(nullable UIView*)view;



// -- 属性设置

// 内容背景色;默认:220,220,220,0.99
@property (nonatomic, strong) UIColor* contBgColor;
// 内容圆角;默认:8
@property (nonatomic, assign) CGFloat contCornerRadius;

// 指示器值;默认:FASpinner
@property (nonatomic, assign) FAIcon indicator;
// 是否开启指示器动画;默认:YES
@property (nonatomic, assign) BOOL shouldIndicatorAnimation;
// 指示器大小;默认:28
@property (nonatomic, assign) CGFloat indicatorSize;
// 指示器颜色;默认:黑色
@property (nonatomic, strong) UIColor* indicatorColor;

// 字体大小;默认:PingFangSC-Medium,16
@property (nonatomic, strong) UIFont* textFont;
// 文字颜色;默认:黑色
@property (nonatomic, strong) UIColor* textColor;
// 文字布局;默认:居中
@property (nonatomic, strong) NSTextAttachment* textAlignment;
// 文字行间距;默认:4
@property (nonatomic, assign) CGFloat lineSpacing;

// 图标尺寸;默认:54
@property (nonatomic, assign) CGFloat imgHeight; // 宽度自适应
// 上边距;默认:15
@property (nonatomic, assign) CGFloat gapTop;
// 下边距;默认:15
@property (nonatomic, assign) CGFloat gapBottom;
// 左边距;默认:20
@property (nonatomic, assign) CGFloat gapLeft;
// 右边距;默认:20
@property (nonatomic, assign) CGFloat gapRight;
// 图标-文字边距;默认:10
@property (nonatomic, assign) CGFloat gapImg2Title;

@end

NS_ASSUME_NONNULL_END

//
//  JFAlertView.h
//  AntPocket
//
//  Created by JohhnyFeng on 2020/5/15.
//  Copyright © 2020 AntPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


// 按钮分隔样式
typedef NS_ENUM(NSInteger, JFAlertButtonSeperatorStyle) {
    JFAlertButtonSeperatorStyleLine,            // 分割线分割
    JFAlertButtonSeperatorStyleSpace            // 空白分隔,使用默认的间距
};



@interface JFAlertView : UIView

/// 创建JFAlertView
/// @param title 标题
/// @param detail 详情文本
/// @param image 图标
+ (instancetype) alertWithTitle:(nullable NSString*)title detail:(nullable NSString*)detail image:(nullable UIImage*)image;

/// 添加按钮
/// @param title 按钮标题
/// @param textColor [可选]文本颜色
/// @param textFont [可选]文本字体
/// @param bgColor [可选]按钮背景色
/// @param action 按钮事件；
- (void) addButtonWithTitle:(NSString*)title
                  textColor:(nullable UIColor*)textColor
                   textFont:(nullable UIFont*)textFont
                    bgColor:(nullable UIColor*)bgColor
                     action:(void (^) (void))action;

// 显示
- (void) show;
// 隐藏
- (void) hide;


# pragma mark - 属性集

// 标题文本标签；默认:textColor:0x333333, font:PingFangSC-Semibold 18
@property (nonatomic, strong) UILabel* labTitle;
// 标题文本标签；默认:textColor:0x444444, font:PingFangSC-Regular 16
@property (nonatomic, strong) UILabel* labDetail;

// 图标
@property (nonatomic, strong) UIImage* image;
// 图标size(高);默认:30
@property (nonatomic, assign) CGFloat imageSize;

// 自定义视图;如果不为空，则会加载自定义视图，而忽略默认的所有设置;
@property (nonatomic, strong) UIView* customView;

// 圆角值;默认:14
@property (nonatomic, assign) CGFloat cornerRadius;

// 背景色;默认:#14161A, alpha:0.4
@property (nonatomic, strong) UIColor* bgColor;
// 内容的背景色;默认:白色
@property (nonatomic, strong) UIColor* contentBgColor;

// 间距:大; 默认:20
@property (nonatomic, assign) CGFloat fGapL;
// 间距:中; 默认:10
@property (nonatomic, assign) CGFloat fGapM;
// 间距:小; 默认:5
@property (nonatomic, assign) CGFloat fGapS;

// 按钮高度;默认:44
@property (nonatomic, assign) CGFloat btnHeight;

// 按钮分隔样式;默认:JFAlertButtonSeperatorStyleLine
@property (nonatomic, assign) JFAlertButtonSeperatorStyle btnSeperatorStyle;
// 按钮分隔间距;默认:15; btnSeperatorStyle == JFAlertButtonSeperatorStyleSpace 有效;
@property (nonatomic, assign) CGFloat btnSeperatorInsetH;
// 按钮分隔间距;默认:10; btnSeperatorStyle == JFAlertButtonSeperatorStyleSpace 有效;
@property (nonatomic, assign) CGFloat btnSeperatorInsetV;
// 按钮圆角值;默认:5; btnSeperatorStyle == JFAlertButtonSeperatorStyleSpace 有效;
@property (nonatomic, assign) CGFloat btnCornerRadius;

// 点击content外部区域时隐藏；默认:NO
@property (nonatomic, assign) BOOL hiddenOnClickedOutSpace;

@end

NS_ASSUME_NONNULL_END

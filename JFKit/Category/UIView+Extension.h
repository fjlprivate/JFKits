//
//  UIView+Extension.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)


# pragma mask ---- 坐标系相关

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

# pragma mark - 根据类名查询子视图
- (UIView*) jf_subviewForClassName:(NSString*)className;

# pragma mark - 设置阴影
/**
 @param shadowWidth         阴影边宽
 @param shadowColor         阴影颜色
 @param cornerRadius        圆角值
 */
- (void) jf_setAroundShadowWidth:(CGFloat)shadowWidth
                     shadowColor:(UIColor*)shadowColor
                    cornerRadius:(CGFloat)cornerRadius;

# pragma mark - 视图转图片
/**
 @return 转换的图片
 */
- (UIImage*) jf_convertViewToImage;

@end

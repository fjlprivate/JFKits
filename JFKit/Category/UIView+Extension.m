//
//  UIView+Extension.m
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "UIView+Extension.h"
#import "JFHelper.h"

@implementation UIView (Extension)



# pragma mask ---- 坐标系相关


- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.size.height = bottom - frame.origin.y;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.size.width = right - frame.origin.x;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width * 0.5;
}
- (void)setCenterX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)centerY {
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height * 0.5;
}
- (void)setCenterY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height * 0.5;
    self.frame = frame;
}


# pragma mark - 根据类名查询子视图
- (UIView*) jf_subviewForClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView jf_subviewForClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

# pragma mark - 设置阴影
/**
 @param shadowWidth         阴影边宽
 @param shadowColor         阴影颜色
 @param cornerRadius        圆角值
 */
- (void) jf_setAroundShadowWidth:(CGFloat)shadowWidth
                     shadowColor:(UIColor*)shadowColor
                    cornerRadius:(CGFloat)cornerRadius
{
    if (shadowWidth < 0.01) {
        return;
    }
    if (shadowColor) {
        shadowColor = [UIColor grayColor];
    }
    CGPathRef shadowPath = nil;
    if (cornerRadius > 0) {
        CAShapeLayer* maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath;
        self.layer.mask = maskLayer;
        shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, -shadowWidth * 0.5, -shadowWidth * 0.5) cornerRadius:cornerRadius].CGPath;
    } else {
        shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -shadowWidth * 0.5, -shadowWidth * 0.5)].CGPath;
    }
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = shadowWidth;
    self.layer.shadowPath = shadowPath;
}


# pragma mark - 视图转图片
/**
 @return 转换的图片
 */
- (UIImage*) jf_convertViewToImage {
    CGSize s = self.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

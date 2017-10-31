//
//  UIButton+JFExtension.m
//  JFButtonDemo
//
//  Created by johnny feng on 2017/9/2.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "UIButton+JFExtension.h"

@implementation UIButton (JFExtension)

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                         font:(UIFont*)font
                         type:(JFButtonType)type
                    alignment:(JFButtonAlignment)alignment
                      padding:(CGFloat)padding
{
    self = [super init];
    if (self) {
        if (title && title.length > 0 && image) {
            [self setTitle:title forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateNormal];
            self.titleLabel.font = font ? font : [UIFont systemFontOfSize:14];
            
            CGFloat widthTitle = self.titleLabel.intrinsicContentSize.width;
            CGFloat widthImage = image.size.width;
            CGFloat heightTitle = self.titleLabel.intrinsicContentSize.height;
            CGFloat heightImage = image.size.height;
            
            /* origin
                * image
                    L: x
                    R: title + x
                * title
                    L: x + image
                    R: x
             */
            
            // 中心 + 左图右文
            if (alignment == JFButtonAlignmentNormal && type == JFButtonTypeNormal) {
                /* title
                    L: image + x - padding / 2 + padding
                    R: x - padding / 2
                 * image
                    L: x - padding/2
                    R: title + x - padding/2 + padding
                 */
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding / 2.f, 0, - padding / 2.f);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, - padding / 2.f, 0, padding / 2.f);
            }
            // 中心 + 左文右图
            else if (alignment == JFButtonAlignmentNormal && type == JFButtonTypeTitleLeftImageRight) {
                /* title
                    L: x - padding / 2
                    R: x - padding / 2 + imageWidth + padding
                 * image
                    L: titlewidth + x - padding/2 + padding
                    R: x - padding/2
                 */
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle + padding / 2.f, 0, - padding / 2.f - widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - padding / 2.f - widthImage, 0, widthImage + padding / 2.f);
            }
            // 中心 + 上图下文
            else if (alignment == JFButtonAlignmentNormal && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image L: x
                 * image R: title + x
                 * image T: y
                 * image B: y
                 * title L: x + image
                 * title R: x
                 * title T: z
                 * title B: z
                 *****【destination】
                 * image L: x + title/2
                 * image R: x + title/2
                 * image T: y - image/2 - padding/2
                 * image B: y + image/2 + padding/2
                 * title L: x + image/2
                 * title R: x + image/2
                 * title T: z + title/2 + padding/2
                 * title B: z - title/2 - padding/2
                 */
                self.imageEdgeInsets = UIEdgeInsetsMake(- heightImage/2.f - padding/2.f, widthTitle/2.f, heightImage/2.f + padding/2.f, -widthTitle/2.f);
                self.titleEdgeInsets = UIEdgeInsetsMake(heightTitle/2.f + padding/2.f, -widthImage/2.f, -heightTitle/2.f - padding/2.f, widthImage/2.f);
            }

            // 中心 + 上文下图
            else if (alignment == JFButtonAlignmentNormal && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image L: x //(w - image - title)/2
                 * image R: title + x
                 * image T: y //(h - image)/2
                 * image B: y
                 * title L: x + image
                 * title R: x
                 * title T: z //(h - title)/2
                 * title B: z
                 *****【destination】
                 * image L: x + title/2
                 * image R: x + title/2
                 * image T: y - title/2 - padding/2 + title + padding //(h - image - title)/2
                 * image B: y - title/2 - padding/2
                 * title L: x + image/2 // (w - title)/2
                 * title R: x + image/2
                 * title T: z - image/2 - padding/2 //(h - image - title)/2
                 * title B: z - iamge/2 - padding/2 + padding + image
                 */
                self.imageEdgeInsets = UIEdgeInsetsMake(heightTitle/2.f + padding/2.f, widthTitle/2.f, -heightTitle/2.f -padding/2.f, -widthTitle/2.f);
                self.titleEdgeInsets = UIEdgeInsetsMake(-heightImage/2.f - padding/2.f, -widthImage/2.f, heightImage/2.f + padding/2.f, widthImage/2.f);
            }

            // 左边 + 左图右文
            else if (alignment == JFButtonAlignmentLeft && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image L: 0
                 * image R: title + x
                 * title L: image
                 * title R: x
                 *****【destination】
                 * image L: 0
                 * image R: padding + title + x - padding
                 * title L: image + padding
                 * title R: x - padding
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, -padding);
            }

            // 左边 + 左文右图
            else if (alignment == JFButtonAlignmentLeft && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image L: 0
                 * image R: title + x
                 * title L: image
                 * title R: x
                 *****【destination】
                 * image L: title + padding
                 * image R: x - padding
                 * title L: 0
                 * title R: padding + image + x - padding
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle + padding, 0, - padding - widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - widthImage, 0, padding + widthImage - padding);
            }

            // 左边 + 上图下文
            else if (alignment == JFButtonAlignmentLeft && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 左: 0
                 * image 右: x + wt // x = w - wi - wt
                 * image 上: yi // yi = (h - hi)/2
                 * image 下: yi
                 * title 左: wi
                 * title 右: x
                 * title 上: yt // yt = (h - ht)/2 =
                 * title 下: yt
                 *****【destination】
                 * image 左: 0
                 * image 右: x + wt // w - wi
                 * image 上: yi - ht/2 - padding/2 // (h - hi - ht)/2.
                 * image 下: yi - ht/2 - padding/2 + ht + padding
                 * title 左: 0
                 * title 右: x + wi // w - wt
                 * title 上: yt - hi/2 - padding/2 + hi + padding
                 * title 下: yt - hi/2 - padding/2
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(-heightTitle/2.f - padding/2.f, 0, heightTitle/2.f + padding/2.f, 0);
                self.titleEdgeInsets = UIEdgeInsetsMake(heightImage/2.f + padding/2.f, -widthImage, -heightImage/2.f - padding/2.f, widthImage);
            }

            // 左边 + 上文下图
            else if (alignment == JFButtonAlignmentLeft && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 左: 0
                 * image 右: x + wt // x = w - wi - wt
                 * image 上: yi // yi = (h - hi)/2
                 * image 下: yi
                 * title 左: wi
                 * title 右: x
                 * title 上: yt // yt = (h - ht)/2 =
                 * title 下: yt
                 *****【destination】
                 * image 左: 0
                 * image 右: x + wt
                 * image 上: yi - ht/2 - padding/2 + ht + padding
                 * image 下: yi - ht/2 - padding/2
                 * title 左: 0
                 * title 右: x + wi
                 * title 上: yt - hi/2 - padding/2
                 * title 下: yt - hi/2 - padding/2 + hi + padding
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(heightTitle/2.f + padding/2.f, 0, -heightTitle/2.f - padding/2.f, 0);
                self.titleEdgeInsets = UIEdgeInsetsMake(-heightImage/2.f - padding/2.f, -widthImage, heightImage/2.f + padding/2.f, widthImage);
            }
        
            // 右边 + 左图右文
            else if (alignment == JFButtonAlignmentRight && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 上: yi // yi = (h - hi)/2
                 * image 左: x // x = w - wi - wt
                 * image 下: yi
                 * image 右: wt
                 * title 上: yt // yt = (h - ht)/2.
                 * title 左: x + wi
                 * title 下: yt
                 * title 右: 0
                 *****【destination】
                 * image 上: yi
                 * image 左: x - padding
                 * image 下: yi
                 * image 右: wt + padding
                 * title 上: yt
                 * title 左: x + wi
                 * title 下: yt
                 * title 右: 0
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding, 0, padding);
            }

            // 右边 + 左文右图
            else if (alignment == JFButtonAlignmentRight && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: yi // yi = (h - hi)/2
                 * image 左: x // x = w - wi - wt
                 * image 下: yi
                 * image 右: wt
                 * title 上: yt // yt = (h - ht)/2.
                 * title 左: x + wi
                 * title 下: yt
                 * title 右: 0
                 *****【destination】
                 * image 上: yi
                 * image 左: x + wt
                 * image 下: yi
                 * image 右: 0
                 * title 上: yt
                 * title 左: x - padding
                 * title 下: yt
                 * title 右: padding + wi
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle, 0, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -padding - widthImage, 0, padding + widthImage);
            }

            // 右边 + 上图下文
            else if (alignment == JFButtonAlignmentRight && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: yi // yi = (h - hi)/2
                 * image 左: x // x = w - wi - wt
                 * image 下: yi
                 * image 右: wt
                 * title 上: yt // yt = (h - ht)/2.
                 * title 左: x + wi
                 * title 下: yt
                 * title 右: 0
                 *****【destination】
                 * image 上: yi - ht/2 - padding/2 // (h - ht - hi)/2 - padding/2
                 * image 左: x + wt // w - wi
                 * image 下: yi - ht/2 - padding/2 + ht + padding
                 * image 右: 0
                 * title 上: yt - hi/2 - padding/2 + hi + padding
                 * title 左: x + wi // w - wt
                 * title 下: yt - hi/2 - padding/2
                 * title 右: 0
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(-heightTitle/2.f - padding/2.f, widthTitle, heightTitle/2 + padding/2, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(heightImage/2 + padding/2, 0, -heightImage/2 - padding/2, 0);
            }

            // 右边 + 上文下图
            else if (alignment == JFButtonAlignmentRight && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: yi // yi = (h - hi)/2
                 * image 左: x // x = w - wi - wt
                 * image 下: yi
                 * image 右: wt
                 * title 上: yt // yt = (h - ht)/2.
                 * title 左: x + wi
                 * title 下: yt
                 * title 右: 0
                 *****【destination】
                 * image 上: yi - ht/2 - padding/2 + ht + padding
                 * image 左: x + wt
                 * image 下: yi - ht/2 - padding/2
                 * image 右: 0
                 * title 上: yt - hi/2 - padding/2
                 * title 左: x + wi
                 * title 下: yt - hi/2 - padding/2 + hi + padding
                 * title 右: 0
                 */
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(heightTitle/2 + padding/2, widthTitle, -heightTitle/2 - padding/2, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(-heightImage/2 - padding/2, 0, heightImage/2 + padding/2, 0);
            }

            // 上边 + 左图右文
            else if (alignment == JFButtonAlignmentTop && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 左: x
                 * image 右: title + x
                 * image 上: 0
                 * image 下: yi
                 * title 左: image + x
                 * title 右: x
                 * title 上: 0
                 * title 下: yt
                 *****【destination】
                 * image 左: x - padding/2
                 * image 右: padding + title + x - padding/2
                 * image 上: 0
                 * image 下: yi
                 * title 左: x - padding/2 + image + padding
                 * title 右: x - padding/2
                 * title 上: 0
                 * title 下: yt
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, - padding/2.f, 0, padding/2.f);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding/2.f, 0, - padding/2.f);
            }

            // 上边 + 左文右图
            else if (alignment == JFButtonAlignmentTop && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: 0
                 * image 左: x = (w - wi - wt)/2
                 * image 下: yi = h - hi
                 * image 右: x + wt
                 * title 上: 0
                 * title 左: x + wi
                 * title 下: yt = h - ht
                 * title 右: x
                 *****【destination】
                 * image 上: 0
                 * image 左: x - padding/2 + wt + padding
                 * image 下: yi
                 * image 右: x - padding/2
                 * title 上: 0
                 * title 左: x - padding/2
                 * title 下: yt
                 * title 右: x - padding/2 + wi + padding
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle + padding/2, 0, -widthTitle - padding/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage - padding/2, 0, widthImage + padding/2);
            }

            // 上边 + 上图下文
            else if (alignment == JFButtonAlignmentTop && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: 0
                 * image 左: x = (w - wi - wt)/2
                 * image 下: yi = h - hi
                 * image 右: x + wt
                 * title 上: 0
                 * title 左: x + wi
                 * title 下: yt = h - ht
                 * title 右: x
                 *****【destination】
                 * image 上: 0
                 * image 左: x + wt/2 // (w - wi)/2
                 * image 下: yi
                 * image 右: x + wt/2
                 * title 上: hi + padding
                 * title 左: x + wi/2 // (w - wt)/2
                 * title 下: yt - hi - padding // h - hi - ht - padding
                 * title 右: x + wi/2
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle/2, 0, -widthTitle/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(heightImage + padding, -widthImage/2, -heightImage - padding, widthImage/2);

            }

            // 上边 + 上文下图
            else if (alignment == JFButtonAlignmentTop && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: 0
                 * image 左: x = (w - wi - wt)/2
                 * image 下: yi = h - hi
                 * image 右: x + wt
                 * title 上: 0
                 * title 左: x + wi
                 * title 下: yt = h - ht
                 * title 右: x
                 *****【destination】
                 * image 上: ht + padding
                 * image 左: x + wt/2
                 * image 下: yi - ht - padding // h - ht - padding - hi
                 * image 右: x + wt/2
                 * title 上: 0
                 * title 左: x + wi/2
                 * title 下: yt // h - ht
                 * title 右: x + wi/2
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.imageEdgeInsets = UIEdgeInsetsMake(heightTitle + padding, widthTitle/2, -heightTitle - padding, -widthTitle/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage/2, 0, widthImage/2);

            }

            
            // 下边 + 左图右文
            else if (alignment == JFButtonAlignmentBottom && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 上: yi  = h - hi
                 * image 左: x   = (w - wi - wt)/2
                 * image 下: 0
                 * image 右: x + wt
                 * title 上: yt  = h - ht
                 * title 左: x + wi
                 * title 下: 0
                 * title 右: x
                 *****【destination】
                 * image 上: yi
                 * image 左: x - padding/2
                 * image 下: 0
                 * image 右: x - padding/2 + wt + padding
                 * title 上: yt
                 * title 左: x - padding/2 + wi + padding
                 * title 下: 0
                 * title 右: x - padding/2
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding/2, 0, padding/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding/2, 0, -padding/2);

            }

            // 下边 + 左文右图
            else if (alignment == JFButtonAlignmentBottom && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: x = (w - wi - wt)/2
                 * image 下: 0
                 * image 右: x + wt
                 * title 上: yt = h - ht
                 * title 左: x + wi
                 * title 下: 0
                 * title 右: x
                 *****【destination】
                 * image 上: yi
                 * image 左: x - padding/2 + wt + padding
                 * image 下: 0
                 * image 右: x - padding/2
                 * title 上: yt
                 * title 左: x - padding/2
                 * title 下: 0
                 * title 右: x - padding/2 + wi + padding
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle + padding/2, 0, -widthTitle - padding/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage - padding/2, 0, widthImage + padding/2);

            }

            // 下边 + 上图下文
            else if (alignment == JFButtonAlignmentBottom && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: x = (w - wi - wt)/2
                 * image 下: 0
                 * image 右: x + wt
                 * title 上: yt = h - ht
                 * title 左: x + wi
                 * title 下: 0
                 * title 右: x
                 *****【destination】
                 * image 上: yi - ht - padding // h - ht - padding - hi
                 * image 左: x + wt/2 // (w - wi)/2
                 * image 下: ht + padding
                 * image 右: x + wt/2
                 * title 上: yt
                 * title 左: x + wi/2 // (w - wt)/2
                 * title 下: 0
                 * title 右: x + wi/2
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.imageEdgeInsets = UIEdgeInsetsMake(-heightTitle - padding, widthTitle/2, heightTitle + padding, -widthTitle/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage/2, 0, widthImage/2);

            }

            // 下边 + 上文下图
            else if (alignment == JFButtonAlignmentBottom && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: x = (w - wi - wt)/2
                 * image 下: 0
                 * image 右: x + wt
                 * title 上: yt = h - ht
                 * title 左: x + wi
                 * title 下: 0
                 * title 右: x
                 *****【destination】
                 * image 上: yi
                 * image 左: x + wt/2 // (w - wi)/2
                 * image 下: 0
                 * image 右: x + wt/2
                 * title 上: yt - hi - padding // h - hi - padding - ht
                 * title 左: x + wi/2
                 * title 下: hi + padding
                 * title 右: x + wi/2
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle/2, 0, -widthTitle/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(-heightImage - padding, -widthImage/2, heightImage + padding, widthImage/2);

            }
            
            // 左上 + 左图右文
            else if (alignment == JFButtonAlignmentTopLeft && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 上: 0
                 * image 左: 0
                 * image 下: yi = h - hi
                 * image 右: xi = w - wi
                 * title 上: 0
                 * title 左: wi
                 * title 下: yt = h - ht
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上: 0
                 * image 左: 0
                 * image 下: yi
                 * image 右: xi
                 * title 上: 0
                 * title 左: wi + padding
                 * title 下: yt
                 * title 右: xt - padding
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, -padding);
            }

            // 左上 + 左文右图
            else if (alignment == JFButtonAlignmentTopLeft && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: 0
                 * image 左: 0
                 * image 下: yi = h - hi
                 * image 右: xi = w - wi
                 * title 上: 0
                 * title 左: wi
                 * title 下: yt = h - ht
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上:
                 * image 左:
                 * image 下:
                 * image 右:
                 * title 上:
                 * title 左:
                 * title 下:
                 * title 右:
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle + padding, 0, - padding - widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - widthImage, 0, widthImage - padding);
            }

            // 左上 + 上图下文
            else if (alignment == JFButtonAlignmentTopLeft && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: 0
                 * image 左: 0
                 * image 下: yi = h - hi
                 * image 右: xi = w - wi
                 * title 上: 0
                 * title 左: wi
                 * title 下: yt = h - ht
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上:
                 * image 左:
                 * image 下:
                 * image 右:
                 * title 上: hi + padding
                 * title 左: 0
                 * title 下: yt - hi - padding // h - hi - ht - padding
                 * title 右: xt + wi // w - wt
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.titleEdgeInsets = UIEdgeInsetsMake(heightImage + padding, -widthImage, -widthImage - padding, widthImage);

            }

            // 左上 + 上文下图
            else if (alignment == JFButtonAlignmentTopLeft && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: 0
                 * image 左: 0
                 * image 下: yi = h - hi
                 * image 右: xi = w - wi
                 * title 上: 0
                 * title 左: wi
                 * title 下: yt = h - ht
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上: ht + padding
                 * image 左: 0
                 * image 下: yi - ht - padding // h - ht - hi - padding
                 * image 右: xi
                 * title 上: 0
                 * title 左: 0
                 * title 下: yt
                 * title 右: xt + wi
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(heightTitle + padding, 0, -heightTitle - padding, 0);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage, 0, widthImage);

            }
            
            // 右上 + 左图右文
            else if (alignment == JFButtonAlignmentTopRight && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 上: 0
                 * image 左: xi = w - wi - wt
                 * image 下: yi = h - hi
                 * image 右: wt
                 * title 上: 0
                 * title 左: xi + wi
                 * title 下: yt = h - ht
                 * title 右: 0
                 *****【destination】
                 * image 上: 0
                 * image 左: xi - padding
                 * image 下: yi
                 * image 右: wt + padding
                 * title 上: 0
                 * title 左: xi + wi
                 * title 下: yt
                 * title 右: 0
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding, 0, padding);
            }

            // 右上 + 左文右图
            else if (alignment == JFButtonAlignmentTopRight && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: 0
                 * image 左: xi = w - wi - wt
                 * image 下: yi = h - hi
                 * image 右: wt
                 * title 上: 0
                 * title 左: xi + wi
                 * title 下: yt = h - ht
                 * title 右: 0
                 *****【destination】
                 * image 上: 0
                 * image 左: xi + wt // w - wi
                 * image 下: yi
                 * image 右: 0
                 * title 上: 0
                 * title 左: xi - padding // w - wi - wt - padding
                 * title 下: yt
                 * title 右: wi + padding
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle, 0, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage - padding, 0, widthImage + padding);

            }

            // 右上 + 上图下文
            else if (alignment == JFButtonAlignmentTopRight && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: 0
                 * image 左: xi = w - wi - wt
                 * image 下: yi = h - hi
                 * image 右: wt
                 * title 上: 0
                 * title 左: xi + wi
                 * title 下: yt = h - ht
                 * title 右: 0
                 *****【destination】
                 * image 上: 0
                 * image 左: xi + wt
                 * image 下: yi
                 * image 右: 0
                 * title 上: hi + padding
                 * title 左: xi + wi
                 * title 下: yt - hi - padding // h - hi - ht - padding
                 * title 右: 0
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle, 0, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(heightImage + padding, 0, -heightImage - padding, 0);

            }

            // 右上 + 上文下图
            else if (alignment == JFButtonAlignmentTopRight && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: 0
                 * image 左: xi = w - wi - wt
                 * image 下: yi = h - hi
                 * image 右: wt
                 * title 上: 0
                 * title 左: xi + wi
                 * title 下: yt = h - ht
                 * title 右: 0
                 *****【destination】
                 * image 上: ht + padding
                 * image 左: xi + wt
                 * image 下: yi - ht - padding// h - hi - ht - padding
                 * image 右: 0
                 * title 上: 0
                 * title 左: xi + wi
                 * title 下: yt
                 * title 右: 0
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(heightTitle + padding, widthTitle, -heightTitle - padding, -widthTitle);
            }

            // 左下 + 左图右文
            else if (alignment == JFButtonAlignmentBottomLeft && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: 0
                 * image 下: 0
                 * image 右: xi = w - wi
                 * title 上: yt = h - ht
                 * title 左: wi
                 * title 下: 0
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上: yi
                 * image 左: 0
                 * image 下: 0
                 * image 右: xi
                 * title 上: yt
                 * title 左: wi + padding
                 * title 下: 0
                 * title 右: xt - padding
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, -padding);
            }

            // 左下 + 左文右图
            else if (alignment == JFButtonAlignmentBottomLeft && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: 0
                 * image 下: 0
                 * image 右: xi = w - wi
                 * title 上: yt = h - ht
                 * title 左: wi
                 * title 下: 0
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上: yi
                 * image 左: wt + padding
                 * image 下: 0
                 * image 右: xi - wt - padding
                 * title 上: yt
                 * title 左: 0
                 * title 下: 0
                 * title 右: xt + wi // w - wt
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle + padding, 0, -widthTitle - padding);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage, 0, widthImage);

            }

            // 左下 + 上图下文
            else if (alignment == JFButtonAlignmentBottomLeft && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: 0
                 * image 下: 0
                 * image 右: xi = w - wi
                 * title 上: yt = h - ht
                 * title 左: wi
                 * title 下: 0
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上: yi - ht - padding // h - hi - ht - padding
                 * image 左: 0
                 * image 下: ht + padding
                 * image 右: xi
                 * title 上: yt
                 * title 左: 0
                 * title 下: 0
                 * title 右: xt + wi// w - wt
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.imageEdgeInsets = UIEdgeInsetsMake(-heightTitle - padding, 0, heightTitle + padding, 0);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage, 0, widthImage);

            }

            // 左下 + 上文下图
            else if (alignment == JFButtonAlignmentBottomLeft && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: 0
                 * image 下: 0
                 * image 右: xi = w - wi
                 * title 上: yt = h - ht
                 * title 左: wi
                 * title 下: 0
                 * title 右: xt = w - wi - wt
                 *****【destination】
                 * image 上: yi = h - hi
                 * image 左: 0
                 * image 下: 0
                 * image 右: xi = w - wi
                 * title 上: yt - hi - padding // h - hi - ht - padding
                 * title 左: 0
                 * title 下: hi + padding
                 * title 右: xt + wi // w - wt
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.titleEdgeInsets = UIEdgeInsetsMake(-heightImage - padding, -widthImage, heightImage + padding, widthImage);

            }

            // 右下 + 左图右文
            else if (alignment == JFButtonAlignmentBottomRight && type == JFButtonTypeNormal) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: xi = w - wi - wt
                 * image 下: 0
                 * image 右: wt
                 * title 上: yt = h - ht
                 * title 左: xt = w - wt
                 * title 下: 0
                 * title 右: 0
                 *****【destination】
                 * image 上: yi
                 * image 左: xi - padding
                 * image 下: 0
                 * image 右: wt + padding
                 * title 上: yt = h - ht
                 * title 左: xt = w - wt
                 * title 下: 0
                 * title 右: 0
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding, 0, padding);


            }

            // 右下 + 左文右图
            else if (alignment == JFButtonAlignmentBottomRight && type == JFButtonTypeTitleLeftImageRight) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: xi = w - wi - wt
                 * image 下: 0
                 * image 右: wt
                 * title 上: yt = h - ht
                 * title 左: xt = w - wt
                 * title 下: 0
                 * title 右: 0
                 *****【destination】
                 * image 上: yi
                 * image 左: xi + wt // w - wi
                 * image 下: 0
                 * image 右: 0
                 * title 上: yt
                 * title 左: xt - wi - padding // w- wi - wt - padding
                 * title 下: 0
                 * title 右: wi + padding
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle, 0, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -widthImage - padding, 0, widthImage + padding);

            }

            // 右下 + 上图下文
            else if (alignment == JFButtonAlignmentBottomRight && type == JFButtonTypeTitleDownImageUp) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: xi = w - wi - wt
                 * image 下: 0
                 * image 右: wt
                 * title 上: yt = h - ht
                 * title 左: xt = w - wt
                 * title 下: 0
                 * title 右: 0
                 *****【destination】
                 * image 上: yi - ht - padding // h - hi - ht - padding
                 * image 左: xi + wt // w - wi
                 * image 下: ht + padding
                 * image 右: 0
                 * title 上: yt = h - ht
                 * title 左: xt = w - wt
                 * title 下: 0
                 * title 右: 0
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(-heightTitle - padding, widthTitle, heightTitle + padding, -widthTitle);
            }

            // 右下 + 上文下图
            else if (alignment == JFButtonAlignmentBottomRight && type == JFButtonTypeTitleUpImageDown) {
                /*****【origin】
                 * image 上: yi = h - hi
                 * image 左: xi = w - wi - wt
                 * image 下: 0
                 * image 右: wt
                 * title 上: yt = h - ht
                 * title 左: xt = w - wt
                 * title 下: 0
                 * title 右: 0
                 *****【destination】
                 * image 上: yi
                 * image 左: xi + wt // w- wi
                 * image 下: 0
                 * image 右: 0
                 * title 上: yt - hi - padding // h - hi - ht - padding
                 * title 左: xt // w - wt
                 * title 下: hi + padding
                 * title 右: 0
                 */
                self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, widthTitle, 0, -widthTitle);
                self.titleEdgeInsets = UIEdgeInsetsMake(-heightImage - padding, 0, heightImage + padding, 0);
            }

        }
    }
    return self;
}


@end

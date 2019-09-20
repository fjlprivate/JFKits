//
//  JFBanner.h
//  AuroraF
//
//  Created by LongerFeng on 2019/7/17.
//  Copyright © 2019 LongerFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* ** 轮播图Banner **
 *
 */


@class JFBanner;

@protocol JFBannerDelegate <NSObject>

/**
 传递图片的个数；必须大于等于3
 @param banner 轮播图
 @return 个数
 */
- (NSInteger) numberOfItemsInBanner:(JFBanner*)banner;

/**
 传递图片
 @param banner 轮播图
 @param index 图片序号
 @return UIImage|NSURL
 */
- (id) banner:(JFBanner*)banner imageForItemAtIndex:(NSInteger)index;


@end


@interface JFBanner : UIView

// item间隔;默认:5
@property (nonatomic, assign) CGFloat itemGap;
// image边框的步进;默认:10
@property (nonatomic, assign) CGFloat itemAdvance;
// 是否循环;默认:YES
@property (nonatomic, assign) BOOL shouldLoop;
// 轮播间隔时间;默认:3s
@property (nonatomic, assign) NSTimeInterval loopInterval;
// 图片圆角;默认:5
@property (nonatomic, assign) CGFloat imageCornerRadius;



// 刷新Banner
- (void) reloadDatas;

// delegate
@property (nonatomic, weak) id<JFBannerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END

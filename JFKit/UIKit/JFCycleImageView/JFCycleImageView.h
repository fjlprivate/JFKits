//
//  JFCycleImageView.h
//  RuralMeet
//
//  Created by JohnnyFeng on 2017/10/30.
//  Copyright © 2017年 occ. All rights reserved.
//

#import <UIKit/UIKit.h>

// 占位图
#define JFCycleImagePlaceholder     [UIImage imageNamed:@"banner_test"]


@interface JFCycleImageView : UIView

// 显示的图片列表: UIImage | NSURL
@property (nonatomic, copy) NSArray* imageList;

// 当前显示的图片序号;可以set切换到指定序号的图片;
@property (nonatomic, assign) NSInteger currentPage;

// 是否定时轮播;默认YES;
@property (nonatomic, assign) BOOL shouldPlayOnTimer;

// 间隔时长;默认4s
@property (nonatomic, assign) NSTimeInterval playDuration;

// 图片间隔;默认:5
@property (nonatomic, assign) CGFloat imageGap;

// 回调: 选择了制定序号的图片
@property (nonatomic, copy) void (^ didSelectAtIndex) (NSInteger index);

// 页脚
@property (nonatomic, strong) UIPageControl* pageCtrl;

@end

//
//  JFPageView.h
//  RuralMeet
//
//  Created by JohnnyFeng on 2017/10/30.
//  Copyright © 2017年 occ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JFPageView : UIView

// 初始化: 指定页数
+ (instancetype) jf_pageViewWithPageCount:(NSInteger)pageCount;

// 回调: 点击并切换了page;只有点击切换的才引发此回调;setCurrentPage: 不会引发此回调;
@property (nonatomic, copy) void (^ JFPageViewSelectedPage) (NSInteger selectedPage);

@property (nonatomic, assign) NSInteger pagesCount; // 所有页数

@property (nonatomic, assign) NSInteger currentPage; // 当前页

@property (nonatomic, copy) UIColor* normalColor; // 默认颜色;(默认:white:1:alpha:0.5)
@property (nonatomic, copy) UIColor* highLightColor; // 高亮颜色;(默认:橙色)

@property (nonatomic, assign) CGFloat itemHeight; // 元素高;(默认:2.5)
@property (nonatomic, assign) CGFloat itemInset; // 元素间隔;(默认:8)

@end

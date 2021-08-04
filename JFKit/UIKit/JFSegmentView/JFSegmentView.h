//
//  JFSegmentView.h
//  JFKitDemo
//
//  Created by 严美 on 2020/5/24.
//  Copyright © 2020 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFSegmentView;
@protocol JFSegmentViewDelegate <NSObject>
// 是否允许选择index
- (BOOL) segmentView:(JFSegmentView*)segmentView canSelectAtIndex:(NSInteger)index;
// 选择了index
- (void) segmentView:(JFSegmentView*)segmentView didSelectAtIndex:(NSInteger)index;
@end



@interface JFSegmentView : UIView

- (instancetype) initWithItems:(NSArray<NSString*>*)items;

@property (nonatomic, weak) id<JFSegmentViewDelegate> delegate;

// 回调:选中了指定序号
@property (nonatomic, copy) void (^ didSelectedItem) (NSInteger selectedIndex);

// 文本颜色:选中 dark
@property (nonatomic, strong) UIColor* selectedTextColor;
// 文本颜色:未选中 dark
@property (nonatomic, strong) UIColor* unselectedTextColor;
// 文本字体；选中; 默认: 平方-bold 14
@property (nonatomic, strong) UIFont* selectedTextFont;
// 文本字体；未选中; 默认: 平方-bold 14
@property (nonatomic, strong) UIFont* unSelectedTextFont;


// 背景色；默认:#EDEEF0
@property (nonatomic, strong) UIColor* bgColor;
// 滑块背景色；默认：白色
@property (nonatomic, strong) UIColor* trackerBgColor;
// 分割线颜色; 默认: #DCDDE0
@property (nonatomic, strong) UIColor* seperatorColor;
// 分割线高度; 默认为0
@property (nonatomic, assign) CGFloat seperatorHeight;
// 分割线宽度; 默认为1
@property (nonatomic, assign) CGFloat seperatorWidth;

// 圆角值;默认：8
@property (nonatomic, assign) CGFloat cornerRadius;
// 内圆角值;默认：6
@property (nonatomic, assign) CGFloat innerCornerRadius;
// 内间距;默认：2
@property (nonatomic, assign) CGFloat innerInset;

@end

NS_ASSUME_NONNULL_END

//
//  JFSegmentView.m
//  JFKitDemo
//
//  Created by 严美 on 2020/5/24.
//  Copyright © 2020 JohnnyFeng. All rights reserved.
//

#import "JFSegmentView.h"
#import "JFHelper.h"
#import "UIView+Extension.h"
#import <Masonry/Masonry.h>

@interface JFSegmentView()
@property (nonatomic, strong) NSArray<NSString*>* items;
@property (nonatomic, strong) NSArray<UILabel*>* labItems;
@property (nonatomic, strong) NSArray<UIView*>* vSeperators;
@property (nonatomic, strong) UIView* vTracker;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) MASConstraint* masTrackerLeft;
@end

@implementation JFSegmentView

- (void) handleWithTapGes:(UITapGestureRecognizer*)tapGes {
    if (IsNon(self.labItems)) {
        return;
    }
    CGPoint location = [tapGes locationInView:self];
    NSInteger index = NSNotFound;
    for (UILabel* lab in self.labItems) {
        if (CGRectContainsPoint(lab.frame, location)) {
            index = [self.labItems indexOfObject:lab];
            break;
        }
    }
    if (index == NSNotFound || index == self.selectedIndex) {
        return;
    }
    
    // 如果不允许切换，则取消
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:canSelectAtIndex:)]) {
        if (![self.delegate segmentView:self canSelectAtIndex:index]) {
            return;
        }
    }
    
    self.selectedIndex = index;
    [self resetViews];
    [self movingTracker];
    
    if (self.didSelectedItem) {
        self.didSelectedItem(index);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectAtIndex:)]) {
        [self.delegate segmentView:self didSelectAtIndex:index];
    }
}

- (void) movingTracker {
    CGRect frame = self.vTracker.frame;
    frame.origin.x = (2) + self.selectedIndex * self.vTracker.width;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.vTracker.frame = frame;
    } completion:^(BOOL finished) {
        
    }];

}

# pragma mark - private
- (void) resetViews {
    self.backgroundColor = self.bgColor;
    self.vTracker.backgroundColor = self.trackerBgColor;
    self.layer.cornerRadius = self.cornerRadius;
    self.vTracker.layer.cornerRadius = self.innerCornerRadius;
    for (UILabel* lab in self.labItems) {
        lab.textColor = [self.labItems indexOfObject:lab] == self.selectedIndex ? self.selectedTextColor : self.unselectedTextColor;
        lab.font = [self.labItems indexOfObject:lab] == self.selectedIndex ? self.selectedTextFont : self.unSelectedTextFont;
    }
    for (int i = 0; i < self.vSeperators.count; i++) {
        UIView* line = self.vSeperators[i];
        line.backgroundColor = self.seperatorColor;
        BOOL hidden = i == self.selectedIndex - 1 || i == self.selectedIndex;
        // 显示的慢点
        if (!hidden) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                line.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
        // 消失的快点
        else {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                line.alpha = 0;
            } completion:^(BOOL finished) {
            }];
        }
    }

}


# pragma mark - life cycle
- (instancetype) initWithItems:(NSArray<NSString*>*)items {
    if (self = [self initWithFrame:CGRectZero]) {
        self.items = items;
        [self resetViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        _selectedTextColor = JFRGBAColor(0x1B2233, 1);
        _unselectedTextColor = JFRGBAColor(0x2B4A66, 1);
        _unSelectedTextFont = JFFontWithName(@"PingFangSC-Semibold", 14);
        _selectedTextFont = JFFontWithName(@"PingFangSC-Semibold", 14);
        _bgColor = JFRGBAColor(0xE9ECF2, 0.7);//HEXCOLOR(0xEDEEF0);
        _trackerBgColor = JFColorWhite;
        _cornerRadius = (8);
        _innerCornerRadius = (6);
        _selectedIndex = 0;
        _seperatorColor = JFRGBAColor(0xDCDDE0, 0.7);
        _seperatorHeight = 0;
        _seperatorWidth = 1;
        _innerInset = 2;
        [self addSubview:self.vTracker];
        [self resetViews];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithTapGes:)]];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = IsNon(self.labItems) ? 0 : (self.width - (self.innerInset * 2)) / self.labItems.count;
    CGFloat height = IsNon(self.labItems) ? 0 : self.height;
    self.vTracker.frame = CGRectMake(self.innerInset + self.selectedIndex * width,
                                     self.innerInset,
                                     width,
                                     self.height - self.innerInset * 2);
    for (UILabel* lab in self.labItems) {
        NSInteger i = [self.labItems indexOfObject:lab];
        lab.frame = CGRectMake(self.innerInset + i * width, 0, width, self.height);
    }
    for (UIView* seperator in self.vSeperators) {
        NSInteger i = [self.vSeperators indexOfObject:seperator];
        seperator.frame = CGRectMake(self.innerInset + (i + 1) * width - self.seperatorWidth * 0.5,
                                     (height - self.seperatorHeight) * 0.5,
                                     self.seperatorWidth,
                                     self.seperatorHeight);
    }
}




# pragma mark - getter
- (UIView *)vTracker {
    if (!_vTracker) {
        _vTracker = [UIView new];
        _vTracker.layer.masksToBounds = YES;
    }
    return _vTracker;
}
# pragma mark - setter
- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    if (IsNon(items)) {
        return;
    }
    if (!IsNon(self.labItems)) {
        for (UILabel* lab in self.labItems) {
            [lab removeFromSuperview];
        }
        self.labItems = nil;
    }
    if (!IsNon(self.vSeperators)) {
        for (UIView* line in self.vSeperators) {
            [line removeFromSuperview];
        }
        self.vSeperators = nil;
    }
    // 创建labels
    NSMutableArray* list = @[].mutableCopy;
    for (NSString* item in items) {
        UILabel* lab = [[UILabel alloc] init];
        lab.text = item;
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        [list addObject:lab];
    }
    self.labItems = list;
    // 创建分割线
    NSMutableArray* lines = @[].mutableCopy;
    for (int i = 0; i < items.count - 1; i++) {
        UIView* line = [[UIView alloc] init];
        line.backgroundColor = self.seperatorColor;
        [self addSubview:line];
        [lines addObject:line];
    }
    self.vSeperators = lines;
    
}
- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    [self resetViews];
}
- (void)setUnselectedTextColor:(UIColor *)unselectedTextColor {
    _unselectedTextColor = unselectedTextColor;
    [self resetViews];
}
- (void)setSelectedTextFont:(UIFont *)selectedTextFont {
    _selectedTextFont = selectedTextFont;
    [self resetViews];
}
- (void)setUnSelectedTextFont:(UIFont *)unSelectedTextFont {
    _unSelectedTextFont = unSelectedTextFont;
    [self resetViews];
}
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    [self resetViews];
}
- (void)setTrackerBgColor:(UIColor *)trackerBgColor {
    _trackerBgColor = trackerBgColor;
    [self resetViews];
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self resetViews];
}
- (void)setInnerCornerRadius:(CGFloat)innerCornerRadius {
    _innerCornerRadius = innerCornerRadius;
    [self resetViews];
}
- (void)setSeperatorColor:(UIColor *)seperatorColor {
    _seperatorColor = seperatorColor;
    [self resetViews];
}
- (void)setSeperatorWidth:(CGFloat)seperatorWidth {
    _seperatorWidth = seperatorWidth;
    [self resetViews];
}
- (void)setSeperatorHeight:(CGFloat)seperatorHeight {
    _seperatorHeight = seperatorHeight;
    [self resetViews];
}

@end

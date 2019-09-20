//
//  JFPageView.m
//  RuralMeet
//
//  Created by JohnnyFeng on 2017/10/30.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "JFPageView.h"

@interface JFPageView()
@property (nonatomic, strong) NSMutableArray* pageButtons; // 按钮组
@property (nonatomic, strong) NSMutableArray* pageSegments; // 分割器组
@end

@implementation JFPageView

# pragma mark - IBActions

- (IBAction) clickedPageButton:(UIButton*)pageBtn {
    self.currentPage = pageBtn.tag;
    if (self.JFPageViewSelectedPage) {
        self.JFPageViewSelectedPage(pageBtn.tag);
    }
}

# pragma mark - tools

//
- (UIButton*) newBtnWithTag:(NSInteger)tag {
    UIButton* btn = [UIButton new];
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickedPageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}
- (UIView*) newSegViewWithTag:(NSInteger)tag {
    UIView* view = [UIView new];
    view.tag = tag;
    view.backgroundColor = tag == self.currentPage ? self.highLightColor : self.normalColor;
    [self addSubview:view];
    return view;
}

# pragma mark - life cycle
+ (instancetype)jf_pageViewWithPageCount:(NSInteger)pageCount {
    JFPageView* pageView = [JFPageView new];
    pageView.pagesCount = pageCount;
    return pageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageButtons = @[].mutableCopy;
        _pageSegments = @[].mutableCopy;
        _itemInset = 6.f;
        _itemHeight = 2.5;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat uniteWidth = self.bounds.size.width / self.pagesCount;
    CGFloat uniteHeight = self.bounds.size.height;
    for (int i = 0; i < self.pagesCount; i ++) {
        UIButton* pageBtn = self.pageButtons[i];
        UIView* pageSeg = self.pageSegments[i];
        pageBtn.center = CGPointMake(uniteWidth * (0.5 + i), uniteHeight * 0.5);
        pageBtn.bounds = CGRectMake(0, 0, uniteWidth, uniteHeight);
        pageSeg.center = CGPointMake(uniteWidth * (0.5 + i), uniteHeight - self.itemHeight * 0.5);
        pageSeg.bounds = CGRectMake(0, 0, uniteWidth - self.itemInset, self.itemHeight);
    }
}

# pragma mark - setter

- (void)setPagesCount:(NSInteger)pagesCount {
    self.hidden = (pagesCount <= 1);
    _pagesCount = pagesCount;
    [self.pageButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.pageSegments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.pageButtons removeAllObjects];
    [self.pageSegments removeAllObjects];
    for (int i = 0; i < pagesCount; i++) {
        [self.pageSegments addObject:[self newSegViewWithTag:i]];
        [self.pageButtons addObject:[self newBtnWithTag:i]];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    for (UIView* view in self.pageSegments) {
        view.backgroundColor = (view.tag == currentPage) ? self.highLightColor : self.normalColor;
    }
}

# pragma mark - getter

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _normalColor;
}
- (UIColor *)highLightColor {
    if (!_highLightColor) {
        _highLightColor = [UIColor orangeColor];
    }
    return _highLightColor;
}


@end

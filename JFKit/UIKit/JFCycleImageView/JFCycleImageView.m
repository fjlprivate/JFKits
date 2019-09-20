//
//  JFCycleImageView.m
//  RuralMeet
//
//  Created by JohnnyFeng on 2017/10/30.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "JFCycleImageView.h"
#import "JFImageDownloadManager.h"
#import <Masonry.h>
#import "JFHelper.h"
#import <UIImageView+WebCache.h>
#import "UIView+Extension.h"

# define  JFCycleImageViewCycleDuration     4   // 轮播间隔时间



@interface JFCycleImageView() <UIScrollViewDelegate>
// 轮播定时器
@property (nonatomic, weak) NSTimer* displayTimer;
// 轮播图
@property (nonatomic, strong) UIScrollView* scrollView;
// 用于显示的图片视图:n+1(头)+1(尾)
@property (nonatomic, strong) NSArray<UIImageView*>* displayImageViews;
@end

@implementation JFCycleImageView

# pragma mark - private

// 手动切换页
- (void) setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate {
    if (currentPage < 0 || currentPage >= self.imageList.count || currentPage == NSNotFound) {
        return;
    }
    if (currentPage == _currentPage) {
        return;
    }
    // 步进;>0为+页;<0为-页;
    NSInteger step = currentPage - _currentPage;
    // 当前页
    NSInteger lastPage = _currentPage;
    // 页宽度
    CGFloat pageWidth = self.scrollView.bounds.size.width;
    // 最大页
    NSInteger maxPage = self.imageList.count - 1;
    // 当前offset
    CGPoint curContentOffset = self.scrollView.contentOffset;
    
    // 向右跳转
    if (step > 0) {
        // 0 -> large
        if (lastPage == 0) {
            // 先将位置设置到正常的0位置:第[1]个page的位置(不动画)
            [self.scrollView setContentOffset:CGPointMake(pageWidth, 0) animated:NO];
            curContentOffset = self.scrollView.contentOffset;
            // 如果0 -> max:要循环:往左跳一页到最开始的页
            if (currentPage == maxPage) {
                step = -1;
            }
        }
    }
    // 向左跳转
    else {
        // large -> 0
        if (lastPage == maxPage) {
            // 先将位置设置到正常的max位置:最后一页的前一页(不动画)
            [self.scrollView setContentOffset:CGPointMake(pageWidth * (maxPage + 1), 0) animated:NO];
            curContentOffset = self.scrollView.contentOffset;
            // 如果max->0:要循环:往右跳一页到最后一页
            if (currentPage == 0) {
                step = 1;
            }
        }
    }
    // 按上面的设置,动画跳转页
    curContentOffset.x += step * pageWidth;
    [self.scrollView setContentOffset:curContentOffset animated:animate];
    // 并缓存当前页
    _currentPage = currentPage;
}

// 生成一个imageView,指定序号
- (UIImageView*) newImageViewForIndex:(NSInteger)index {
    UIImageView* imageView = [UIImageView new];
    imageView.image = JFCycleImagePlaceholder;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    // 设置image和tag
    if (self.imageList && self.imageList.count > 0) {
        if (index >= 0 && index < self.imageList.count) {
            id image = self.imageList[index];
            imageView.tag = index;
            if ([image isKindOfClass:[UIImage class]]) {
                imageView.image = image;
            }
            else if ([image isKindOfClass:[NSURL class]]) {
                [imageView sd_setImageWithURL:image];
            }
            else if ([image isKindOfClass:[NSString class]]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
            }
        } else {
            imageView.tag = 0;
        }
    } else {
        imageView.tag = 0;
    }
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)]];
    return imageView;
}

# pragma mark - IBActions

// 点击图片
- (IBAction) tapGesAction:(UITapGestureRecognizer*)sender {
    if (self.didSelectAtIndex) {
        self.didSelectAtIndex(sender.view.tag);
    }
}


# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat curOffsetX = scrollView.contentOffset.x;
    // 最大页
    NSInteger imageCount = self.imageList.count;
    // 页宽度
    CGFloat pageWidth = scrollView.bounds.size.width;

    // 到达最左边时:切换到最后一张图片
    if (curOffsetX < 0) {
        [scrollView setContentOffset:CGPointMake(pageWidth * imageCount, 0) animated:NO];
    }
    else if (curOffsetX > pageWidth * (imageCount + 1)) {
        [scrollView setContentOffset:CGPointMake(pageWidth, 0) animated:NO];
    }
}
// 手动滑动结束时才有回调;缓存当前页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger curPage = (NSInteger)roundf(scrollView.contentOffset.x / self.bounds.size.width);
    [self willChangeValueForKey:@"currentPage"];
    _currentPage = self.displayImageViews[curPage].tag;
    self.pageCtrl.currentPage = _currentPage;
    [self didChangeValueForKey:@"currentPage"];
}
// 非手动,设置setContentOffset:animated:结束时回调;且animated == YES时才回调;缓存当前页
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger curPage = (NSInteger)roundf(scrollView.contentOffset.x / self.bounds.size.width);
    [self willChangeValueForKey:@"currentPage"];
    _currentPage = self.displayImageViews[curPage].tag;
    self.pageCtrl.currentPage = _currentPage;
    [self didChangeValueForKey:@"currentPage"];
}

# pragma mark - 定时器相关
// 创建并启动轮播定时器
- (void) createAndStartDisplayTimer {
    // 如果轮播时间间隔 > 0，就可以创建并启动定时器
    if (self.playDuration >= CGFLOAT_MIN) {
        NSTimer* timer = [NSTimer timerWithTimeInterval:self.playDuration target:self selector:@selector(incrementCurPageIndex) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode]; //  NSRunLoopCommonModes
        self.displayTimer = timer;
    }
}

// 停止并销毁定时器
- (void) stopAnddistroyDisplayTimer {
    if (self.displayTimer) {
        [self.displayTimer invalidate];
        self.displayTimer = nil;
    }
}

// 轮播
- (void) incrementCurPageIndex {
    // 图片不足2张的，不用轮播了
    if (!self.imageList || self.imageList.count <= 1) {
        return;
    }
    // 正在滚动的，跳过本次轮播，等待下次
    if (!self.scrollView.isTracking &&
        !self.scrollView.isDragging &&
        !self.scrollView.isDecelerating
        )
    {
        NSInteger curPage = self.currentPage + 1;
        if (curPage >= self.imageList.count) {
            curPage = 0;
        }
        self.currentPage = curPage;
    }
}


# pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _playDuration = JFCycleImageViewCycleDuration;
        _shouldPlayOnTimer = YES;
        _imageGap = 5;
        
        self.currentPage = NSNotFound;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageCtrl];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        
    }
    return self;
}

// 重载图片视图
- (void) reloadImageViews {
    if (self.displayImageViews && self.displayImageViews.count > 0) {
        [self.displayImageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    NSMutableArray* list = @[].mutableCopy;
    if (self.imageList && self.imageList.count > 1) {
        UIImageView* imageView = [self newImageViewForIndex:self.imageList.count - 1];
        [self.scrollView addSubview:imageView];
        [list addObject:imageView];
    }
    for (int i = 0; i < self.imageList.count; i++) {
        UIImageView* imageView = [self newImageViewForIndex:i];
        [self.scrollView addSubview:imageView];
        [list addObject:imageView];
    }
    if (self.imageList && self.imageList.count > 1) {
        UIImageView* imageView = [self newImageViewForIndex:0];
        [self.scrollView addSubview:imageView];
        [list addObject:imageView];
    }
    NSArray* oldList = self.displayImageViews;
    self.displayImageViews = list.copy;
    if (oldList && oldList.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [oldList class];
        });
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat selfWidth = self.width;
    CGFloat selfHeight = self.height;
    
    CGFloat startX = 0;
    for (int i = 0; i < self.displayImageViews.count; i++) {
        UIImageView* imageView = self.displayImageViews[i];
        imageView.left = startX;
        imageView.top = 0;
        imageView.width = selfWidth;
        imageView.height = selfHeight;
        startX += imageView.width;
    }
    self.scrollView.contentSize = CGSizeMake(selfWidth * self.displayImageViews.count, selfHeight);
    
    self.currentPage = 0;
    if (self.displayImageViews.count > 1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0) animated:NO];
    }
}


- (void)dealloc {
    [self stopAnddistroyDisplayTimer];
}

# pragma mark - setter

- (void)setImageList:(NSArray *)imageList {
    _imageList = imageList;
    self.pageCtrl.numberOfPages = imageList.count;
    self.scrollView.scrollEnabled = imageList.count > 1;
    // 重载图片
    [self reloadImageViews];
    self.shouldPlayOnTimer = self.shouldPlayOnTimer;
}




- (void)setShouldPlayOnTimer:(BOOL)shouldPlayOnTimer {
    _shouldPlayOnTimer = shouldPlayOnTimer;
    // 先停止原先的定时器
    [self stopAnddistroyDisplayTimer];
    if (shouldPlayOnTimer) {
        [self createAndStartDisplayTimer];
    }
}
- (void)setPlayDuration:(NSTimeInterval)playDuration {
    _playDuration = playDuration;
    [self stopAnddistroyDisplayTimer];
    if (self.shouldPlayOnTimer) {
        [self createAndStartDisplayTimer];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:currentPage animate:YES];
}


# pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageCtrl {
    if (!_pageCtrl) {
        _pageCtrl = [UIPageControl new];
        _pageCtrl.hidesForSinglePage = YES;
        _pageCtrl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.2];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageCtrl;
}


@end



//
//  JFBanner.m
//  AuroraF
//
//  Created by LongerFeng on 2019/7/17.
//  Copyright © 2019 LongerFeng. All rights reserved.
//

#import "JFBanner.h"
#import <Masonry.h>
#import <SDWebImage.h>


@interface JFBanner() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSArray* imageViews;
@property (nonatomic, strong) NSTimer* timer;
@end




@implementation JFBanner


# pragma mark - public

// 刷新Banner
- (void) reloadDatas {
    NSInteger imageCount = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInBanner:)]) {
        imageCount = [self.delegate numberOfItemsInBanner:self];
    }
    // 图片小于3都不处理
    if (imageCount < 3) {
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    CGFloat imageWidth = width - _itemGap * 2 - _itemAdvance * 2;
    CGRect frame = CGRectMake(0, 0, imageWidth, self.bounds.size.height);
    
    // 停止当前的定时器
    [self releaseTimer];
    // 重新布局imageViews,并设置图片到imageView
    for (NSInteger i = 0; i < self.imageViews.count; i++) {
        UIImageView* imageView = self.imageViews[i];
        frame.origin.x += _itemGap * 0.5;
        imageView.frame = frame;
        frame.origin.x += frame.size.width + _itemGap * 0.5;
        if (self.delegate && [self.delegate respondsToSelector:@selector(banner:imageForItemAtIndex:)]) {
            id image = [self.delegate banner:self imageForItemAtIndex:i];
            [self setImage:image forImageView:imageView];
        }
    }
    
    frame.size.width = frame.origin.x;
    _scrollView.contentSize = frame.size;
    
    // 如果轮播，则启动定时器
    if (self.shouldLoop) {
        [self startTimer];
    }
}


# pragma mark - UIScrollViewDelegate


# pragma mark - tools

// 启动定时器
- (void) startTimer {
    
}
// 注销定时器
- (void) releaseTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 给imageView设置图片
- (void) setImage:(id)image forImageView:(UIImageView*)imageView {
    if (!image) {
        return;
    }
    if ([image isMemberOfClass:[UIImage class]]) {
        imageView.image = image;
    }
    else if ([image isMemberOfClass:[NSURL class]]) {
        [imageView sd_setImageWithURL:image];
    }
}

# pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemGap = 5.f;
        _itemAdvance = 10.f;
        _loopInterval = 3.f;
        _shouldLoop = YES;
        _imageCornerRadius = 5.f;
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

# pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (NSArray *)imageViews {
    if (!_imageViews) {
        NSMutableArray* imageViews = @[].mutableCopy;
        for (int i = 0; i < 3; i++) {
            UIImageView* imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.layer.shouldRasterize = YES;
            [self.scrollView addSubview:imageView];
            [imageViews addObject:imageView];
        }
        _imageViews = imageViews;
    }
    return _imageViews;
}

@end

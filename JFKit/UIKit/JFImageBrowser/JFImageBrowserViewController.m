//
//  JFImageBrowserViewController.m
//  TestForTransition
//
//  Created by LiChong on 2017/12/25.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFImageBrowserViewController.h"
#import "JFAnimateTransition.h"
#import <UIImageView+WebCache.h>
#import "JFZoomImageView.h"
#import "JFImageBrowserActionView.h"
#import "JFIBButton.h"

static CGFloat const JFImageBrowserMaxZoomScale = 4.f;          // 图片最大放大比例



# pragma mark - [Class]图片浏览器
@interface JFImageBrowserViewController () <UIViewControllerTransitioningDelegate, UIScrollViewDelegate>
// 图片组; NSArray<JFImageBrowserItem*>
@property (nonatomic, copy) NSArray<JFImageBrowserItem*>* imageList;
// 操作组
@property (nonatomic, copy) NSArray<JFImageBrowserHandler*>* handlers;
// 图片视图组
@property (nonatomic, copy) NSArray<JFZoomImageView*>* imageViewList;
// 当前浏览序号
@property (nonatomic, assign) NSInteger curImageIndex;
// 回场图片索引
@property (nonatomic, assign) NSInteger dismissedImageIndex;
// 图片scrollView
@property (nonatomic, strong) UIScrollView* scrollView;
// 页码标签
@property (nonatomic, strong) UILabel* pageLabel;
// actionSheet
@property (nonatomic, strong) JFImageBrowserActionView* actionSheet;
// actionButton
@property (nonatomic, strong) JFIBButton* actionBtn;
@end

@implementation JFImageBrowserViewController

+ (instancetype)jf_showFromVC:(UIViewController *)fromVC
                withImageList:(NSArray<JFImageBrowserItem *> *)imageList
                  andHandlers:(NSArray<JFImageBrowserHandler*>*)handlers
                 startAtIndex:(NSInteger)startAtIndex
{
    if (!fromVC) {
        return nil;
    }
    if (!imageList || imageList.count == 0) {
        return nil;
    }
    if (startAtIndex >= imageList.count || startAtIndex < 0 || startAtIndex == NSNotFound) {
        startAtIndex = 0;
    }
    JFImageBrowserViewController* imageBrowserVC = [JFImageBrowserViewController new];
    imageBrowserVC.imageList = imageList;
    imageBrowserVC.curImageIndex = startAtIndex;
    imageBrowserVC.handlers = handlers;
    [fromVC presentViewController:imageBrowserVC animated:YES completion:nil];
    return imageBrowserVC;
}



# pragma mark - UIViewControllerTransitioningDelegate
// 转场协议
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    UIImage* animationThumbImage = nil;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    // 起始frame
    CGRect originRect = CGRectMake(screenWidth * 0.5,
                                   screenHeight * 0.5,
                                   0,
                                   0);
    // 动画结束frame
    CGRect destinationRect = [UIScreen mainScreen].bounds;
    
    // 计算动画起始frame和结束frame
    if (self.curImageIndex >= 0 && self.curImageIndex < self.imageList.count) {
        JFImageBrowserItem* item = self.imageList[self.curImageIndex];
        animationThumbImage = item.thumbnail;
        originRect = item.originFrame;
        
        CGFloat imageWidth = screenWidth;
        CGFloat imageHeight = screenHeight;
        if (item.mediaSize.width > 0 && item.mediaSize.height > 0) {
            // 图片宽高比 > 屏幕宽高比 : 以屏宽为准
            if (item.mediaSize.width/item.mediaSize.height > screenWidth/screenHeight) {
                imageHeight = imageWidth * item.mediaSize.height/item.mediaSize.width;
            }
            // 图片宽高比 <= 屏幕宽高比 : 以屏高为准
            else {
                imageWidth = imageHeight * item.mediaSize.width/item.mediaSize.height;
            }
        }
        destinationRect = CGRectMake((screenWidth - imageWidth) * 0.5,
                                     (screenHeight - imageHeight) * 0.5,
                                     imageWidth,
                                     imageHeight);
        
    }
    
    JFAnimateTransitionImageBrowser* transition = [JFAnimateTransitionImageBrowser transitionWithType:JFAnimateTransitionTypePresent];
    transition.image = animationThumbImage;
    transition.originImageRect = originRect;
    transition.finalImageRect = destinationRect;
    transition.contentViewBgColor = self.bgColor;
    return transition;
}
// 回场协议
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    UIImage* animationThumbImage = nil;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    // 起始frame
    CGRect originRect = [UIScreen mainScreen].bounds;
    // 动画结束frame
    CGRect destinationRect = CGRectMake(screenWidth * 0.5,
                                        screenHeight * 0.5,
                                        0,
                                        0);
    
    // 计算动画起始frame和结束frame
    if (self.curImageIndex >= 0 && self.curImageIndex < self.imageList.count) {
        JFImageBrowserItem* item = self.imageList[self.curImageIndex];
        animationThumbImage = item.thumbnail;
        destinationRect = item.originFrame;
        
        CGFloat imageWidth = screenWidth;
        CGFloat imageHeight = screenHeight;
        if (item.mediaSize.width > 0 && item.mediaSize.height > 0) {
            // 图片宽高比 > 屏幕宽高比 : 以屏宽为准
            if (item.mediaSize.width/item.mediaSize.height > screenWidth/screenHeight) {
                imageHeight = imageWidth * item.mediaSize.height/item.mediaSize.width;
            }
            // 图片宽高比 <= 屏幕宽高比 : 以屏高为准
            else {
                imageWidth = imageHeight * item.mediaSize.width/item.mediaSize.height;
            }
        }
        originRect = CGRectMake((screenWidth - imageWidth) * 0.5,
                                (screenHeight - imageHeight) * 0.5,
                                imageWidth,
                                imageHeight);

    }
    
    JFAnimateTransitionImageBrowser* transition = [JFAnimateTransitionImageBrowser transitionWithType:JFAnimateTransitionTypeDismiss];
    transition.image = animationThumbImage;
    transition.originImageRect = originRect;
    transition.finalImageRect = destinationRect;
    transition.contentViewBgColor = self.bgColor;
    return transition;
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        return;
    }
    CGFloat screenWidth = self.view.frame.size.width;
    self.curImageIndex = scrollView.contentOffset.x/screenWidth;
}

# pragma mark - tools

- (IBAction) clickedActionBtn:(id)sender {
    [self.actionSheet showActionSheet];
}

- (CGRect) imageRectInZoomImageView:(JFZoomImageView*)zoomImageView {
    CGRect frame = CGRectZero;
    CGPoint offset = zoomImageView.contentOffset;
    frame.origin = CGPointMake(-offset.x, -offset.y);
    frame.size = zoomImageView.contentSize;
        CGSize imageSize = zoomImageView.imageView.image.size;
        CGFloat imgVWidth = frame.size.width;
        CGFloat imgVHeight = frame.size.height;
        CGFloat imgWidth = imgVWidth;
        CGFloat imgHeight = imgVHeight;
        if (imageSize.width/imageSize.height > imgVWidth/imgVHeight) {
            imgHeight = imgWidth * imageSize.height/imageSize.width;
        }
        else if (imageSize.width/imageSize.height < imgVWidth/imgVHeight) {
            imgWidth = imgHeight * imageSize.width/imageSize.height;
        }
    frame.origin.x += (imgVWidth - imgWidth) * 0.5;
    frame.origin.y += (imgVHeight - imgHeight) * 0.5;
    frame.size.width = imgWidth;
    frame.size.height = imgHeight;

    return frame;
}


# pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.bgColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.bgColor;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageLabel];
    [self.view addSubview:self.actionBtn];
    [self.view addSubview:self.actionSheet];
    self.actionBtn.hidden = !(self.handlers && self.handlers.count > 0);
    
    [self loadImageList];
    
    CGFloat centerYAction = [UIApplication sharedApplication].statusBarFrame.size.height + JFImageBrowserNavigationHeight * 0.5;
    CGSize labelSize = [self.pageLabel sizeThatFits:CGSizeZero];
    CGSize btnSize = [self.actionBtn sizeThatFits:CGSizeZero];
    self.pageLabel.frame = CGRectMake(0, centerYAction - labelSize.height * 0.5, self.view.frame.size.width, labelSize.height);
    self.actionBtn.frame = CGRectMake(self.view.frame.size.width - 15 - btnSize.width,
                                      centerYAction - btnSize.height * 0.5, btnSize.width, btnSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 给scrollView加载图片组
- (void) loadImageList {
    __weak typeof(self) wself = self;
    CGFloat totalWidth = 0;
    CGRect frame = self.view.bounds;
    CGFloat screenWidth = frame.size.width;
    NSMutableArray* list = @[].mutableCopy;
    for (int i = 0; i < self.imageList.count; i++) {
        frame.origin.x = i * screenWidth;
        JFZoomImageView* imageView = [[JFZoomImageView alloc] initWithFrame:frame];
        imageView.maximumZoomScale = JFImageBrowserMaxZoomScale;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        __weak typeof(imageView) weakImageView = imageView;
        imageView.tapGesEvent = ^(NSInteger numberOfTouches) {
            if (numberOfTouches == 1) {
                wself.dismissedImageIndex = weakImageView.tag;
                [wself dismissViewControllerAnimated:YES completion:nil];
            }
        };
        imageView.longpressEvent = ^{
            [wself.actionSheet showActionSheet];
        };
        [self.scrollView addSubview:imageView];
        JFImageBrowserItem* item = self.imageList[i];
        // 设置显示图片:缩略图
        [imageView setImage:item.thumbnail];
        // 设置显示图片:原图
        [imageView setImage:item.mediaOrigin];
        [list addObject:imageView];
        totalWidth += screenWidth;
    }
    self.scrollView.contentSize = CGSizeMake(totalWidth, self.view.bounds.size.height);
    [self.scrollView scrollRectToVisible:CGRectMake(self.curImageIndex * screenWidth, 0, screenWidth, self.view.bounds.size.height) animated:NO];
    self.imageViewList = list.copy;
}

# pragma mark - setter

- (void)setCurImageIndex:(NSInteger)curImageIndex {
    _curImageIndex = curImageIndex;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", curImageIndex+1, self.imageList.count];
}

# pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.font = [UIFont boldSystemFontOfSize:17];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}

- (JFIBButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [JFIBButton new];
        [_actionBtn setTitle:@"● ● ●" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:8];
        [_actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [_actionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _actionBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _actionBtn.layer.cornerRadius = 4;
        _actionBtn.layer.masksToBounds = YES;
        [_actionBtn addTarget:self action:@selector(clickedActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

- (JFImageBrowserActionView *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[JFImageBrowserActionView alloc] initWithFrame:self.view.bounds
                                                                 items:self.handlers];
        __weak typeof(self) wself = self;
        _actionSheet.didSelectWithItem = ^(JFImageBrowserHandler *item) {
            [wself.actionSheet hideActionSheet];
            if (item.handleBlock) {
                item.handleBlock(wself.curImageIndex);
            }
        };
    }
    return _actionSheet;
}

@end







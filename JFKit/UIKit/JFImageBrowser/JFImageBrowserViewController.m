//
//  JFImageBrowserViewController.m
//  TestForTransition
//
//  Created by LiChong on 2017/12/25.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "JFImageBrowserViewController.h"
#import "JFAnimateTransition.h"
#import "UIImageView+WebCache.h"
#import "JFZoomImageView.h"
#import "JFImageBrowserActionView.h"
#import "JFIBButton.h"
#import "JFImageBrowserCell.h"
#import "JFMacro.h"
#import "JFHelper.h"

# pragma mark - [Class]图片浏览器
@interface JFImageBrowserViewController () <UIViewControllerTransitioningDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
// 图片组; NSArray<JFImageBrowserItem*>
@property (nonatomic, copy) NSArray<JFImageBrowserItem*>* imageList;
// 当前浏览序号
@property (nonatomic, assign) NSInteger curImageIndex;
// 回场图片索引
@property (nonatomic, assign) NSInteger dismissedImageIndex;
// 图片容器
@property (nonatomic, strong) UICollectionView* collectionView;
// 页码标签
@property (nonatomic, strong) UILabel* pageLabel;
// actionButton
@property (nonatomic, strong) JFIBButton* actionBtn;
//
@property (nonatomic, copy) NSArray<JFImageBrowserHandler*>* (^handleAfterLongpressed) (NSInteger atIndex);
@end

@implementation JFImageBrowserViewController

/// 动画转场显示图片浏览器;
/// 并将创建的图片浏览器对象返回;
/// @param fromVC  加载图片浏览器的界面视图控制器
/// @param imageList  图片组; NSArray<JFImageBrowserItem*>
/// @param startAtIndex  起始浏览图片的索引
/// @param handleAfterLongpressed  回调：从调用方获取长按事件的处理handles
+ (instancetype) jf_showFromVC:(UIViewController*)fromVC
                 withImageList:(NSArray<JFImageBrowserItem*>*)imageList
                  startAtIndex:(NSInteger)startAtIndex
        handleAfterLongpressed:(NSArray<JFImageBrowserHandler*>* (^) (NSInteger atIndex))handleAfterLongpressed
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
    imageBrowserVC.handleAfterLongpressed = handleAfterLongpressed;
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


# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFImageBrowserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFImageBrowserCell" forIndexPath:indexPath];
    JFImageBrowserItem* item = self.imageList[indexPath.row];
    [cell.imageView setImage:item.thumbnail];
    WeakSelf(wself);
    cell.imageView.tapGesEvent = ^(NSInteger numberOfTouches) {
        if (numberOfTouches == 1) {
            wself.dismissedImageIndex = indexPath.row;
            [wself dismissViewControllerAnimated:YES completion:nil];
        }
    };
    cell.imageView.longpressEvent = ^{
        [wself handleForImageAtCurrentIndex];
    };

    return cell;
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

- (void) handleForImageAtCurrentIndex {
    if (!self.handleAfterLongpressed) {
        return;
    }
    NSArray* handles = self.handleAfterLongpressed(self.curImageIndex);

    
    JFImageBrowserActionView* actionSheet = [[JFImageBrowserActionView alloc] initWithFrame:self.view.bounds
                                                             items:handles];
    __weak typeof(self) wself = self;
    __weak JFImageBrowserActionView* weakActionSheet = actionSheet;
    actionSheet.didSelectWithItem = ^(JFImageBrowserHandler *item) {
        [weakActionSheet hideActionSheet];
        if (item.handleBlock) {
            item.handleBlock(wself.curImageIndex);
        }
    };
    [self.view addSubview:actionSheet];
    [actionSheet showActionSheet];
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
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageLabel];
    [self.view addSubview:self.actionBtn];
    
    CGFloat centerYAction = [UIApplication sharedApplication].statusBarFrame.size.height + JFImageBrowserNavigationHeight * 0.5;
    CGSize labelSize = [self.pageLabel sizeThatFits:CGSizeZero];
    labelSize.width += 30;
    labelSize.height += 10;
    CGSize btnSize = [self.actionBtn sizeThatFits:CGSizeZero];
    btnSize.width += 10;
    btnSize.height += 6;
    self.pageLabel.frame = CGRectMake((JFSCREEN_WIDTH - labelSize.width) * 0.5,
                                      centerYAction - labelSize.height * 0.5,
                                      labelSize.width,
                                      labelSize.height);
    self.actionBtn.frame = CGRectMake(self.view.frame.size.width - 15 - btnSize.width,
                                      centerYAction - btnSize.height * 0.5,
                                      btnSize.width,
                                      btnSize.height);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.curImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - setter

- (void)setCurImageIndex:(NSInteger)curImageIndex {
    _curImageIndex = curImageIndex;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", curImageIndex+1, self.imageList.count];
}

# pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = YES;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(JFSCREEN_WIDTH, JFSCREEN_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:JFSCREEN_BOUNDS collectionViewLayout:layout];
        [_collectionView registerClass:[JFImageBrowserCell class] forCellWithReuseIdentifier:@"JFImageBrowserCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.canCancelContentTouches = NO;
        _collectionView.delaysContentTouches = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.font = [UIFont boldSystemFontOfSize:17];
        _pageLabel.textColor = UIColor.whiteColor;
        _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
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
        [_actionBtn addTarget:self action:@selector(handleForImageAtCurrentIndex) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end







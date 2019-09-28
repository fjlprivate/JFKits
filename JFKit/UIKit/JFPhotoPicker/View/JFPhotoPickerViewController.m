//
//  JFPhotoPickerViewController.m
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFPhotoPickerViewController.h"
#import "JFPhotoPickerCell.h"
#import "JFPhotoPickerViewModel.h"
#import "UIView+Extension.h"
#import "JFMacro.h"
#import "JFConstant.h"
#import "JFHelper.h"
#import "UINavigationBar+Awesome.h"
#import "JFImageBrowserViewController.h"
#import "JFPhotoPickerBrowserViewController.h"
#import "UIImage+JFExtension.h"

//#import "QQVideoPlayVC.h"


@interface JFPhotoPickerViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionViewFlowLayout* collectionLayout;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) JFPhotoPickerViewModel* viewModel;
@property (nonatomic, strong) UIBarButtonItem* nextBarBtn;
/**
 * 最大采集数量;(默认0)
 * 0: 无限个;
 * 当为1时,不显示选择标签;
 */
@property (nonatomic, assign) NSInteger maxPickerCount;


@property (nonatomic, weak) id<JFPhotoPickerViewControllerDelegate> delegate;

@end

@implementation JFPhotoPickerViewController

- (IBAction) clickedCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction) clickedNextStep:(id)sender {
    if ([self.viewModel jf_numberOfSelectedModels] <= 0) {
        return;
    }
    WeakSelf(wself);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.viewModel jf_requestAllSelectedMediasOnFinished:^(NSArray<JFPhotoPickerModel *> * _Nonnull models) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(jf_photoPicker:didPickedMedias:)]) {
            [wself.delegate jf_photoPicker:wself didPickedMedias:models];
        }
        [wself clickedCancel:nil];
        wself.navigationItem.rightBarButtonItem.enabled = YES;
    } orFailed:^(NSArray<JFPhotoPickerModel *> * _Nonnull models) {
        wself.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void) updateNextStepBtn {
    NSInteger count = [self.viewModel jf_numberOfSelectedModels];
    if (count > 0) {
        self.nextBarBtn.title = [NSString stringWithFormat:@"下一步(%ld)", count];
    } else {
        self.nextBarBtn.title = nil;
    }
}

# pragma mark - data source
- (void) loadDatas {
    WeakSelf(wself);
    [self.viewModel jf_requestMediasForType:self.mediaType onFinished:^(NSArray<JFPhotoPickerModel *> * _Nonnull models) {
        [wself.collectionView reloadData];
    }];
}

# pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.minLineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.minInteritemSpacing;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.sectionInsets;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfItems = self.numberOfItemsPerLine <= 0 ? 4 : self.numberOfItemsPerLine;
    CGFloat width = (JFSCREEN_WIDTH - self.sectionInsets.left - self.sectionInsets.right - self.minInteritemSpacing * (numberOfItems - 1)) / numberOfItems;
    return CGSizeMake(width, width);
}
# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel jf_numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel jf_numberOfRowsInSection:section];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFPhotoPickerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFPhotoPickerCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    JFPhotoPickerModel* model = [self.viewModel jf_modelForRowAtIndexPath:indexPath];
    cell.model = model;
    WeakSelf(wself);
    cell.didUpdateSelectState = ^(JFPhotoPickerCell * _Nonnull cell, JFPhotoPickerModel * _Nonnull model) {
        // 重置当前&所有的select相关属性
        [wself.viewModel jf_exchangeModelSelectedState:model];
        // 重置完毕就刷新
        [collectionView reloadData];
        // 更新下一步
        [wself updateNextStepBtn];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(wself);
    // 图片是浏览列表
    if (self.mediaType == PHAssetMediaTypeImage) {
        NSMutableArray* list = @[].mutableCopy;
        for (int i = 0; i < [self.viewModel jf_numberOfRowsInSection:0]; i++) {
            JFPhotoPickerModel* model = [self.viewModel jf_modelForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [list addObject:model];
        }
        JFPhotoPickerBrowserViewController* vc = [[JFPhotoPickerBrowserViewController alloc] initWithModels:list atStartIndex:indexPath.row];
        if (self.navigationController) {
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    // 视频只展示单个
    else {
        JFPhotoPickerModel* model = [self.viewModel jf_modelForRowAtIndexPath:indexPath];
        JFPhotoPickerCell* cell = (JFPhotoPickerCell*)[collectionView cellForItemAtIndexPath:indexPath];
        AVURLAsset* asset = model.originData;
//        if (asset) {
//            QQVideoPlayVC* vc = [QQVideoPlayVC videoPlayWithURL:asset.URL firstFrameImage:nil imageFrame:[cell convertRect:cell.bounds toView:self.view]];
//            [self presentViewController:vc animated:YES completion:nil];
//        } else {
//            [self.viewModel jf_requestOriginMediaAtIndex:indexPath.row onFinished:^(NSArray<JFPhotoPickerModel *> * _Nonnull models) {
//                AVURLAsset* iAsset = (AVURLAsset*)models.firstObject.originData;
//                QQVideoPlayVC* vc = [QQVideoPlayVC videoPlayWithURL:iAsset.URL firstFrameImage:nil imageFrame:[cell convertRect:cell.bounds toView:self.view]];
//                [wself presentViewController:vc animated:YES completion:nil];
//            } orFailed:^(NSArray<JFPhotoPickerModel *> * _Nonnull models) {
//
//            }];
//        }
    }
}


# pragma mark - life cycle

/**
 初始化;
 @param mediaType                           采集类型
 @param maxPickerCount                      最大采集数量
 @param delegate                            代理
 @return JFPhotoPickerViewController*
 */
- (instancetype) initWithMediaType:(PHAssetMediaType)mediaType
                    maxPickerCount:(NSInteger)maxPickerCount
                          delegate:(id<JFPhotoPickerViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.mediaType = mediaType;
        self.maxPickerCount = maxPickerCount;
        self.delegate = delegate;
        self.numberOfItemsPerLine = 4;
        self.minInteritemSpacing = 2;
        self.minLineSpacing = 2;
        self.sectionInsets = UIEdgeInsetsZero;
        self.bgColor = JFRGBAColor(0x0E0D1A, 1);
        self.navigationBarBgColor = JFRGBAColor(0x0E0D1A, 1);
        self.navigationBarTintColor = JFRGBAColor(0xffffff, 1);
        self.navigationCancelImageName = @"delete";

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.navigationItem.rightBarButtonItem = self.nextBarBtn;
    [self loadDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:self.navigationBarBgColor];
    self.navigationController.navigationBar.tintColor = self.navigationBarTintColor;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                                                    NSForegroundColorAttributeName:self.navigationBarTintColor
                                                                    };
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jf_kitImageWithName:self.navigationCancelImageName] style:UIBarButtonItemStylePlain target:self action:@selector(clickedCancel:)];
    }
}


# pragma mark - setter
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    if (!bgColor) {
        return;
    }
    self.view.backgroundColor = bgColor;
    self.collectionView.backgroundColor = bgColor;
    self.collectionView.backgroundView.backgroundColor = bgColor;
}

- (void)setMediaType:(PHAssetMediaType)mediaType {
    _mediaType = mediaType;
    if (mediaType == PHAssetMediaTypeUnknown) {
        self.title = @"全部";
    }
    else if (mediaType == PHAssetMediaTypeImage) {
        self.title = @"图片";
    }
    else if (mediaType == PHAssetMediaTypeVideo) {
        self.title = @"视频";
    }
}
- (void)setMaxPickerCount:(NSInteger)maxPickerCount {
    _maxPickerCount = maxPickerCount;
    self.viewModel.maxPickerCount = maxPickerCount;
}

# pragma mark - getter
- (UICollectionViewFlowLayout *)collectionLayout {
    if (!_collectionLayout) {
        _collectionLayout = [UICollectionViewFlowLayout new];
        _collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _collectionLayout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
        [_collectionView registerClass:[JFPhotoPickerCell class] forCellWithReuseIdentifier:@"JFPhotoPickerCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (JFPhotoPickerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [JFPhotoPickerViewModel new];
    }
    return _viewModel;
}
- (UIBarButtonItem *)nextBarBtn {
    if (!_nextBarBtn) {
        _nextBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickedNextStep:)];
        NSDictionary* normalDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:JFRGBAColor(0xFE3919, 1)};
        NSDictionary* selectDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:JFRGBAColor(0xFE3919, 0.5)};
        [_nextBarBtn setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        [_nextBarBtn setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    }
    return _nextBarBtn;
}


@end

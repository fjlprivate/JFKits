//
//  JFPhotoPickerBrowserViewController.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/1.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFPhotoPickerBrowserViewController.h"
#import "JFPPBCell.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "JFHelper.h"
#import "JFPhotoPickerModel.h"
#import "JFPhotoPickerViewModel.h"

@interface JFPhotoPickerBrowserViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* models;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) PHImageManager* imageMan;
@end

@implementation JFPhotoPickerBrowserViewController

- (void) requestOriginDataAtIndexPath:(NSIndexPath*)indexPath {
    WeakSelf(wself);
    JFPhotoPickerModel* model = self.models[indexPath.row];
    if (model.originData) {
        return;
    }
    NSString* path = [JFPhotoPickerViewModel mediaPathForModel:model];
    // 图片
    if (model.asset.mediaType == PHAssetMediaTypeImage) {
//        PHImageRequestOptions* imageOp = [PHImageRequestOptions new];
//        imageOp.networkAccessAllowed = YES;
//        imageOp.synchronous = YES;
//        imageOp.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [wself.imageMan requestImageDataForAsset:model.asset
//                                             options:imageOp
//                                       resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                                           [imageData writeToFile:path options:NSDataWritingAtomic error:NULL];
//                                           model.originData = path;
//                                           dispatch_async(dispatch_get_main_queue(), ^{
//                                               [wself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                                           });
//                                       }];
//        });
    }
    // 视频
    else if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions* videoOp = [PHVideoRequestOptions new];
        videoOp.networkAccessAllowed = YES;
        videoOp.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [wself.imageMan requestAVAssetForVideo:model.asset
                                           options:videoOp
                                     resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                         model.originData = asset;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [wself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                         });
                                     }];
        });
    }
}

- (void) gobackVC {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.firstObject != self) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.curIndex = scrollView.contentOffset.x / scrollView.width;
}

# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(wself);
    JFPPBCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFPPBCell" forIndexPath:indexPath];
    JFPhotoPickerModel* model = self.models[indexPath.row];
    cell.model = model;
    if (!model.originData) {
        [self requestOriginDataAtIndexPath:indexPath];
    }
    cell.handleWithTap = ^(NSInteger numberOfTouchs) {
        [wself gobackVC];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


# pragma mark - life cycle
- (instancetype)initWithModels:(NSArray *)models atStartIndex:(NSInteger)startIndex {
    self = [super init];
    if (self) {
        self.models = models;
        self.startIndex = startIndex;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JFRGBAColor(0x0E0D1A, 1);
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.view.mas_top).offset(JFStatusBarHeight + JFNavigationBarHeight * 0.5);
    }];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.startIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.curIndex = self.startIndex;
}

# pragma mark - setter
- (void)setCurIndex:(NSInteger)curIndex {
    _curIndex = curIndex;
    if (curIndex < 0) {
        curIndex = 0;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", curIndex, self.models.count];
}
# pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.itemSize = JFSCREEN_BOUNDS.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:JFSCREEN_BOUNDS collectionViewLayout:layout];
        [_collectionView registerClass:[JFPPBCell class] forCellWithReuseIdentifier:@"JFPPBCell"];
        _collectionView.backgroundColor = JFRGBAColor(0x0E0D1A, 1);
        _collectionView.backgroundView.backgroundColor = JFRGBAColor(0x0E0D1A, 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}
- (PHImageManager *)imageMan {
    if (!_imageMan) {
        _imageMan = [PHImageManager defaultManager];
    }
    return _imageMan;
}

@end

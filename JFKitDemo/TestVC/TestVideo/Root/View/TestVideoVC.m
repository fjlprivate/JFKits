//
//  TestVideoVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/25.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestVideoVC.h"
#import "TestVideoCaptureVC.h"
#import "TestVideoCell.h"
#import "TestVideoAddCell.h"
#import "TestVideoDisplayVC.h"

@interface TestVideoVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* listModels;
@end

@implementation TestVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(JFNaviStatusBarHeight, 0, JFSCREEN_BOTTOM_INSET, 0));
    }];
}

# pragma mark - action

- (void) addVideo {
    TestVideoCaptureVC* vc = [TestVideoCaptureVC new];
    WeakSelf(wself);
    vc.callBackCapturedImage = ^(UIImage * _Nonnull image) {
        TestVideoModel* model = [[TestVideoModel alloc] init];
        model.type = TestVideoModelTypeImage;
        model.image = image;
        [wself.listModels addObject:model];
        [wself.collectionView reloadData];
    };
    vc.callBackCapturedVideo = ^(NSURL * _Nonnull videoUrl, UIImage * _Nonnull thumbnail) {
        TestVideoModel* model = [[TestVideoModel alloc] init];
        model.type = TestVideoModelTypeVideo;
        model.videoUrl = videoUrl;
        model.thumbnail = thumbnail;
        [wself.listModels addObject:model];
        [wself.collectionView reloadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listModels.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.listModels.count) {
        TestVideoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestVideoCell" forIndexPath:indexPath];
        cell.cellModel = self.listModels[indexPath.row];
        return cell;
    } else {
        TestVideoAddCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestVideoAddCell" forIndexPath:indexPath];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.listModels.count) {
        TestVideoModel* model = self.listModels[indexPath.row];
        if (model.type == TestVideoModelTypeVideo) {
            TestVideoDisplayVC* vc = [TestVideoDisplayVC new];
            vc.videoUrl = model.videoUrl;
            [self presentViewController:vc animated:YES completion:nil];
        }
    } else {
        [self addVideo];
    }
}


# pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(72, 72);
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[TestVideoCell class] forCellWithReuseIdentifier:@"TestVideoCell"];
        [_collectionView registerClass:[TestVideoAddCell class] forCellWithReuseIdentifier:@"TestVideoAddCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (NSMutableArray *)listModels {
    if (!_listModels) {
        _listModels = @[].mutableCopy;
    }
    return _listModels;
}
@end

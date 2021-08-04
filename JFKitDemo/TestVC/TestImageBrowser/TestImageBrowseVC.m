//
//  TestImageBrowseVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/22.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestImageBrowseVC.h"
#import "TestImageBrowserCell.h"
#import <Masonry.h>
#import <TZImagePickerController.h>
#import "JFImageBrowserViewController.h"
#import "TestImageBrowserPreviewCell.h"


@interface TestImageBrowseVC () <TZImagePickerControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* imagesSelected;
@property (nonatomic, assign) int type; // 1: 普通 2:缩放
@end

@implementation TestImageBrowseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(clickSelectBarItem)];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(JFNaviStatusBarHeight, 0, 0, 0));
    }];
}

- (void) clickSelectBarItem {
    TZImagePickerController* picker = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
    picker.allowPickingVideo = NO;
    picker.allowTakeVideo = NO;
    [self presentViewController:picker animated:YES completion:^{
            
    }];
}


# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesSelected.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        TestImageBrowserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestImageBrowserCell" forIndexPath:indexPath];
        cell.imageView.image = self.imagesSelected[indexPath.row];
        
        return cell;
    } else {
        TestImageBrowserPreviewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestImageBrowserPreviewCell" forIndexPath:indexPath];
        [cell.imageView setImage:self.imagesSelected[indexPath.row]];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 2) {
        return;
    }
    NSMutableArray* images = @[].mutableCopy;
//    TestImageBrowserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestImageBrowserCell" forIndexPath:indexPath];
//    CGRect fromRect = [cell convertRect:cell.bounds toView:self.view];
//    fromRect.origin.y += JFNaviStatusBarHeight;
    for (int i = 0; i < self.imagesSelected.count; i++) {
        UIImage* image = self.imagesSelected[i];
        JFImageBrowserItem* item = [JFImageBrowserItem jf_itemWithMediaType:JFMediaTypeNormalImage thumbnail:image mediaDisplaying:image mediaOrigin:image originFrame:[self cellFrameAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] cornerRadius:0 mediaSize:image.size originContentMode:UIViewContentModeScaleAspectFill];
        [images addObject:item];
    }
    [JFImageBrowserViewController jf_showFromVC:self withImageList:images startAtIndex:indexPath.row handleAfterLongpressed:^NSArray<JFImageBrowserHandler *> *(NSInteger atIndex) {
        NSMutableArray* handles = @[].mutableCopy;
        [handles addObject:[JFImageBrowserHandler jf_handlerWithTitle:@"取消" type:JFIBHandlerTypeCancel handle:^(NSInteger index) {
                    
        }]];
        [handles addObject:[JFImageBrowserHandler jf_handlerWithTitle:@"保存到相册" type:JFIBHandlerTypeDefault handle:^(NSInteger index) {
                    
        }]];

        return handles;
    }];
}

- (CGRect) cellFrameAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect fromRect = [cell convertRect:cell.bounds toView:self.view];
    NSLog(@"++++++ cellFrameAtIndexPath[%ld]:[%@]", indexPath.row, NSStringFromCGRect(fromRect));
//    fromRect.origin.y += JFNaviStatusBarHeight;
    return fromRect;
}


# pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.imagesSelected removeAllObjects];
    [self.imagesSelected addObjectsFromArray:photos];
    [self.collectionView reloadData];
}




# pragma mark - getter

- (NSMutableArray *)imagesSelected {
    if (!_imagesSelected) {
        _imagesSelected = @[].mutableCopy;
    }
    return _imagesSelected;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        if (self.type == 1) {
            layout.itemSize = CGSizeMake(80, 80);
            layout.minimumLineSpacing = 10;
            layout.minimumInteritemSpacing = 10;
            layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        } else {
            layout.itemSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height - JFNaviStatusBarHeight);
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
            layout.sectionInset = UIEdgeInsetsZero;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[TestImageBrowserCell class] forCellWithReuseIdentifier:@"TestImageBrowserCell"];
        [_collectionView registerClass:[TestImageBrowserPreviewCell class] forCellWithReuseIdentifier:@"TestImageBrowserPreviewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = JFRGBAColor(0xf0f0f0, 1);
        _collectionView.backgroundView.backgroundColor = JFRGBAColor(0xf0f0f0, 1);
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

@end

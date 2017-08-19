//
//  JFImageBrowser.m
//  JFKitDemo
//
//  Created by johnny feng on 2017/8/16.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFImageBrowser.h"
#import "UIImageView+WebCache.h"
#import "JFMacro.h"


/**
 cell 自定义
 */
@interface JFIBImageCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation JFIBImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [UIImageView new];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end



@interface JFImageBrowser () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* imageBrowser;
@property (nonatomic, weak) UIViewController* fromVC;
@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIButton* cancelBtn;
@end

@implementation JFImageBrowser

# pragma mask 1 funcs

- (void)show {
    __weak typeof(self) wself = self;
    [self.fromVC presentViewController:self animated:YES completion:^{
        [wself.imageBrowser reloadData];
    }];
}

- (void)hide {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)clickedCancelBtn:(id)sender {
    [self hide];
}

# pragma mask 2 tools

# pragma mask 2 UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfSections)]) {
        number = [self.delegate numberOfImageSections];
    }
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFIBImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFIBImageCell" forIndexPath:indexPath];
    id imageData = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageDataAtSection:)]) {
        imageData = [self.delegate imageDataAtSection:indexPath.row];
    }
    if (imageData) {
        // UIImage
        if ([imageData isKindOfClass:[UIImage class]]) {
            // 直接加载
            cell.imageView.image = imageData;
        }
        // NSURL
        else if ([imageData isKindOfClass:[NSURL class]]) {
            // 使用SD方法加载
            [cell.imageView sd_setImageWithURL:imageData];
        }
    }
    return cell;
}

# pragma mask 3 life cycle

- (instancetype)initWithFromVC:(UIViewController *)fromVC {
    self = [super init];
    if (self) {
        self.fromVC = fromVC;
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.imageBrowser = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.imageBrowser.delegate = self;
        self.imageBrowser.dataSource = self;
        [self.imageBrowser registerClass:[JFIBImageCell class] forCellWithReuseIdentifier:@"JFIBImageCell"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageBrowser.frame = self.view.bounds;
    [self.view addSubview:self.imageBrowser];
    
    [self.view addSubview:self.backgroundImageView];
    
    self.cancelBtn.frame = CGRectMake(10, 10, 30, 30);
    [self.view addSubview:self.cancelBtn];
    
}


# pragma mask 4 getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:JFSCREEN_BOUNDS];
    }
    return _backgroundImageView;
}

- (UIImage *)backgroundImage {
    if (!_backgroundImage) {
        UIGraphicsBeginImageContextWithOptions(JFSCREEN_BOUNDS.size, NO, JFSCREEN_SCALE);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextFillPath(context);
        _backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _backgroundImage;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setImage:[UIImage imageNamed:@"selectedBlue"] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

@end

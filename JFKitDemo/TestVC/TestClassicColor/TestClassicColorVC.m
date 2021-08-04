//
//  TestClassicColorVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/25.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestClassicColorVC.h"
@interface TestClassicColorCell : UICollectionViewCell
@property (nonatomic, strong) UIView* vColor;
@property (nonatomic, strong) UILabel* labName;
@property (nonatomic, strong) UILabel* labValue;
@end

@interface TestClassicColorVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* colorList;
@end

@implementation TestClassicColorVC

- (NSArray *)colorList {
    if (!_colorList) {
        _colorList = @[
            @{@"青黛":@{
                      @"name":@"#45465e",
                      @"value":@(0x45465e)
            }},
            @{@"延维":@{
                      @"name":@"#4a4b9d",
                      @"value":@(0x4a4b9d)
            }},
            @{@"青冥":@{
                      @"name":@"#3271ae",
                      @"value":@(0x3271ae)
            }},
            @{@"窃蓝":@{
                      @"name":@"#88abda",
                      @"value":@(0x88abda)
            }},
            @{@"苍莨":@{
                      @"name":@"#99bcac",
                      @"value":@(0x99bcac)
            }},
            @{@"苍葭":@{
                      @"name":@"#a8bf8f",
                      @"value":@(0xa8bf8f)
            }},
            @{@"翠绿":@{
                      @"name":@"#02786a",
                      @"value":@(0x02786a)
            }},
            @{@"石绿":@{
                      @"name":@"#206864",
                      @"value":@(0x206864)
            }},
            @{@"丹蘮":@{
                      @"name":@"#e60012",
                      @"value":@(0xe60012)
            }},
            @{@"朱砂红":@{
                      @"name":@"#eb4b17",
                      @"value":@(0xeb4b17)
            }},
            @{@"杨妃":@{
                      @"name":@"#f091a0",
                      @"value":@(0xf091a0)
            }},
            @{@"十样锦":@{
                      @"name":@"#f8c6b5",
                      @"value":@(0xf8c6b5)
            }},
            @{@"如梦令":@{
                      @"name":@"#ddbb99",
                      @"value":@(0xddbb99)
            }},
            @{@"鹅黄":@{
                      @"name":@"#f2c867",
                      @"value":@(0xf2c867)
            }},
            @{@"黄栗留":@{
                      @"name":@"#fec85e",
                      @"value":@(0xfec85e)
            }},
            @{@"栀子":@{
                      @"name":@"#fac015",
                      @"value":@(0xfac015)
            }},
        ];
    }
    return _colorList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"古典色";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(JFNaviStatusBarHeight, 0, 0, 0));
    }];
    
}


# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestClassicColorCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestClassicColorCell" forIndexPath:indexPath];
    NSString* key = [[self.colorList[indexPath.row] allKeys] firstObject];
    NSDictionary* node = [[self.colorList[indexPath.row] allValues] firstObject];
    cell.vColor.backgroundColor = JFRGBAColor([node[@"value"] integerValue], 1);
    cell.labName.text = key;
    cell.labValue.text = node[@"name"];
    cell.labName.textColor = cell.labValue.textColor = UIColor.whiteColor;
    return cell;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        NSInteger count = 8;
        CGFloat width = (JFSCREEN_WIDTH - layout.sectionInset.left - layout.sectionInset.right) / count;
        layout.itemSize = CGSizeMake(width, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[TestClassicColorCell class] forCellWithReuseIdentifier:@"TestClassicColorCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
    }
    return _collectionView;
}

@end




@implementation TestClassicColorCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.vColor];
        [self.contentView addSubview:self.labName];
        [self.contentView addSubview:self.labValue];
        [self.vColor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
        }];
        [self.labValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.labName.mas_bottom).offset(0);
        }];

    }
    return self;
}

- (UIView *)vColor {
    if (!_vColor) {
        _vColor = [UIView new];
    }
    return _vColor;
}
- (UILabel *)labName {
    if (!_labName) {
        _labName = [UILabel new];
        _labName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _labName.textAlignment = NSTextAlignmentCenter;
    }
    return _labName;
}
- (UILabel *)labValue {
    if (!_labValue) {
        _labValue = [UILabel new];
        _labValue.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _labValue.textAlignment = NSTextAlignmentCenter;
    }
    return _labValue;
}

@end

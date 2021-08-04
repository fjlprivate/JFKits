//
//  TestCollectionVC.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/9.
//

#import "TestCollectionVC.h"
#import "DecorationLayout.h"
#import "DecorationView.h"
#import "NormalCollectionCell.h"
#import "DecorationHeaderView.h"

@interface TestCollectionVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@end

@implementation TestCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
}


# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NormalCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCollectionCell" forIndexPath:indexPath];
    cell.labContent.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DecorationHeaderView* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DecorationHeaderView" forIndexPath:indexPath];
        header.labContent.text = [NSString stringWithFormat:@"头%ld", indexPath.section];
        return header;
    } else {
        DecorationHeaderView* footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"DecorationHeaderView" forIndexPath:indexPath];
        footer.labContent.text = [NSString stringWithFormat:@"尾%ld", indexPath.section];
        return footer;
    }
}




- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DecorationLayout* layout = [[DecorationLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(100, 40);
        layout.footerReferenceSize = CGSizeMake(100, 40);
        layout.sectionInset = UIEdgeInsetsMake(15, 25, 0, 25);
        layout.decorationInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.decorationClass = [DecorationView class];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[NormalCollectionCell class] forCellWithReuseIdentifier:@"NormalCollectionCell"];
        [_collectionView registerClass:[DecorationHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DecorationHeaderView"];
        [_collectionView registerClass:[DecorationHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"DecorationHeaderView"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        _collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    }
    return _collectionView;
}

@end

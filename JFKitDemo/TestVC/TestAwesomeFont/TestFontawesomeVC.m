//
//  TestFontawesomeVC.m
//  JFTools
//
//  Created by fjl on 2021/5/17.
//

#import "TestFontawesomeVC.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "DecorationLayout.h"
#import "DecorationView.h"
#import "TestFontawesomeViewModel.h"
#import "TestFAMoveInputView.h"


@interface TestFontAweCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UILabel* labDesc;
@property (nonatomic, strong) UILabel* labOrder;
@end

@interface TestFontAweHeader : UICollectionReusableView
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UILabel* labelOrder;
@end


@interface TestFontawesomeVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) TestFontawesomeViewModel* viewModel;
@property (nonatomic, assign) BOOL isEditingDatas;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UILongPressGestureRecognizer* longpressGes;
@property (nonatomic, strong) UIBarButtonItem* cancelBarItem;
@property (nonatomic, strong) UIBarButtonItem* editBarItem;
@property (nonatomic, strong) UIBarButtonItem* moveBarItem;
@property (nonatomic, strong) UIButton* savingBtn;
@end

@implementation TestFontawesomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = @[self.editBarItem,self.moveBarItem];
    self.navigationItem.titleView = self.savingBtn;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void) updateNaviBarItems {
    [self.editBarItem setTitle:self.isEditingDatas?@"完成":@"编辑"];
    self.navigationItem.rightBarButtonItems = self.isEditingDatas?@[self.cancelBarItem,self.editBarItem]:@[self.editBarItem,self.moveBarItem];
}

- (IBAction) clickedEditingBarItem:(UIBarButtonItem*)sender {
    self.isEditingDatas = !self.isEditingDatas;
    self.longpressGes.enabled = self.isEditingDatas;
    [self updateNaviBarItems];
    if (!self.isEditingDatas) {
        [self.viewModel endMoving];
    }
    [self.collectionView reloadData];
}
- (IBAction) clickedCancelBarItem:(UIBarButtonItem*)sender {
    self.isEditingDatas = NO;
    [self updateNaviBarItems];
    [self.viewModel cancelMoving];
    [self.collectionView reloadData];
}
- (IBAction) clickedSavingBtn:(id)sender {
    [self.viewModel saving];
}

- (IBAction) clickedMoveBarItem:(UIBarButtonItem*)sender {
    [self showInputView];
}

- (void) showInputView {
    TestFAMoveInputView* inputView = [[TestFAMoveInputView alloc] initWithAnimateStyle:JFPresenterAnimateStyleFade];
    inputView.hideWhenClickOutContent = YES;
    [inputView showInView:self.view];
    inputView.sureBlock = ^(NSIndexPath * _Nonnull fromId, NSIndexPath * _Nonnull toId) {
        [self.collectionView moveItemAtIndexPath:fromId toIndexPath:toId];
        [self.viewModel moveItemFromIndexPath:fromId toIndexPath:toId];
        [self.viewModel endMoving];
    };
}

# pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TestFontAweHeader* header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TestFontAweHeader" forIndexPath:indexPath];
    header.label.text = [self.viewModel titleForSection:indexPath.section];
    header.labelOrder.text = [NSString stringWithFormat:@"%ld", indexPath.section];
    return header;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestFontAweCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestFontAweCell" forIndexPath:indexPath];
    cell.label.text = [NSString fontAwesomeIconStringForEnum:[self.viewModel valueForItemAtIndexPath:indexPath]];
    cell.labDesc.text = [self.viewModel nameForItemAtIndexPath:indexPath];
    cell.labOrder.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.isEditing = self.isEditingDatas;
    return cell;
}

# pragma mark - 移动

- (void) handleWithLongpressGes:(UILongPressGestureRecognizer*)longpressGes {
    CGPoint location = [longpressGes locationInView:self.collectionView];
    switch (longpressGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:location];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;

        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.isEditingDatas;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.viewModel moveItemFromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    [collectionView reloadData];
}


# pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DecorationLayout* layout = [[DecorationLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(15, 20, 0, 20);
        layout.decorationInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.itemSize = CGSizeMake(60, 60);
        layout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 50);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.decorationClass = [DecorationView class];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[TestFontAweCell class] forCellWithReuseIdentifier:@"TestFontAweCell"];
        [_collectionView registerClass:[TestFontAweHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TestFontAweHeader"];
        [_collectionView registerClass:[TestFontAweHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TestFontAweHeader"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
        [_collectionView addGestureRecognizer:self.longpressGes];
    }
    return _collectionView;
}
- (TestFontawesomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TestFontawesomeViewModel alloc] init];
    }
    return _viewModel;
}

- (UILongPressGestureRecognizer *)longpressGes {
    if (!_longpressGes) {
        _longpressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithLongpressGes:)];
    }
    return _longpressGes;
}
- (UIBarButtonItem *)cancelBarItem {
    if (!_cancelBarItem) {
        _cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickedCancelBarItem:)];
    }
    return _cancelBarItem;
}
- (UIBarButtonItem *)editBarItem {
    if (!_editBarItem) {
        _editBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickedEditingBarItem:)];
    }
    return _editBarItem;
}
- (UIButton *)savingBtn {
    if (!_savingBtn) {
        _savingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [_savingBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_savingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_savingBtn setTitleColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateHighlighted];
        [_savingBtn addTarget:self action:@selector(clickedSavingBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _savingBtn;
}
- (UIBarButtonItem *)moveBarItem {
    if (!_moveBarItem) {
        _moveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"移动" style:UIBarButtonItemStylePlain target:self action:@selector(clickedMoveBarItem:)];
    }
    return _moveBarItem;
}


@end


@interface TestFontAweCell()
@property (nonatomic, strong) UIView* vBg;
@end
@implementation TestFontAweCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        [self.contentView addSubview:self.vBg];
        [self.vBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.labDesc];
        [self.contentView addSubview:self.labOrder];

        [self.labOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(3);
        }];
        [self.labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-5);
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.equalTo(self.labDesc.mas_top).offset(-5);
        }];
    }
    return self;
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    self.vBg.layer.borderWidth = isEditing?1:0;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont fontAwesomeFontOfSize:24];
        _label.textColor = UIColor.blackColor;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (UILabel *)labDesc {
    if (!_labDesc) {
        _labDesc = [UILabel new];
        _labDesc.font = [UIFont systemFontOfSize:12];
        _labDesc.textColor = UIColor.grayColor;
        _labDesc.textAlignment = NSTextAlignmentCenter;
        _labDesc.adjustsFontSizeToFitWidth = YES;
    }
    return _labDesc;
}
- (UILabel *)labOrder {
    if (!_labOrder) {
        _labOrder = [UILabel new];
        _labOrder.font = [UIFont systemFontOfSize:8];
        _labOrder.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _labOrder;
}
- (UIView *)vBg {
    if (!_vBg) {
        _vBg = [UIView new];
        _vBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _vBg.layer.masksToBounds = YES;
        _vBg.layer.cornerRadius = 5;
        _vBg.layer.borderWidth = 0;
        _vBg.layer.borderColor = UIColor.greenColor.CGColor;
    }
    return _vBg;
}
@end


@implementation TestFontAweHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self addSubview:self.label];
        [self addSubview:self.labelOrder];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        [self.labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.label.mas_right).offset(10);
        }];
    }
    return self;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
        _label.textColor = UIColor.blackColor;
    }
    return _label;
}
- (UILabel *)labelOrder {
    if (!_labelOrder) {
        _labelOrder = [UILabel new];
        _labelOrder.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _labelOrder.textColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _labelOrder;
}

@end

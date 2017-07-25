//
//  TestForImageStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/21.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestForImageStorage.h"
#import "JFKit.h"



@interface TImageStorageCell : UITableViewCell
@property (nonatomic, strong) JFLayout* layout;
@property (nonatomic, strong) JFAsyncDisplayView* asyncView;
@end

@implementation TImageStorageCell

- (void)setLayout:(JFLayout *)layout {
    _layout = layout;
    self.asyncView.layout = layout;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.asyncView = [JFAsyncDisplayView new];
        [self.contentView addSubview:self.asyncView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncView.frame = self.contentView.frame;
}



@end


@interface TTabelView : UITableView

@end
@implementation TTabelView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delaysContentTouches = YES;
    }
    return self;
}


@end



@interface TestForImageStorage () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) JFAsyncDisplayView* asyncView;
@property (nonatomic, strong) JFButton* asyncBtn;

@property (nonatomic, strong) TTabelView* tableView;
@property (nonatomic, strong) NSArray* dataSource;

@end

@implementation TestForImageStorage


# pragma mask 2

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFLayout* layout = [self.dataSource objectAtIndex:indexPath.row];
    return layout.bottom + 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TImageStorageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TImageStorageCell"];
    if (!cell) {
        cell = [[TImageStorageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TImageStorageCell"];
    }
    cell.layout = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}



# pragma mask 3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.view addSubview:self.asyncView];
    [self.view addSubview:self.asyncBtn];
    self.tableView.top = 64;
    self.tableView.left = 0;
    self.tableView.right = JFSCREEN_WIDTH;
    self.tableView.bottom = self.asyncBtn.top;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


# pragma mask 4 getter

- (TTabelView *)tableView {
    if (!_tableView) {
        _tableView = [[TTabelView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (JFAsyncDisplayView *)asyncView {
    if (!_asyncView) {
        _asyncView = [[JFAsyncDisplayView alloc] init];
        _asyncView.top = 64 + 14;
        _asyncView.left = 15;
        _asyncView.right = JFSCREEN_WIDTH - 15;
        _asyncView.bottom = self.asyncBtn.top - 15;
//        _asyncView.backgroundColor = JFHexColor(0xeeeeee, 1);
    }
    return _asyncView;
}

- (void) makeDatasources {
    JFLayout* layout = [JFLayout new];
    JFImageStorage* img1 = [JFImageStorage jf_imageStroageWithContents:[UIImage imageNamed:@"headWoman"] frame:CGRectMake(10, 10, 50, 50)];
    img1.cornerRadius = CGSizeMake(25, 25);
    img1.backgroundColor = JFHexColor(0xffffff, 1);
    img1.borderColor = JFHexColor(0xea6956, 1);
    img1.borderWidth = 2;
    [layout addStorage:img1];
    
    JFTextStorage* t1 = [JFTextStorage jf_textStorageWithText:@"我是一个傻妹儿" frame:CGRectMake(10 + img1.right, 10 + img1.top, 1000, 50) insets:UIEdgeInsetsZero];
    t1.textColor = JFHexColor(0x27384b, 1);
    t1.textFont = [UIFont boldSystemFontOfSize:14];
    [t1 addLinkWithData:@"傻妹" textSelectedColor:JFHexColor(0x27384b, 0.5) backSelectedColor:JFHexColor(0, 0.1) atRange:NSMakeRange(4, 2)];
    t1.debugMode = NO;
    [layout addStorage:t1];
    
    NSString* tt2 =@"来自: iphone6 Plus";
    JFTextStorage* t2 = [JFTextStorage jf_textStorageWithText:tt2 frame:CGRectMake(t1.left, t1.bottom + 5, 1000, 50) insets:UIEdgeInsetsZero];
    [t2 setTextFont:[UIFont systemFontOfSize:13] atRange:[tt2 rangeOfString:@"来自: "]];
    NSRange fromRange = [tt2 rangeOfString:@"iphone6 Plus"];
    [t2 setTextFont:[UIFont boldSystemFontOfSize:14] atRange:fromRange];
    [t2 setTextColor:JFHexColor(0x999999, 1) atRange:[tt2 rangeOfString:@"来自: "]];
    [t2 setTextColor:JFHexColor(0xEA6956, 1) atRange:fromRange];
    [t2 addLinkWithData:@"from" textSelectedColor:JFHexColor(0xEA6956, 0.9) backSelectedColor:JFHexColor(0xeeeeee, 1) atRange:fromRange];
    t2.debugMode = NO;
    [layout addStorage:t2];
    
    
    CGFloat imageWidth = 140;
    CGFloat imageHeight = imageWidth * 1136.f/640.f;
    JFImageStorage* img2 = [JFImageStorage jf_imageStroageWithContents:[NSURL URLWithString:@"http://ww2.sinaimg.cn/wap720/6fc6f04egw1evuciu6zqlj20hs0vkab3.jpg"]
                                                                 frame:CGRectMake(10, img1.bottom + 10, imageWidth, imageHeight)];
    img2.placeHolder = [UIImage imageNamed:@"noData"];
    if (img2) {
        [layout addStorage:img2];
    }
    
    _dataSource = @[layout,layout,layout,layout,layout,layout,layout,layout,layout,layout,layout,layout];
}


- (JFButton *)asyncBtn {
    if (!_asyncBtn) {
        _asyncBtn = [JFButton new];
        _asyncBtn.normalTitle = @"异步绘制";
        _asyncBtn.normalTitleColor = JFHexColor(0xffffff, 1);
        _asyncBtn.highLightTitleColor = JFHexColor(0xffffff, 0.5);
        _asyncBtn.backgroundColor = JFHexColor(0x00a1dc, 1);
        _asyncBtn.bottom = JFSCREEN_HEIGHT;
        _asyncBtn.left = 0;
        _asyncBtn.right = JFSCREEN_WIDTH;
        _asyncBtn.top = _asyncBtn.bottom - 44;
        __weak typeof(self) wself = self;
        _asyncBtn.didTouchedUpInside = ^{
            [wself makeDatasources];
            [wself.tableView reloadData];
        };
    }
    return _asyncBtn;
}


@end

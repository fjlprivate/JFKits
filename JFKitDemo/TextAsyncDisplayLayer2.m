//
//  TextAsyncDisplayLayer2.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/11.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TextAsyncDisplayLayer2.h"
#import "AsyncDView.h"
#import "JFKit.h"
#import "YYFPSLabel.h"

@interface TTCell : UITableViewCell
@property (nonatomic, strong) AsyncDView* dview;
@end

@implementation TTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.dview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dview.frame = self.contentView.frame;
    [self.dview.layer setNeedsDisplay];
}

- (AsyncDView *)dview {
    if (!_dview) {
        _dview = [[AsyncDView alloc] init];
    }return _dview;
}

@end







@interface TextAsyncDisplayLayer2 () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL asynchronously;

@end

@implementation TextAsyncDisplayLayer2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.asynchronously = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.left = 0;
    self.tableView.top = 64;
    self.tableView.right = JFSCREEN_WIDTH;
    self.tableView.bottom = JFSCREEN_HEIGHT;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    YYFPSLabel* fpsLabel = [[YYFPSLabel alloc] init];
    fpsLabel.frame = CGRectMake(100, 100, 60, 30);
    [self.view addSubview:fpsLabel];
    
    
    UISwitch* swith = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [swith addTarget:self action:@selector(switchingAsync:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:swith]];
}

- (IBAction) switchingAsync:(UISwitch*)sender {
    self.asynchronously = !self.asynchronously;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ttcel"];
    if (!cell) {
        cell = [[TTCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ttcel"];
    }
    cell.dview.asynchronously = self.asynchronously;
    return cell;
}



@end

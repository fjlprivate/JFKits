//
//  RootViewController.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/8.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "RootViewController.h"
#import "JFKit.h"
#import <Masonry.h>

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* functions;
@end

@implementation RootViewController

# pragma mark - getter

- (NSArray *)functions {
    if (!_functions) {
        _functions = @[
            @{@"title":@"异步图文混排",
              @"detail":@"TextAsyncViewViewController" // TestAsyncView
            },
            @{@"title":@"JFAlertView",
              @"detail":@"TestAlertVC"
            },
            @{@"title":@"JFSegmentView",
              @"detail":@"TestSegmentVC"
            },
            @{@"title":@"异步绘制",
              @"detail":@"TestAsyncDrawVC"
            },
            @{@"title":@"图片预览",
              @"detail":@"TestImageBrowseVC"
            },
            @{
                @"title":@"图片捏合缩放",
                @"detail":@"TestScaleImageVC"
            },
            @{
                @"title":@"FontAwesome",
                @"detail":@"TestFontawesomeVC"
            },
            @{
                @"title":@"自定义Decoration",
                @"detail":@"TestCollectionVC"
            },
            @{
                @"title":@"Presenter",
                @"detail":@"TestPresenterVC"
            },
            @{
                @"title":@"视频拍摄、播放",
                @"detail":@"TestVideoVC"
            },
            @{
                @"title":@"古典色",
                @"detail":@"TestClassicColorVC"
            },
            @{
                @"title":@"制作icon",
                @"detail":@"MakeIconVC"
            },
        ];
    }
    return _functions;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JFKits";
    // 功能列表
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(JFNaviStatusBarHeight);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.contentView.backgroundColor = JFColorWhite;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [self.functions[indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [self.functions[indexPath.row] objectForKey:@"detail"];
    cell.textLabel.textColor = JFRGBAColor(JFColorQingDai, 1);
    cell.detailTextLabel.textColor = JFRGBAColor(JFColorCangJia, 1);
//    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* vcName = [self.functions[indexPath.row] objectForKey:@"detail"];
    UIViewController* vc = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

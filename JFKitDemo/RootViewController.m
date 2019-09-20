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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    // 轮播图
    JFCycleImageView* cycleImageVIew = [JFCycleImageView new];
    cycleImageVIew.imageList = @[[NSURL URLWithString:@"http://10.0.0.21:800/xiangyu/20171211/e5a00da7b28b4ad28d0ed5dfffe39c68.jpg"],
                                 [NSURL URLWithString:@"http://10.0.0.21:800/xiangyu/20171211/df4dc6a1c4cd4c789e7e425d50b2c17f.jpg"],
                                 [NSURL URLWithString:@"http://10.0.0.21:800/xiangyu/20171211/5d50232f2cb643fd873d5b5c69be1b9c.jpg"],
                                 [NSURL URLWithString:@"http://10.0.0.21:800/xiangyu/20171211/df4dc6a1c4cd4c789e7e425d50b2c17f.jpg"]];
    [self.view addSubview:cycleImageVIew];
    [cycleImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(cycleImageVIew.mas_width).multipliedBy(1/2.f);
    }];

    // 功能列表
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(cycleImageVIew.mas_bottom).offset(10);
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [self.functions[indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [self.functions[indexPath.row] objectForKey:@"detail"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* vcName = [self.functions[indexPath.row] objectForKey:@"detail"];
    UIViewController* vc = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


# pragma mark - getter

- (NSArray *)functions {
    if (!_functions) {
        _functions = @[@{@"title":@"富文本1",
                         @"detail":@"TestCoreTextVC"
                         },
                       @{@"title":@"TextAsyncDisplay",
                         @"detail":@"TestAsyncDisplayKit"
                         },
                       @{@"title":@"TextKit",
                         @"detail":@"TestTextKit"
                         }];
    }
    return _functions;
}

@end

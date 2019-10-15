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
    
    // 功能列表
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(100);
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
                       @{@"title":@"TextKit",
                         @"detail":@"TestTextKit"
                         },
                       // TestVideoVC
                       @{@"title":@"TestVideo",
                         @"detail":@"TestVideoVC"
                         },
                       //TextAsyncViewViewController.h
                       @{@"title":@"TestAsyncView",
                         @"detail":@"TextAsyncViewViewController"
                         },
                       ];
    }
    return _functions;
}

@end

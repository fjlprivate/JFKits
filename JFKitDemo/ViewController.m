//
//  ViewController.m
//  JFKitApp
//
//  Created by warmjar on 2017/7/10.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* titles;
@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* title = self.titles[indexPath.row];
    UIViewController* vc = [[NSClassFromString(title) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = self.view.frame;
    frame.origin.y += 64;
    frame.size.height -= 64;
    self.tableView.frame = frame;
    [self.view addSubview:self.tableView];
    
}


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"TestAsyncDisplayLayer",
                    @"TextAsyncDisplayLayer2",
                    @"TestForTextStorage",
                    @"TestForImageDraw",
                    @"TestForImageStorage",
                    @"TestForAsyncDisplayView"];
    }
    return _titles;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end

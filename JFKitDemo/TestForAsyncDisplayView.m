//
//  TestForAsyncDisplayView.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestForAsyncDisplayView.h"
#import "TVMFeedCtrl.h"
#import "VTMFeedCell.h"
#import "JFKit.h"

@interface TestForAsyncDisplayView () <UITableViewDelegate, UITableViewDataSource, VTMFeedCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) TVMFeedCtrl* feedCtrl;
@end

@implementation TestForAsyncDisplayView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _feedCtrl = [TVMFeedCtrl new];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, JFSCREEN_WIDTH, JFSCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) wself = self;
    [_feedCtrl requestFeedDataOnFinished:^{
        [wself.tableView reloadData];
    } orError:^(NSError *error) {
        
    }];
}

# pragma maks 2 uitableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.feedCtrl layoutAtIndex:indexPath.row].cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedCtrl numberOfFeedNodes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTMFeedCell* cell = [tableView dequeueReusableCellWithIdentifier:@"VTMFeedCell"];
    if (!cell) {
        cell = [[VTMFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VTMFeedCell"];
    }
    cell.layout = [self.feedCtrl layoutAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

# pragma mask 2 VTMFeedCellDelegate

- (void)feedCell:(VTMFeedCell *)cell didClickedTextData:(id)textData {
    if ([textData isKindOfClass:[NSString class]]) {
        NSString* str = textData;
        if ([str hasPrefix:@"action"] && ([str hasSuffix:ContentTruncateYES] || [str hasSuffix:ContentTruncateNO])) {
            [self.feedCtrl replaceLayoutAtIndex:cell.tag withTruncated:([str hasSuffix:ContentTruncateYES] ? NO : YES)];
            [self.tableView reloadData];
        }
    }
}

@end

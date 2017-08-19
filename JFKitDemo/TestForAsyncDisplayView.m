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
#import "UIView+Toast.h"
#import "JFImageBrowser.h"

@interface TestForAsyncDisplayView () <UITableViewDelegate, UITableViewDataSource, VTMFeedCellDelegate, JFImageBrowserDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) TVMFeedCtrl* feedCtrl;
@property (nonatomic, strong) JFImageBrowser* imageBrowser;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation TestForAsyncDisplayView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = -1;
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
        else {
            [self.view makeToast:[NSString stringWithFormat:@"需要处理绑定的数据:%@", textData] duration:0.7 position:CSToastPositionCenter];
        }
    }
}

- (void)feedCell:(VTMFeedCell *)cell didClickedImageData:(id)imageData {
    if ([imageData isKindOfClass:[UIImage class]]) {
        NSString* log = [NSString stringWithFormat:@"点击了图片: %@", imageData];
        [self.view makeToast:log duration:1 position:CSToastPositionCenter];
    }
    else if ([imageData isKindOfClass:[NSURL class]]) {
        NSURL* url = imageData;
        NSString* log = [NSString stringWithFormat:@"点击了图片: %@", url.absoluteString];
        [self.view makeToast:log duration:1 position:CSToastPositionCenter];
    }
    
}

# pragma mask 2 JFImageBrowserDelegate

//- (NSInteger)numberOfImageSections {
//    
//}
//
//- (id)imageDataAtSection:(NSInteger)section {
//    
//}

# pragma mask 4 getter

- (JFImageBrowser *)imageBrowser {
    if (!_imageBrowser) {
        _imageBrowser = [[JFImageBrowser alloc] initWithFromVC:self];
        _imageBrowser.delegate = self;
    }
    return _imageBrowser;
}

@end

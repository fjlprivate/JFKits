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

@interface TestForAsyncDisplayView () <UITableViewDelegate, UITableViewDataSource, VTMFeedCellDelegate>
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
    _tableView.backgroundColor = JFHexColor(0xf7f7f7, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[VTMFeedCell class] forCellReuseIdentifier:@"VTMFeedCell"];
    [self.view addSubview:_tableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) wself = self;
    [_feedCtrl requestFeedDataOnFinished:^{
        [wself.tableView reloadData];
    } orError:^(NSError *error) {
        
    }];
}

# pragma maks 2 uitableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-------height for row at [%ld] : [%.02lf]",indexPath.section, [self.feedCtrl layoutAtIndex:indexPath.section].cellHeight);
    return [self.feedCtrl layoutAtIndex:indexPath.section].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor clearColor];//JFHexColor(0xf7f7f7, 1);
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.feedCtrl numberOfFeedNodes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-------cell for row[%ld]", indexPath.section);
    VTMFeedCell* cell = [tableView dequeueReusableCellWithIdentifier:@"VTMFeedCell"];
    cell.layout = [self.feedCtrl layoutAtIndex:indexPath.section];
    cell.tag = indexPath.section;
    cell.delegate = self;
    return cell;
}

# pragma mask 2 VTMFeedCellDelegate

// 点击了cell中的某个textStorage
- (void)feedCell:(VTMFeedCell *)cell didClickedTextData:(id)textData {
    __weak typeof(self) wself = self;
    if ([textData isKindOfClass:[NSString class]]) {
        NSString* str = textData;
        // 点击了"全文"或"收起"
        if ([str hasPrefix:@"action"] && ([str hasSuffix:ContentTruncateYES] || [str hasSuffix:ContentTruncateNO])) {
            // 更改数据源中对应的序号的layout的全文展开或收起
            [self.feedCtrl replaceLayoutAtIndex:cell.tag withTruncated:([str hasSuffix:ContentTruncateYES] ? NO : YES) onFinished:^{
                // 先截取cell的图片并覆盖到tableView中,等cell刷新完毕后删除
//                CGFloat cellHeight = [wself.feedCtrl layoutAtIndex:cell.tag].cellHeight;
//                UIImageView* imageView = [wself coverScreenshotAndDelayRemoveWithCell:cell cellHeight:cellHeight];
//                [UIView animateWithDuration:0.1 animations:^{
//                    [wself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:cell.tag]] withRowAnimation:UITableViewRowAnimationFade];
//
//                }];
//                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                    [wself.tableView beginUpdates];
//                    cell.layout = [wself.feedCtrl layoutAtIndex:cell.tag];
//                    [wself.tableView endUpdates];
//                } completion:^(BOOL finished) {
//
//                }];
//                [CATransaction begin];
//                [CATransaction setCompletionBlock:^{
//                    cell.layout = [wself.feedCtrl layoutAtIndex:cell.tag];
//                }];
//                [wself.tableView beginUpdates];
//                [wself.tableView endUpdates];
//                [CATransaction commit];
                
                [UIView animateWithDuration:0 animations:^{
                    [wself.tableView beginUpdates];
                    cell.layout = [wself.feedCtrl layoutAtIndex:cell.tag];
                    [wself.tableView endUpdates];
                }];
            }];
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

# pragma mark : tools
- (UIImage *)screenshotFromView:(UIView *)aView {
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size,NO,[UIScreen mainScreen].scale);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}


- (UIImageView* )coverScreenshotAndDelayRemoveWithCell:(UITableViewCell *)cell cellHeight:(CGFloat)cellHeight {
    
    UIImage* screenshot = [self screenshotFromView:cell];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    
    imgView.frame = CGRectMake(imgView.frame.origin.x,
                               imgView.frame.origin.y,
                               imgView.frame.size.width,
                               cellHeight);
    
    imgView.contentMode = UIViewContentModeTop;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    return imgView;
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
//        _imageBrowser.delegate = self;
    }
    return _imageBrowser;
}

@end

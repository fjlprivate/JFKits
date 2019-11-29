//
//  TextAsyncViewViewController.m
//  JFKitDemo
//
//  Created by 严美 on 2019/10/14.
//  Copyright © 2019 JohnnyFeng. All rights reserved.
//

#import "TextAsyncViewViewController.h"
#import "APTransHashCellHeader.h"

@interface TextAsyncViewViewController () <UITableViewDelegate, UITableViewDataSource, JFAsyncViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray<APTransHashHeaderLayouts*>* dataSource;
@end

@implementation TextAsyncViewViewController

- (void) refreshDatas {
    NSMutableArray* list = @[].mutableCopy;
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];

    self.dataSource = list;
    [self.tableView reloadData];
}

# pragma mark - JFAsyncViewDelegate
/**
 点击了文本区;
 如果highlight为空，则点击的是整个textLayout文本区;

 @param asyncView 当前异步加载视图;
 @param textLayout 文本布局对象;
 @param highlight 高亮属性;
 */
- (void) asyncView:(JFAsyncView*)asyncView didClickedAtTextLayout:(JFTextLayout*)textLayout withHighlight:(JFTextAttachmentHighlight*)highlight
{
    if (highlight) {
        NSLog(@"--------------------点击了cell[%ld]的高亮[%@]", asyncView.tag, highlight.linkData);
        // 点击了'全文'
        if ([highlight.linkData isKindOfClass:[NSString class]] && [highlight.linkData isEqualToString:JFTextViewAll]) {
            APTransHashHeaderLayouts* layouts = [self.dataSource objectAtIndex:asyncView.tag];
            [layouts spreadUp];
//            [self.tableView reloadData];
//            [UIView performWithoutAnimation:^{
//                [asyncView.layer setNeedsDisplay];
//            }];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:asyncView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            });
        }
        
        
    }
}


/**
 长按文本区;
 如果highlight为空，则点击的是整个textLayout文本区;
 
 @param asyncView 当前异步加载视图;
 @param textLayout 文本布局对象;
 @param highlight 高亮属性;
 */
- (void) asyncView:(JFAsyncView*)asyncView didLongpressAtTextLayout:(JFTextLayout*)textLayout withHighlight:(JFTextAttachmentHighlight*)highlight {
    NSLog(@"--------------------长按文本区cell[%ld]", asyncView.tag);
}



# pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    APTransHashHeaderLayouts* layout = self.dataSource[indexPath.row];
    return layout.viewFrame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    APTransHashCellHeader* cell = [tableView dequeueReusableCellWithIdentifier:@"APTransHashCellHeader"];
    cell.layouts = self.dataSource[indexPath.row];
    cell.asyncView.tag = indexPath.row;
    cell.asyncView.delegate = self;
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self refreshDatas];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[APTransHashCellHeader class] forCellReuseIdentifier:@"APTransHashCellHeader"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
        _tableView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delaysContentTouches = NO;
    }
    return _tableView;
}


@end

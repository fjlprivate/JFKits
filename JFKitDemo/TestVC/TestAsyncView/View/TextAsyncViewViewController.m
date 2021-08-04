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
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initQuanwenLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initImageTextLayouts]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initWithJsonNode]];
    [list addObject:[[APTransHashHeaderLayouts alloc] initWithJsonNode]];

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
            if ([highlight.linkData isEqualToString:JFTextViewAll]) {
                [layouts spreadUp];
            }
            else if ([highlight.linkData isEqualToString:JFTextViewLimit]) {
                [layouts spreadDown];
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:asyncView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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

/**
 点击了图片区;
 @param asyncView 当前异步加载视图;
 @param imageLayout 图片布局对象;
 */
- (void) asyncView:(JFAsyncView*)asyncView didClickedAtImageLayout:(JFImageLayout*)imageLayout {
    NSLog(@"--------------------点击了图片[%ld]区cell[%ld]",imageLayout.tag, asyncView.tag);
}

/// 即将开始绘制
/// @param asyncView  当前异步加载视图
/// @param context  当前即将绘制的上下文
/// @param cancelled  退出绘制的回调；在外部绘制时，要不时判断当前绘制是否结束
//- (void) asyncView:(JFAsyncView*)asyncView willDrawInContext:(CGContextRef)context cancelled:(IsCancelled)cancelled {
//    CGContextSaveGState(context);
//
//    // 绘制头像的背景色
//    CGMutablePathRef path = CGPathCreateMutable();
//
//    CGContextFillRect(context, CGRectMake(150, 15, 20, 20));
//    CGRect frame = CGRectMake(JFSCREEN_WIDTH - JFScaleWidth6(15 + 44), JFScaleWidth6(15), JFScaleWidth6(44), JFScaleWidth6(44));
//    CGPathAddRoundedRect(path, NULL, frame, JFScaleWidth6(44 * 0.5), JFScaleWidth6(44 * 0.5));
//    CGContextAddPath(context, path);
//    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextFillPath(context);
//
//    CGPathRelease(path);
//
//
//    CGContextRestoreGState(context);
//
//}



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

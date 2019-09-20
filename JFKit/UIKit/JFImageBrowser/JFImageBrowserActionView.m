//
//  JFImageBrowserActionView.m
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFImageBrowserActionView.h"
#import "JFImageBrowserHandler.h"

@interface JFImageBrowserActionView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray<JFImageBrowserHandler*>* items;
@property (nonatomic, strong) JFImageBrowserHandler* cancelHandler;
@property (nonatomic, strong) NSArray<JFImageBrowserHandler*>* otherHandlers;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* bgView;
@end

@implementation JFImageBrowserActionView

- (instancetype) initWithFrame:(CGRect)frame items:(NSArray*)items {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.items = items;
        [self addSubview:self.bgView];
        [self addSubview:self.tableView];
        self.bgView.frame = self.bounds;
        
        self.hidden = YES;
        self.bgView.alpha = 0;
        
        NSInteger otherCount = self.otherHandlers.count;
        NSInteger cancelCount = self.cancelHandler ? 1 : 0;
        CGFloat tbHeight = (otherCount + cancelCount) * JFImageBrowserActionCellHeight + (otherCount > 0 && cancelCount > 0 ? 1 : 0) * JFImageBrowserActionHeaderHeight;
        
        self.tableView.frame = CGRectMake(0,
                                          frame.size.height,
                                          frame.size.width,
                                          tbHeight);
    }
    return self;
}

- (void) showActionSheet {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 1;
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            _isShown = YES;
        } else {
            _isShown = NO;
        }
    }];
}
- (void) hideActionSheet {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0;
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.bounds.size.height;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
            _isShown = NO;
        } else {
            _isShown = YES;
        }
    }];
}


# pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL hasOther = self.otherHandlers.count > 0;
    BOOL hasCancel = self.cancelHandler;
    return (hasOther ? 1 : 0) + (hasCancel ? 1 : 0);
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 第一部分
    if (section == 0) {
        // 其他
        if (self.otherHandlers.count > 0) {
            return self.otherHandlers.count;
        }
        // 取消
        else {
            return 1;
        }
    }
    // 第二部分:默认就是取消
    else {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // 第一部分
    if (indexPath.section == 0) {
        // 其他
        if (self.otherHandlers.count > 0) {
            cell.textLabel.text = self.otherHandlers[indexPath.row].title;
        }
        // 取消
        else {
            cell.textLabel.text = self.cancelHandler.title;
        }
    }
    // 第二部分:默认就是取消
    else {
        cell.textLabel.text = self.cancelHandler.title;
    }

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return JFImageBrowserActionHeaderHeight;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [UIView new];
    UIBlurEffect* blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [view addSubview:effectView];
    effectView.frame = CGRectMake(0, 0, self.bounds.size.width, JFImageBrowserActionHeaderHeight);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JFImageBrowserHandler* item = nil;
    if (indexPath.section == 0) {
        if (self.otherHandlers.count > 0) {
            item = self.otherHandlers[indexPath.row];
        }
        else {
            item = self.cancelHandler;
        }
    }
    else {
        item = self.cancelHandler;
    }
    if (item && self.didSelectWithItem) {
        self.didSelectWithItem(item);
    }
}

# pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch* touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.tableView.frame, point)) {
        [self hideActionSheet];
    }
}

# pragma mark - setter
- (void)setItems:(NSArray *)items {
    _items = items;
    self.otherHandlers = nil;
    self.cancelHandler = nil;
    NSMutableArray* otherItems = @[].mutableCopy;
    for (JFImageBrowserHandler* item in items) {
        if (item.type == JFIBHandlerTypeCancel) {
            self.cancelHandler = item;
        } else {
            [otherItems addObject:item];
        }
    }
    if (otherItems.count > 0) {
        self.otherHandlers = otherItems;
    }
}

# pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = JFImageBrowserActionCellHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _bgView;
}

@end

//
//  TestForImageStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/21.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestForImageStorage.h"
#import "JFKit.h"

@interface TestForImageStorage ()
@property (nonatomic, strong) JFAsyncDisplayView* asyncView;
@property (nonatomic, strong) JFButton* asyncBtn;
@end

@implementation TestForImageStorage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.asyncView];
    [self.view addSubview:self.asyncBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (JFAsyncDisplayView *)asyncView {
    if (!_asyncView) {
        _asyncView = [[JFAsyncDisplayView alloc] init];
        _asyncView.top = 64 + 14;
        _asyncView.left = 15;
        _asyncView.right = JFSCREEN_WIDTH - 15;
        _asyncView.bottom = self.asyncBtn.top - 15;
        _asyncView.backgroundColor = JFHexColor(0xeeeeee, 1);
    }
    return _asyncView;
}

- (JFButton *)asyncBtn {
    if (!_asyncBtn) {
        _asyncBtn = [JFButton new];
        _asyncBtn.normalTitle = @"异步绘制";
        _asyncBtn.normalTitleColor = JFHexColor(0xffffff, 1);
        _asyncBtn.highLightTitleColor = JFHexColor(0xffffff, 0.5);
        _asyncBtn.backgroundColor = JFHexColor(0x00a1dc, 1);
        _asyncBtn.bottom = JFSCREEN_HEIGHT;
        _asyncBtn.left = 0;
        _asyncBtn.right = JFSCREEN_WIDTH;
        _asyncBtn.top = _asyncBtn.bottom - 44;
        __weak typeof(self) wself = self;
        _asyncBtn.didTouchedUpInside = ^{
            JFLayout* layout = [JFLayout new];
            JFImageStorage* img1 = [JFImageStorage jf_imageStroageWithContents:[UIImage imageNamed:@"headWoman"] frame:CGRectMake(10, 10, 50, 50)];
            img1.cornerRadius = CGSizeMake(25, 25);
            img1.backgroundColor = JFHexColor(0xeeeeee, 1);
            img1.borderColor = JFHexColor(0xea6956, 1);
            img1.borderWidth = 2;
            [layout addStorage:img1];
            
            JFTextStorage* t1 = [JFTextStorage jf_textStorageWithText:@"我是一个傻妹儿" frame:CGRectMake(10 + img1.right, 10 + img1.top, 1000, 50) insets:UIEdgeInsetsZero];
            t1.textColor = JFHexColor(0x27384b, 1);
            t1.textFont = [UIFont boldSystemFontOfSize:14];
            [layout addStorage:t1];
            
            NSString* tt2 =@"来自: iphone6 Plus";
            JFTextStorage* t2 = [JFTextStorage jf_textStorageWithText:tt2 frame:CGRectMake(t1.left, t1.bottom + 5, 1000, 50) insets:UIEdgeInsetsZero];
            [t2 setTextFont:[UIFont systemFontOfSize:13] atRange:[tt2 rangeOfString:@"来自: "]];
            [t2 setTextFont:[UIFont boldSystemFontOfSize:14] atRange:[tt2 rangeOfString:@"iphone6 Plus"]];
            [t2 setTextColor:JFHexColor(0x999999, 1) atRange:[tt2 rangeOfString:@"来自: "]];
            [t2 setTextColor:JFHexColor(0xEA6956, 1) atRange:[tt2 rangeOfString:@"iphone6 Plus"]];
            [layout addStorage:t2];

            wself.asyncView.layout = layout;
        };
    }
    return _asyncBtn;
}


@end

//
//  TestVideoDisplayVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/7/7.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestVideoDisplayVC.h"
#import "JFVideoDisplay.h"

@interface TestVideoDisplayVC ()
@property (nonatomic, strong) JFVideoDisplay* vDisplayer;
@end

@implementation TestVideoDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.vDisplayer];
    [self.vDisplayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    if (self.videoUrl) {
        self.vDisplayer.videoUrl = self.videoUrl;
        [self.vDisplayer play];
    }
}

- (JFVideoDisplay *)vDisplayer {
    if (!_vDisplayer) {
        _vDisplayer = [[JFVideoDisplay alloc] init];
        _vDisplayer.showHandleBtns = YES;
        WeakSelf(wself);
        _vDisplayer.cancelledBlock = ^{
            [wself dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _vDisplayer;
}


@end

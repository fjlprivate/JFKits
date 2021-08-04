//
//  TestSegmentVC.m
//  JFKitDemo
//
//  Created by 严美 on 2020/5/24.
//  Copyright © 2020 JohnnyFeng. All rights reserved.
//

#import "TestSegmentVC.h"
#import "JFHelper.h"
#import "JFSegmentView.h"
#import <Masonry.h>

@interface TestSegmentVC () <JFSegmentViewDelegate>

@end

@implementation TestSegmentVC


- (BOOL)segmentView:(JFSegmentView *)segmentView canSelectAtIndex:(NSInteger)index {
    if (index == 2) {
        return NO;
    }
    return YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JFColorWhite;
    self.title = @"Test Segment";
    
    JFSegmentView* vSegment = [[JFSegmentView alloc] initWithItems:@[@"1",@"2",@"3",@"4",@"5"]];
    vSegment.delegate = self;
    vSegment.seperatorColor = JFColorWhite;
    vSegment.seperatorHeight = 44 * 0.5;
    [self.view addSubview:vSegment];
    [vSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(JFNaviStatusBarHeight + JFScaleWidth6(30));
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(JFSCREEN_WIDTH - 100);
    }];
    
    
}


@end

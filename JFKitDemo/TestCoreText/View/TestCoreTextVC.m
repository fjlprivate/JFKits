//
//  TestCoreTextVC.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/8.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "TestCoreTextVC.h"
#import "TextView1.h"
#import "TextView2.h"
#import "SystemLabel.h"

@interface TestCoreTextVC ()

@end

@implementation TestCoreTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat selfwidth = CGRectGetWidth(self.view.frame);
    CGFloat selfheight = CGRectGetHeight(self.view.frame);
    CGRect frame = CGRectMake(10, 100, selfwidth - 20, 100);
    // 第一个core text排版的文字
    TextView1* text1 = [[TextView1 alloc] initWithFrame:frame];
    [self.view addSubview:text1];
    // 第二个系统文本
    frame.origin.y += frame.size.height + 12;
    frame.size.height = selfheight - frame.origin.y - 12;
    TextView2* text2 = [[TextView2 alloc] initWithFrame:frame];
    [self.view addSubview:text2];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end

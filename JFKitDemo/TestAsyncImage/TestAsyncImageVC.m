//
//  TestAsyncImageVC.m
//  JFKitDemo
//
//  Created by 严美 on 2019/11/1.
//  Copyright © 2019 JohnnyFeng. All rights reserved.
//

#import "TestAsyncImageVC.h"
#import "JFKit.h"
#import "JFImageView.h"
#import <Masonry.h>

@interface TestAsyncImageVC ()

@end

@implementation TestAsyncImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = JFColorWhite;
    UIView* bgView = [UIView new];
    bgView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(JFScaleWidth6(15), JFScaleWidth6(15), JFScaleWidth6(15), JFScaleWidth6(15)));
    }];
    
    JFImageLayout* imgLayout = [JFImageLayout new];
    imgLayout.image = JFImageNamed(@"icon_robot_orange");
    imgLayout.left = 100;
    imgLayout.top = 100;
    imgLayout.width = imgLayout.height = 100;
    
    JFImageView* imgView = [JFImageView new];
    imgView.imageLayout = imgLayout;
    
    [bgView addSubview:imgView];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TestVideoVC.m
//  JFKitDemo
//
//  Created by 严美 on 2019/9/28.
//  Copyright © 2019 JohnnyFeng. All rights reserved.
//

#import "TestVideoVC.h"
#import "JFKit.h"

@interface TestVideoVC ()
@property (nonatomic, strong) JFVideoDisplay* displayer;
@end

@implementation TestVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JFColorWhite;
    CGFloat width = JFSCREEN_WIDTH - 20;
    self.displayer = [[JFVideoDisplay alloc] initWithFrame:CGRectMake(10, 100, width, width * 720.f/1280.f)];
    self.displayer.backgroundColor = JFColorBlack;
    [self.view addSubview:self.displayer];
}


@end

//
//  TestAsyncDrawVC.m
//  JFKitDemo
//
//  Created by 严美 on 2020/8/18.
//  Copyright © 2020 JohnnyFeng. All rights reserved.
//

#import "TestAsyncDrawVC.h"
#import <Masonry.h>
#import "JFKit.h"

@interface TestAsyncDrawVC ()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation TestAsyncDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(150);
        make.height.mas_equalTo(200);
    }];
    
    
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitle:@"开始绘制" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.imageView.mas_top).offset(-15);
        make.height.mas_equalTo(50);
    }];
    [btn addTarget:self action:@selector(asyncDraw) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void) asyncDraw {
    NSLog(@"++++++++++开始绘制");

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
     
    dispatch_async(queue, ^{
        CGSize size = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 30, 200);
        UIGraphicsBeginImageContextWithOptions(size, YES, UIScreen.mainScreen.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();

        
        dispatch_group_t group = dispatch_group_create();

        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            CGContextSaveGState(context);
            CGContextDrawImage(context, CGRectMake(10, 10, 100, 100), [UIImage imageNamed:@"icon_robot_orange"].CGImage);
            CGContextRestoreGState(context);
            dispatch_group_leave(group);
        });

        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            CGContextSaveGState(context);
            CGContextDrawImage(context, CGRectMake(10 + 100 + 10, 10, 100, 100), [UIImage imageNamed:@"detail_icon_collection_selected"].CGImage);
            CGContextRestoreGState(context);
            dispatch_group_leave(group);
        });

        dispatch_group_notify(group, queue, ^{
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
                NSLog(@"++++++++++绘制完毕");
            });
        });

        
        
    });
    
    

    
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
    }
    return _imageView;
}




@end

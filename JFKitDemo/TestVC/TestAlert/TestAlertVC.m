//
//  TestAlertVC.m
//  JFKitDemo
//
//  Created by 严美 on 2020/5/24.
//  Copyright © 2020 JohnnyFeng. All rights reserved.
//

#import "TestAlertVC.h"
#import <Masonry.h>
#import "JFHelper.h"
#import "JFAlertView.h"
#import "JFZoomImageView.h"
#import <TZImagePickerController.h>
#import <YYWebImage.h>
#import <SDWebImage.h>

@interface TestAlertVC ()
@property (nonatomic, strong) JFZoomImageView* imageView;
@property (nonatomic, strong) UIImageView* imageView2;
@end

@implementation TestAlertVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Test Alert";
    self.view.backgroundColor = JFColorWhite;
    
    //
    UIButton* btnNormal = [[UIButton alloc] init];
    [btnNormal setTitle:@"Normal" forState:UIControlStateNormal];
    [btnNormal setTitleColor:JFColorBlack forState:UIControlStateNormal];
    [btnNormal addTarget:self action:@selector(clickedNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNormal];
    [btnNormal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JFScaleWidth6(25));
        make.top.mas_equalTo(JFNaviStatusBarHeight + JFScaleWidth6(15));
    }];
    //
    UIButton* btnImage = [[UIButton alloc] init];
    [btnImage setTitle:@"Image" forState:UIControlStateNormal];
    [btnImage setTitleColor:JFColorBlack forState:UIControlStateNormal];
    [btnImage addTarget:self action:@selector(clickedImageAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnImage];
    [btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(JFScaleWidth6(10));
//        make.top.mas_equalTo(JFNaviStatusBarHeight + JFScaleWidth6(15));
        make.centerY.equalTo(btnNormal);
    }];

    self.imageView = [[JFZoomImageView alloc] init];
//    [self.imageView setImage:JFImageNamed(@"icon_robot_orange")];
    self.imageView.maximumZoomScale = 5.f;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(200);
        make.centerX.centerY.mas_equalTo(0);
    }];
    self.imageView.backgroundColor = JFRGBAColor(0, 0.1);
    
    
    self.imageView2 = [UIImageView new];
    self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView2.clipsToBounds = YES;
    self.imageView2.backgroundColor = JFRGBAColor(0x00ff00, 0.1);
    [self.view addSubview:self.imageView2];
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-15);
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(clickedSelect:)];
    
}

- (IBAction) clickedNormal:(id)sender {
    JFAlertView* alert = [JFAlertView alertWithTitle:@"Alert" detail:@"Alert类型：normal" image:nil];
    [alert addButtonWithTitle:@"取消" textColor:nil textFont:nil bgColor:nil action:^{
    }];
    [alert addButtonWithTitle:@"确定" textColor:nil textFont:nil bgColor:nil action:^{
        
    }];
    [alert show];
}
- (IBAction) clickedImageAlert:(id)sender {
    JFAlertView* alert = [JFAlertView alertWithTitle:@"Alert" detail:@"Alert类型：image" image:JFImageNamed(@"icon_robot_orange")];
    alert.imageSize = JFScaleWidth6(44);
    [alert addButtonWithTitle:@"取消" textColor:nil textFont:nil bgColor:nil action:^{
    }];
    [alert addButtonWithTitle:@"确定" textColor:nil textFont:nil bgColor:nil action:^{
        
    }];
    [alert show];
}

- (IBAction) clickedSelect:(id)sender {
    NSLog(@"+++++++++++++ JFSafeInsetBottom[%lf]", JFSCREEN_BOTTOM_INSET);
    NSString* url = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2F2c.zol-img.com.cn%2Fproduct%2F124_500x2000%2F748%2FceZOdKgDAFsq2.jpg&refer=http%3A%2F%2F2c.zol-img.com.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627111801&t=1c494da53a43d4b1960e021934ed0e78";
    [self.imageView setImage:url];
    [self.imageView2 yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil];
//    WeakSelf(wself);
//    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:url]];
//    TZImagePickerController* picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
//    picker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        [wself.imageView setImage:photos.firstObject];
//    };
//    [self presentViewController:picker animated:YES completion:nil];
}

@end

//
//  TestPresenterVC.m
//  JFTools
//
//  Created by fjl on 2021/5/14.
//

#import "TestPresenterVC.h"
#import "JFToast.h"
#import <Masonry.h>

@interface TestPresenterVC ()
@property (nonatomic, weak) UIButton* lastBtn;
@end

@implementation TestPresenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBtnWithTitle:@"Toast文本" andAction:@selector(showToastText)];
    [self addBtnWithTitle:@"Toast菊花文本" andAction:@selector(showToastJuhuaText)];
    [self addBtnWithTitle:@"Toast菊花" andAction:@selector(showToastJuhua)];
    [self addBtnWithTitle:@"Toast图片" andAction:@selector(showToastImage)];
    [self addBtnWithTitle:@"Toast图片文本" andAction:@selector(showToastImageText)];
    [self addBtnWithTitle:@"Toast成功" andAction:@selector(showToastRight)];
    [self addBtnWithTitle:@"Toast失败" andAction:@selector(showToastWrong)];
}

- (void) addBtnWithTitle:(NSString*)title andAction:(SEL)action {
    UIButton* btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        if (self.lastBtn) {
            make.top.equalTo(self.lastBtn.mas_bottom).offset(10);
        } else {
            make.top.mas_equalTo(100);
        }
        make.height.mas_equalTo(40);
    }];
    self.lastBtn = btn;
}

- (void) showToastText {
    [JFToast toastWithText:@"脸上的肌肤立即阿斯顿发"];
}
- (void) showToastJuhuaText {
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleActivityText text:@"脸上的肌肤立即阿斯顿发" image:nil inView:nil];
    toast.hideWhenClickOutContent = YES;
}
- (void) showToastJuhua {
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleActivity text:nil image:nil inView:nil];
    toast.hideWhenClickOutContent = YES;
//    toast.shouldIndicatorAnimation = NO;
//    toast.indicatorSize = 50;
//    toast.gapLeft = toast.gapRight = toast.gapTop = toast.gapBottom = 25;
}

- (void) showToastImage {
    JFToast* toast = [JFToast toastWithImage:[UIImage imageNamed:@"icon_robot_orange"] hideAfterSecs:5];
    toast.gapTop = toast.gapBottom = toast.gapLeft;
    toast.hideWhenClickOutContent = YES;
}
- (void) showToastImageText {
    JFToast* toast = [JFToast toastWithImage:[UIImage imageNamed:@"icon_robot_orange"] text:@"这是一只笨鸟" hideAfterSecs:6];
    toast.gapTop = toast.gapLeft;
    toast.hideWhenClickOutContent = YES;
}


- (void) showToastRight {
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleActivityText text:@"操作成功!" image:nil inView:nil];
    toast.hideWhenClickOutContent = YES;
    toast.indicator = FAGlass + 12;
    toast.shouldIndicatorAnimation = NO;
    toast.indicatorColor = UIColor.greenColor;
}
- (void) showToastWrong {
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleActivityText text:@"操作失败!" image:nil inView:nil];
    toast.hideWhenClickOutContent = YES;
    toast.indicator = FAGlass + 13;
    toast.shouldIndicatorAnimation = NO;
    toast.indicatorColor = UIColor.redColor;
    toast.gapTop = toast.gapBottom = 8;
    toast.gapImg2Title = 5;
    toast.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:20];

}



@end

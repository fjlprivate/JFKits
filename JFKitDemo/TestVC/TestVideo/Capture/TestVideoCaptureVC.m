//
//  TestVideoCaptureVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/25.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestVideoCaptureVC.h"
#import "JFVideoCapture.h"

@interface TestVideoCaptureVC () <JFVideoCaptureDelegate>
@property (nonatomic, strong) JFVideoCapture* vCapture;
@property (nonatomic, strong) UIButton* btnClose;
@end

@implementation TestVideoCaptureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.vCapture];
    [self.view addSubview:self.btnClose];

    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(JFStatusBarHeight + 10);
    }];
    [self.vCapture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

# pragma mark - actions
- (IBAction) clickedClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



# pragma mark - JFVideoCaptureDelegate
/**
 回调: 返回拍摄的视频数据;

 @param videoCapture 视频采集器;
 @param videoURL 拍摄的视频保存地址;
 @param thumbnail 首帧截图;
 */
- (void) jf_videoCapture:(JFVideoCapture*)videoCapture didFinishedCaptureWithVideoURL:(NSURL*)videoURL thumbnail:(UIImage*)thumbnail {
    if (self.callBackCapturedVideo) {
        self.callBackCapturedVideo(videoURL, thumbnail);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 回调: 返回拍摄的照片;

 @param videoCapture 视频采集器;
 @param image 拍摄的图片;
 */
- (void) jf_videoCapture:(JFVideoCapture*)videoCapture didFinishedCaptureWithImage:(UIImage*)image {
    if (self.callBackCapturedImage) {
        self.callBackCapturedImage(image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



# pragma mark - getter
- (JFVideoCapture *)vCapture {
    if (!_vCapture) {
        _vCapture = [JFVideoCapture new];
        _vCapture.captureTimeLimit = 15;
        _vCapture.delegate = self;
    }
    return _vCapture;
}
- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [UIButton new];
        [_btnClose setTitle:[NSString fontAwesomeIconStringForEnum:FAChevronCircleDown] forState:UIControlStateNormal];
        [_btnClose setTitleColor:JFRGBAColor(0xffffff, 1) forState:UIControlStateNormal];
        [_btnClose setTitleColor:JFRGBAColor(0xffffff, 0.5) forState:UIControlStateHighlighted];
        _btnClose.titleLabel.font = [UIFont fontAwesomeFontOfSize:32];
        [_btnClose addTarget:self action:@selector(clickedClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}


@end

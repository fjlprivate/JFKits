//
//  JFVideoCaptureBtn.h
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/25.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/***【视频拍摄按钮】***/
@interface JFVideoCaptureBtn : UIButton

// 隐藏进度条
@property (nonatomic, assign) BOOL hiddenProgress;

// 进度条颜色(默认蓝色)
@property (nonatomic, copy) UIColor* progressTintColor;
// 进度值(动画显示进度条)
@property (nonatomic, assign) CGFloat progress;
// 进度条宽度(默认4)
@property (nonatomic, assign) CGFloat progressWidth;

@end

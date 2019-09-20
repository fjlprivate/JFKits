//
//  JFVideoDisplay.h
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFConstant.h"



@class AVPlayerItem;

@interface JFVideoDisplay : UIView

// 视频内容的url
@property (nonatomic, copy) NSURL* videoUrl;

// 是否循环播放;默认:YES
@property (nonatomic, assign) BOOL shouldCyclePlay;

// 是否自动播放;默认:YES
@property (nonatomic, assign) BOOL shouldAutoPlay;

// 是否显示操作按钮
@property (nonatomic, assign) BOOL showHandleBtns;

// 播放状态
@property (nonatomic, assign) JFVideoPlayState state;

// 退出操作
@property (nonatomic, copy) void (^ cancelledBlock) (void);

// 暂停
- (void) pause;
// 播放
- (void) play;

// panGes拖动事件(手势加在superView)
- (IBAction) panGes:(UIPanGestureRecognizer*)sender;


@end

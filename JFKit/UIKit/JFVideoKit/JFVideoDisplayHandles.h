//
//  JFVideoDisplayHandles.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/24.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFConstant.h"
#import "JFVideoSlider.h"

NS_ASSUME_NONNULL_BEGIN


@interface JFVideoDisplayHandles : UIView

// 显示操作按钮
- (void) showHandles;
// 隐藏操作按钮
- (void) hideHandles;

// 播放状态;控制视图显示
@property (nonatomic, assign) JFVideoPlayState state;

// 视频时长;单位:秒
@property (nonatomic, assign) NSTimeInterval duration;
// 当前播放时间;单位:秒
@property (nonatomic, assign) NSTimeInterval curTime;
// 预加载时间;单位:秒
@property (nonatomic, assign) NSTimeInterval preloadedTime;


// 回调:点击了播放|暂停按钮
@property (nonatomic, copy) void (^ didClickPlayPauseBtn) (void);
// 回调:更新了搓擦条;拖动搓擦条才会回调
@property (nonatomic, copy) void (^ willUpdateSlider) (JFVideoSlider* slider);
@property (nonatomic, copy) void (^ didUpdateSlider) (JFVideoSlider* slider);
@property (nonatomic, copy) void (^ didEndUpdateSlider) (JFVideoSlider* slider);

// 退出操作
@property (nonatomic, copy) void (^ cancelledBlock) (void);


@end

NS_ASSUME_NONNULL_END

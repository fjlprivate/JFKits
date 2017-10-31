//
//  JFVideoDisplay.h
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

# pragma mark - 配置信息

#define JFVideoTextTimeFontSize             13 // 字体大小:时间
#define JFVideoTextTitleFontSize            13 // 字体大小:标题

#define JFVideoBottomBannerHeight           40 // 下banner高度值
#define JFVideoBottomBannerItemHeight       24 // 下banner元素的高度值

#define JFVideoTextColor                    [UIColor whiteColor] // 文本色
#define JFVideoProgressTintColor            [UIColor whiteColor] // 进度条色
#define JFVideoProgressTrackColor           [UIColor colorWithWhite:1 alpha:0.1] // 进度条背景色
#define JFVideoBannerBgColor                [UIColor colorWithWhite:0 alpha:0.3] // banner背景色


#define JFVideoImageNamePlay                @"play_white" // 播放图片名
#define JFVideoImageNamePause               @"pause_white" // 暂停图片名
#define JFVideoImageNameFullscreen          @"fullscreen" // 全屏图片名
#define JFVideoImageNameNarrow              @"narrow" // 缩小图片名
#define JFVideoImageNameBack                @"delete_fill" // 退出图片名
#define JFVideoImageNameMore                @"more" // 更多图片名
#define JFVideoImageNameSlider              @"circle_white" // 滑块图片名


typedef NS_ENUM(NSInteger, JFVideoPlayState) {
    JFVideoPlayStateWaiting,    // 等待播放
    JFVideoPlayStatePlaying,    // 正在播放
    JFVideoPlayStatePausing,    // 暂停播放
    JFVideoPlayStateFinishing   // 播放完毕
};

@interface JFVideoDisplay : UIView

- (void) displayWithUrl:(NSURL*)url;

- (void) stop;

@end

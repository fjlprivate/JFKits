//
//  JFVideoPlayer.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/24.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "JFConstant.h"

NS_ASSUME_NONNULL_BEGIN

@class JFVideoPlayer;
@protocol JFVideoPlayerDelegate <NSObject>
@optional
/**
 状态更新
 @param videoPlayer             播放器
 @param status                  播放状态
 */
- (void) videoPlayer:(JFVideoPlayer*)videoPlayer didUpdateStatus:(JFVideoPlayState)status;

/**
 播放进度
 @param videoPlayer             播放器
 @param curTimeSecs             当前已播放的秒数
 */
- (void) videoPlayer:(JFVideoPlayer*)videoPlayer curPlayingTimeSecs:(NSTimeInterval)curTimeSecs;


/**
 预加载进度
 @param videoPlayer             播放器
 @param preloadedTimeSecs       已加载缓存的时间;单位:秒
 */
- (void) videoPlayer:(JFVideoPlayer*)videoPlayer preloadedTimeSecs:(NSTimeInterval)preloadedTimeSecs;


@end

@interface JFVideoPlayer : NSObject

/**
 初始化
 @param video                   视频资源;<NSURL>
 @return                        控制器对象
 */
- (instancetype) initWithVideo:(NSURL*)video;

// 视频资源;
@property (nonatomic, strong, nullable) NSURL* video;
// 播放界面图层;由外部指定;
@property (nonatomic, weak) AVPlayerLayer* playerLayer;

// 代理
@property (nonatomic, weak) id<JFVideoPlayerDelegate> delegate;

// 是否循环播放;默认:YES
@property (nonatomic, assign) BOOL playCircle;
// 是否自动播放;默认:YES
@property (nonatomic, assign) BOOL playAuto;
// 是否打开预加载器;默认:NO;长视频、支持拖动进度的，不要开启预加载;
@property (nonatomic, assign) BOOL shoulPreLoad;

// 播放状态;外部只读;
@property (nonatomic, assign) JFVideoPlayState status;

// 播放
- (void) play;
// 暂停
- (void) pause;
// 更新进度
- (void) seekToTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END

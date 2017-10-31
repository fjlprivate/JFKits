//
//  JFVideoCapture.h
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

# define JFVideoImageNameRevoke @"revoke_white" // 撤销按钮图片名称
# define JFVideoImageNameDoneBlue @"done_blue" // 完成按钮图片名称

# define JFVideoCaptureBtnWidth 100 // 拍摄按钮宽度
# define JFVideoCaptureBtnBottm 44 // 拍摄按钮底部间隔
# define JFVideoRevokeBtnWidth 30 // 撤销按钮的宽度
# define JFVideoDoneBtnWidth 30 // 完成按钮的宽度


/** 拍摄状态 **/
typedef NS_ENUM(NSInteger, JFVideoCaptureState){
    JFVideoCaptureStateWaiting,     // 等待拍摄
    JFVideoCaptureStateExecuting,   // 拍摄中
    JFVideoCaptureStateDone         // 拍摄完毕
};

@class JFVideoCapture;

/****【视频拍摄器协议】****/
@protocol JFVideoCaptureDelegate <NSObject>
@optional
/**
 回调: 返回拍摄的视频数据;

 @param videoCapture 视频采集器;
 @param videoURL 拍摄的视频保存地址;
 */
- (void) jf_videoCapture:(JFVideoCapture*)videoCapture didFinishedCaptureWithVideoURL:(NSURL*)videoURL;

@end


/****【视频拍摄器】****/
@interface JFVideoCapture : UIView

# pragma mark - 协议
@property (nonatomic, weak) id<JFVideoCaptureDelegate> delegate; // 用于数据和状态的回调

# pragma mark - 配置
@property (nonatomic, assign) BOOL shouldSaveVideo; // 是否保存相册(默认保存)
@property (nonatomic, assign) BOOL shouldCompressVideo; // 是否压缩视频(默认压缩)
@property (nonatomic, assign) NSInteger captureDuration; // 拍摄时长(>0则显示进度条,并在时间到达时自动停止拍摄)

# pragma mark - 状态
@property (nonatomic, assign) JFVideoCaptureState state; // 状态
//@property (nonatomic, assign) BOOL isStarting; // 拍摄状态:已启动
//@property (nonatomic, assign) BOOL isCapturing; // 拍摄状态:正在拍摄

# pragma mark - 操作

//- (void) start; // 启动

//- (void) stop; // 停止

//- (void) startCapturing; // 开始拍摄

// 在外部用于中断的操作
- (void) stopCapturing; // 停止拍摄



@end



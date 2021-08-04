//
//  JFVideoCapture.h
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

# define JFVideoImageNameRevoke @"icon_capture_cancel" // 撤销按钮图片名称
# define JFVideoImageNameDoneBlue @"icon_capture_done" // 完成按钮图片名称

# define JFVideoCaptureBtnWidth 100 // 拍摄按钮宽度
# define JFVideoCaptureBtnBottm 44 // 拍摄按钮底部间隔
# define JFVideoRevokeBtnWidth 56 // 撤销按钮的宽度
# define JFVideoDoneBtnWidth 56 // 完成按钮的宽度


/** 拍摄状态 **/
typedef NS_ENUM(NSInteger, JFVideoCaptureState){
    JFVideoCaptureStateWaiting,         // 等待拍摄
    JFVideoCaptureStateExecuting,       // 拍摄中
    JFVideoCaptureStateCompressing,     // 拍摄完毕,压缩中
    JFVideoCaptureStateDone             // 压缩完毕
};

@class JFVideoCapture;

/****【视频拍摄器协议】****/
@protocol JFVideoCaptureDelegate <NSObject>
@optional

// ------[要么回调视频，要么回调图片]------
/**
 回调: 返回拍摄的视频数据;

 @param videoCapture 视频采集器;
 @param videoURL 拍摄的视频保存地址;
 @param thumbnail 首帧截图;
 */
- (void) jf_videoCapture:(JFVideoCapture*)videoCapture didFinishedCaptureWithVideoURL:(NSURL*)videoURL thumbnail:(UIImage*)thumbnail;


/**
 回调: 返回拍摄的照片;

 @param videoCapture 视频采集器;
 @param image 拍摄的图片;
 */
- (void) jf_videoCapture:(JFVideoCapture*)videoCapture didFinishedCaptureWithImage:(UIImage*)image;

@end


/****【视频拍摄器】****/
@interface JFVideoCapture : UIView

# pragma mark - 状态
// 控制整个流程
@property (nonatomic, assign) JFVideoCaptureState state;
// 视频时长计数;
@property (nonatomic, assign) CGFloat duration;

# pragma mark - 配置
// 是否保存相册;默认:YES
@property (nonatomic, assign) BOOL shouldSaveVideo;
// 是否压缩视频;默认:YES
@property (nonatomic, assign) BOOL shouldCompressVideo;
// 拍摄时长限制(在时间到达时自动停止拍摄);默认:30s
@property (nonatomic, assign) NSInteger captureTimeLimit;
// 拍照片和视频的分界时间;默认:0.5s
@property (nonatomic, assign) CGFloat startLimitTime;
// 是否显示拍摄时间;默认:YES
@property (nonatomic, assign) BOOL shouldShowTiming;

# pragma mark - 协议
@property (nonatomic, weak) id<JFVideoCaptureDelegate> delegate; // 用于数据和状态的回调

# pragma mark - 操作
// 停止拍摄(在外部用于中断录制)
- (void) stopCapturing;

@end



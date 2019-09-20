//
//  JFVideoCapture.m
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import "JFVideoCapture.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import <Photos/Photos.h>
#import "JFVideoPathHelper.h"
#import "JFVideoCaptureBtn.h"



@interface JFVideoCapture() <AVCaptureFileOutputRecordingDelegate>

// 采集器会话;
@property (nonatomic, strong) AVCaptureSession* captureSession;
// 音频设备;
@property (nonatomic, strong) AVCaptureDevice* audioDevice;
// 视频设备;
@property (nonatomic, strong) AVCaptureDevice* videoDevice;
// 音频输入源;
@property (nonatomic, strong) AVCaptureDeviceInput* audioInput;
// 视频输入源;
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
// 多媒体输出源;
@property (nonatomic, strong) AVCaptureMovieFileOutput* movieFileOutput;

// 倒计时;
@property (nonatomic, weak) NSTimer* timer;

// 采集按钮;
@property (nonatomic, strong) JFVideoCaptureBtn* captureBtn;
// 撤销按钮;
@property (nonatomic, strong) UIButton* revokeBtn;
// 完成按钮;
@property (nonatomic, strong) UIButton* doneBtn;
// 提示信息
@property (nonatomic, strong) UILabel* noteLabel;
// 图片视图:如果拍摄了图片
@property (nonatomic, strong) UIImageView* takenImageView;

// 拍摄的是视频|图片; YES:视频; NO:图片; 默认:NO;
@property (nonatomic, assign) BOOL isVideo;

// 缓存视频的url
@property (nonatomic, copy) NSURL* videoCachedURL;
// 拍照的图片
@property (nonatomic, copy) UIImage* imageTaken;

// 视频播放
@property (nonatomic, strong) AVPlayer* videoPlayer;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, strong) AVPlayerLayer* videoPalyerLayer;
@property (nonatomic, assign) NSTimeInterval videoDuration;

// 聚焦
@property (nonatomic, assign) BOOL isFocus;
@property (nonatomic, strong) UIImageView* focusCursor;

@property (nonatomic, strong) MASConstraint* revokeCenterXCostraint;
@property (nonatomic, strong) MASConstraint* doneCenterXCostraint;

@end


@implementation JFVideoCapture

# pragma mark - KVO

// 监听state的变动;控制整个拍摄流程;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.state) {
                // 等待拍摄
            case JFVideoCaptureStateWaiting:
            {
                [self showHandleViews:NO];
                self.imageTaken = nil;
                self.takenImageView.image = nil;
                self.captureBtn.hiddenProgress = YES;
                [self startRunning];
                [self animateShowNoteLabel];
                [self resetPlayer];
            }
                break;
                // 正在拍摄
            case JFVideoCaptureStateExecuting:
            {
                [self startTimer];
                [self startCapturing];
                self.captureBtn.hiddenProgress = NO;
            }
                break;
                // 拍摄完毕，正在压缩
            case JFVideoCaptureStateCompressing:
            {
                [self stopRunning];
                [self stopTimer];
                self.captureBtn.hiddenProgress = YES;
                [self stopCapturing];
            }
                break;
                // 压缩完毕
            case JFVideoCaptureStateDone:
            {
                // 动画显示操作按钮
                [self showHandleViews:YES];
                if (self.isVideo) {
                    [self playVideo];
                }
            }
                break;
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"status"]) {
        if (self.playerItem && self.playerItem.status == AVPlayerStatusReadyToPlay) {
            self.videoDuration = CMTimeGetSeconds(self.playerItem.duration);
            [self.playerItem removeObserver:self forKeyPath:@"status"];
        }
    }
}


# pragma mark - 录制
// 开始摄影
- (void)startRunning {
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}
// 停止摄影
- (void)stopRunning {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}
// 开始录制
- (void)startCapturing {
    if (![self.movieFileOutput isRecording]) {
        self.videoCachedURL = [NSURL fileURLWithPath:[JFVideoPathHelper videoPathForCurTime]];
        // 开始录制
        [self.movieFileOutput startRecordingToOutputFileURL:self.videoCachedURL recordingDelegate:self];
    }
}
// 停止录制
- (void)stopCapturing {
    if ([self.movieFileOutput isRecording]) {
        [self.movieFileOutput stopRecording];
    }
}


# pragma mark - 功能按钮
// touch down :点下录制按钮
- (IBAction) touchDownOnCaptureBtn:(id)sender {
    self.state = JFVideoCaptureStateExecuting;
    self.captureBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
}
// touch up outside: 停止
- (IBAction) touchUpOutsideOnCaptureBtn:(id)sender {
    self.captureBtn.backgroundColor = [UIColor whiteColor];
    if (self.state != JFVideoCaptureStateExecuting) {
        return;
    }
    // 先停止计时;然后延时停止拍摄(视频就不用延时了)
    [self stopTimer];
    if (self.timeCount < self.startLimitTime) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.state = JFVideoCaptureStateCompressing;
        });
    } else {
        self.state = JFVideoCaptureStateCompressing;
    }
}
// touch up inside: 停止
- (IBAction) touchUpInsideOnCaptureBtn:(id)sender {
    self.captureBtn.backgroundColor = [UIColor whiteColor];
    if (self.state != JFVideoCaptureStateExecuting) {
        return;
    }
    // 先停止计时;然后延时停止拍摄(视频就不用延时了)
    [self stopTimer];
    if (self.timeCount < self.startLimitTime) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.state = JFVideoCaptureStateCompressing;
        });
    } else {
        self.state = JFVideoCaptureStateCompressing;
    }
}
// 撤销
- (IBAction) clickedRevokeBtn:(id)sender {
    // 删除原有的视频
    [JFVideoPathHelper removeVideoWithURL:self.videoCachedURL];
    // 恢复状态到准备
    self.state = JFVideoCaptureStateWaiting;
}
// 完成
- (IBAction) clickedDoneBtn:(id)sender {
    if (self.state != JFVideoCaptureStateDone) {
        return;
    }
    __weak typeof(self) wself = self;
    if (self.shouldSaveVideo) {
        // 保存视频到相册
        [JFVideoPathHelper savingVideoIntoAlbumWithURL:self.videoCachedURL completionHandler:^(BOOL success, NSError *error) {
            // 保存完就回调出去
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself callBackWithSuccess];
                });
            }
        }];
    } else {
        // 回调
        [self callBackWithSuccess];
    }
}
# pragma mark - 定时器
// 启动定时器
- (void) startTimer {
    self.timeCount = 0;
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(countingTimer) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
// 关闭定时器
- (void) stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
// 计时
- (void) countingTimer {
    if (self.timeCount == self.captureDuration) {
        self.state = JFVideoCaptureStateCompressing;
        return;
    }
    self.timeCount += 0.1;
}

# pragma mark - private

/**
 显示|隐藏操作按钮
 show:YES : 完成了视频|图片压缩，显示完成和撤销按钮，并隐藏拍摄按钮
 show:NO  : 重新开始拍摄，隐藏完成和撤销按钮，并显示拍摄按钮
 @param show YES|NO
 */
- (void) showHandleViews:(BOOL)show {
    if (show) {
        self.captureBtn.hidden = YES;
        self.revokeBtn.hidden = NO;
        self.doneBtn.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.revokeCenterXCostraint uninstall];
            [self.revokeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.revokeCenterXCostraint = make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
            }];
            [self.doneCenterXCostraint uninstall];
            [self.doneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.doneCenterXCostraint = make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
            }];
            [self layoutIfNeeded];
        } completion:nil];
    }
    else {
        self.captureBtn.hidden = NO;
        self.captureBtn.progress = 0;
        self.revokeBtn.hidden = YES;
        self.doneBtn.hidden = YES;
        [self.revokeCenterXCostraint uninstall];
        [self.revokeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            self.revokeCenterXCostraint = make.centerX.mas_equalTo(0);
        }];
        [self.doneCenterXCostraint uninstall];
        [self.doneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            self.doneCenterXCostraint = make.centerX.mas_equalTo(0);
        }];
    }

}

// 压缩视频
- (void) compressVideoWithURL:(NSURL*)fromURL onCompletion:(void (^) (void))completion {
    // 先截取首帧图片
    [self compressPictureWithURL:fromURL onCompletion:^{
        NSURL* toURL = [NSURL fileURLWithPath:[[JFVideoPathHelper videoPathForSaving] stringByAppendingPathComponent:@"temp.mp4"]];
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:fromURL options:nil];
        AVAssetExportSession* session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        session.outputURL = toURL;
        session.shouldOptimizeForNetworkUse = YES;
        session.outputFileType = AVFileTypeMPEG4;
        [session exportAsynchronouslyWithCompletionHandler:^{
            if (session.status == AVAssetExportSessionStatusCompleted) {
                // 压缩完毕:将压缩后的视频覆盖原来的视频
                NSFileManager* fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtURL:fromURL error:nil];
                [fileManager moveItemAtURL:toURL toURL:fromURL error:nil];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion();
                    });
                }
            }
        }];
    }];
}

// 压缩图片
- (void) compressPictureWithURL:(NSURL*)fromURL onCompletion:(void (^) (void))completion {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:fromURL];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    CMTimeShow(actucalTime);
    self.imageTaken = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    completion();
}

// 成功回调出去
- (void) callBackWithSuccess {
    if (self.isVideo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jf_videoCapture:didFinishedCaptureWithVideoURL:thumbnail:)]) {
            [self.delegate jf_videoCapture:self didFinishedCaptureWithVideoURL:self.videoCachedURL thumbnail:self.imageTaken];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jf_videoCapture:didFinishedCaptureWithImage:)]) {
            [self.delegate jf_videoCapture:self didFinishedCaptureWithImage:self.imageTaken];
        }
    }
}

// 播放视频
- (void) playVideo {
    if (self.videoCachedURL) {
        self.playerItem = [AVPlayerItem playerItemWithURL:self.videoCachedURL];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.videoPlayer play];
        self.videoPalyerLayer.hidden = NO;
    }
}
// 重置视频
- (void) resetPlayer {
    [self.videoPlayer pause];
    [self.videoPlayer replaceCurrentItemWithPlayerItem:nil];
    self.videoPalyerLayer.hidden = YES;
}

// 动画显示提示信息
- (void) animateShowNoteLabel {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.noteLabel.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.noteLabel.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    });
    
}

/*********聚焦**********/
/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.captureSession isRunning]) {
        CGPoint point= [tapGesture locationInView:self];
        //将UI坐标转化为摄像头坐标
        AVCaptureVideoPreviewLayer* avLayer = (AVCaptureVideoPreviewLayer*)self.layer;
        CGPoint cameraPoint= [avLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusAtPoint:cameraPoint];
    }
}
- (void) focusAtPoint:(CGPoint)point {
    AVCaptureDevice *captureDevice= [self.videoInput device];
    if (captureDevice.isFocusPointOfInterestSupported &&
        [captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            captureDevice.focusPointOfInterest = point;
            captureDevice.focusMode = AVCaptureFocusModeAutoFocus;
            [captureDevice unlockForConfiguration];
        }
    }
}

//- (void)onHiddenFocusCurSorAction {
//    self.focusCursor.alpha=0;
//    self.isFocus = NO;
//}

// 设置聚焦光标位置
-(void) setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus) {
        self.isFocus = YES;
        self.focusCursor.center=point;
        self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
        self.focusCursor.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.focusCursor.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.focusCursor.alpha=0;
                self.isFocus = NO;
            });
//            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}


# pragma mark - AVCaptureFileOutputRecordingDelegate

// 录制完毕
- (void)                captureOutput:(AVCaptureFileOutput *)output
  didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                      fromConnections:(NSArray<AVCaptureConnection *> *)connections
                                error:(nullable NSError *)error
{
    if (error) {
        [self stopTimer];
        self.state = JFVideoCaptureStateWaiting;
        return;
    }
    __weak typeof(self) wself = self;
    // 如果是视频
    if (self.isVideo) {
        if (self.shouldCompressVideo) {
            // 压缩视频
            [self compressVideoWithURL:outputFileURL onCompletion:^{
                wself.state = JFVideoCaptureStateDone;
            }];
        } else {
            self.state = JFVideoCaptureStateDone;
        }
    }
    // 如果是图片
    else {
        // 压缩图片
        [self compressPictureWithURL:outputFileURL onCompletion:^{
            wself.state = JFVideoCaptureStateDone;
        }];
    }
    
}


# pragma mark - life cycle

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (void) dealloc {
    [self removeObserver:self forKeyPath:@"state"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupDatas];
    }
    return self;
}

- (void) setupDatas {
    self.backgroundColor = [UIColor blackColor];
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    _shouldSaveVideo = YES; // 默认保存视频到相册
    _shouldCompressVideo = YES; // 默认压缩视频
    self.captureDuration = 60; // 默认60秒
    _startLimitTime = 0.5;
    AVCaptureVideoPreviewLayer* avLayer = (AVCaptureVideoPreviewLayer*)self.layer;
    avLayer.session = self.captureSession;
    avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.state = JFVideoCaptureStateWaiting;
}

- (void) setupViews {
    [self.layer addSublayer:self.videoPalyerLayer];
    [self addSubview:self.takenImageView];
    [self addSubview:self.captureBtn];
    [self addSubview:self.revokeBtn];
    [self addSubview:self.doneBtn];
    [self addSubview:self.noteLabel];
    [self addSubview:self.focusCursor];
    
    self.revokeBtn.hidden = YES;
    self.doneBtn.hidden = YES;
    
    [self.takenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.captureBtn.layer.cornerRadius = JFVideoCaptureBtnWidth * 0.5;
    [self.captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-JFVideoCaptureBtnBottm);
        make.width.height.mas_equalTo(JFVideoCaptureBtnWidth);
    }];
    [self.revokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captureBtn.mas_centerY);
        make.width.height.mas_equalTo(JFVideoRevokeBtnWidth);
        self.revokeCenterXCostraint = make.centerX.mas_equalTo(0);
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captureBtn.mas_centerY);
        make.width.height.mas_equalTo(JFVideoDoneBtnWidth);
        self.doneCenterXCostraint = make.centerX.mas_equalTo(0);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.captureBtn.mas_top).offset(-15);
    }];
    
    [self addGenstureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.videoPalyerLayer.frame = self.bounds;
}

# pragma mark - setter
- (void)setCaptureDuration:(NSInteger)captureDuration {
    _captureDuration = captureDuration;
}
- (void)setTimeCount:(CGFloat)timeCount {
    _timeCount = timeCount;
    if (timeCount < 0.01 || timeCount >= self.startLimitTime) {
        self.captureBtn.progress = (CGFloat)timeCount/(CGFloat)self.captureDuration;
    }
    // 设置是视频|图片
    self.isVideo = timeCount > self.startLimitTime;
}

# pragma mark - getter
- (AVCaptureDevice *)audioDevice {
    if (!_audioDevice) {
        _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    }
    return _audioDevice;
}
- (AVCaptureDeviceInput *)audioInput {
    if (!_audioInput) {
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:NULL];
    }
    return _audioInput;
}
- (AVCaptureDevice *)videoDevice {
    if (!_videoDevice) {
        NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice* device in devices) {
            if (device.position == AVCaptureDevicePositionBack) {
                _videoDevice = device;
                break;
            }
        }
    }
    return _videoDevice;
}
- (AVCaptureDeviceInput *)videoInput {
    if (!_videoInput) {
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:NULL];
    }
    return _videoInput;
}
- (AVCaptureMovieFileOutput *)movieFileOutput {
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _movieFileOutput;
}
- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        if ([_captureSession canAddInput:self.audioInput]) [_captureSession addInput:self.audioInput];
        if ([_captureSession canAddInput:self.videoInput]) [_captureSession addInput:self.videoInput];
        if ([_captureSession canAddOutput:self.movieFileOutput]) [_captureSession addOutput:self.movieFileOutput];
    }
    return _captureSession;
}

- (JFVideoCaptureBtn *)captureBtn {
    if (!_captureBtn) {
        _captureBtn = [JFVideoCaptureBtn new];
        _captureBtn.backgroundColor = [UIColor whiteColor];
        _captureBtn.hiddenProgress = YES;
        [_captureBtn addTarget:self action:@selector(touchDownOnCaptureBtn:) forControlEvents:UIControlEventTouchDown];
        [_captureBtn addTarget:self action:@selector(touchUpInsideOnCaptureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_captureBtn addTarget:self action:@selector(touchUpOutsideOnCaptureBtn:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _captureBtn;
}

- (UIButton *)revokeBtn {
    if (!_revokeBtn) {
        _revokeBtn = [UIButton new];
        [_revokeBtn setImage:[UIImage imageNamed:JFVideoImageNameRevoke] forState:UIControlStateNormal];
        [_revokeBtn addTarget:self action:@selector(clickedRevokeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revokeBtn;
}
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        [_doneBtn setImage:[UIImage imageNamed:JFVideoImageNameDoneBlue] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(clickedDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [UILabel new];
        _noteLabel.textColor = [UIColor whiteColor];
        _noteLabel.font = [UIFont systemFontOfSize:14];
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        _noteLabel.text = @"轻触拍照，按住摄像";
        _noteLabel.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
        _noteLabel.layer.shadowOffset = CGSizeMake(0, 0);
        _noteLabel.layer.shadowRadius = 4;
        _noteLabel.layer.shadowOpacity = 1;
        
    }
    return _noteLabel;
}
- (UIImageView *)takenImageView {
    if (!_takenImageView) {
        _takenImageView = [UIImageView new];
    }
    return _takenImageView;
}
- (AVPlayer *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [AVPlayer new];
        __weak typeof(self) wself = self;
        [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 30)
                                                   queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                              usingBlock:^(CMTime time) {
                                                  NSTimeInterval duration = CMTimeGetSeconds(time);
                                                  if (wself.videoDuration > 0 && duration >= wself.videoDuration) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [wself.playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                                                              if (finished) {
                                                                  [wself.videoPlayer play];
                                                              }
                                                          }];
                                                      });
                                                  }
                                              }];
    }
    return _videoPlayer;
}
- (AVPlayerLayer *)videoPalyerLayer {
    if (!_videoPalyerLayer) {
        _videoPalyerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        _videoPalyerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _videoPalyerLayer;
}
- (UIImageView *)focusCursor {
    if (!_focusCursor) {
        _focusCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_capture_focus"]];
        _focusCursor.contentMode = UIViewContentModeScaleAspectFit;
        _focusCursor.alpha = 0;
        _focusCursor.bounds = CGRectMake(0, 0, 64, 64);
    }
    return _focusCursor;
}

@end

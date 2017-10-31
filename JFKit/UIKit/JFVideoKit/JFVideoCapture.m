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

@property (nonatomic, strong) AVCaptureSession* captureSession; // 采集器会话;
@property (nonatomic, strong) AVCaptureDevice* audioDevice; // 音频设备;
@property (nonatomic, strong) AVCaptureDevice* videoDevice; // 视频设备;
@property (nonatomic, strong) AVCaptureDeviceInput* audioInput; // 音频输入源;
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput; // 视频输入源;
@property (nonatomic, strong) AVCaptureMovieFileOutput* movieFileOutput; // 多媒体输入源;

@property (nonatomic, weak) NSTimer* timer; // 倒计时;

@property (nonatomic, strong) JFVideoCaptureBtn* captureBtn; // 采集按钮;
@property (nonatomic, strong) UIButton* revokeBtn; // 撤销按钮;
@property (nonatomic, strong) UIButton* doneBtn; // 完成按钮;
@property (nonatomic, strong) UILabel* timerLabel; // 计时器标签;
@property (nonatomic, strong) UILabel* noteLabel; // 提示信息

@property (nonatomic, copy) NSURL* videoCachedURL; // 缓存视频的url
@end


@implementation JFVideoCapture

# pragma mark - public
- (void)stopCapturing {
    self.state = JFVideoCaptureStateDone;
    [self stopRunning];
    [self stopRecording];
}

- (void)startRunning {
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}
- (void)stopRunning {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}
- (void)startCapturing {
    if ([self.captureSession isRunning]) {
        self.state = JFVideoCaptureStateExecuting;
        [self doStartCapturing];
    }
}

# pragma mark - IBActions
// 点下录制按钮
- (IBAction) touchDownOnCaptureBtn:(id)sender {
    if (self.state == JFVideoCaptureStateDone) {
        // 重新录制的要撤销原来的视频
        [self clickedRevokeBtn:nil];
    }
    [self startCapturing];
}
// touch up outside
- (IBAction) touchUpOutsideOnCaptureBtn:(id)sender {
    [self stopCapturing];
}
// touch up inside
- (IBAction) touchUpInsideOnCaptureBtn:(id)sender {
    [self stopCapturing];
}
// 撤销
- (IBAction) clickedRevokeBtn:(id)sender {
    // 删除原有的视频
    [JFVideoPathHelper removeVideoWithURL:self.videoCachedURL];
    // 重置状态
    [self resetState];
}
// 完成
- (IBAction) clickedDoneBtn:(id)sender {
    __weak typeof(self) wself = self;
    if (self.shouldSaveVideo) {
        // 保存视频到相册
        [JFVideoPathHelper savingVideoIntoAlbumWithURL:self.videoCachedURL completionHandler:^(BOOL success, NSError *error) {
            // 保存完就回调出去
            [wself callBackWithSuccess];
        }];
    } else {
        // 回调
        [self callBackWithSuccess];
    }
}


# pragma mark - private


// 重置状态
- (void) resetState {
    self.state = JFVideoCaptureStateWaiting;
}

// 开始录制
- (void) doStartCapturing {
    // 要保存的文件路径
    NSString* fullPath = [JFVideoPathHelper videoPathForCurTime];
    // 开始录制
    [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:fullPath] recordingDelegate:self];
}

// 停止录制
- (void) stopRecording {
    if ([self.movieFileOutput isRecording]) {
        [self.movieFileOutput stopRecording];
    }
}

// 启动定时器
- (void) startTimer {
    self.timerLabel.text = [NSString stringWithFormat:@"%ld", self.captureDuration];
    NSTimer* timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countingTimer) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
// 计时
- (void) countingTimer {
    NSInteger curDuration = [self.timerLabel.text integerValue];
    if (curDuration == 0) {
        [self stopCapturing];
        [self stopTimer];
    }
    // 时间标签
    self.timerLabel.text = [NSString stringWithFormat:@"%ld", curDuration > 0 ? curDuration - 1 : 0];
    // 拍摄进度条
    self.captureBtn.progress = (CGFloat)(self.captureDuration - self.timerLabel.text.integerValue)/(CGFloat)self.captureDuration;
}

// 关闭定时器
- (void) stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 压缩视屏
- (void) compressVideoWithURL:(NSURL*)fromURL onCompletion:(void (^) (void))completion {
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
}

// 成功回调出去
- (void) callBackWithSuccess {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jf_videoCapture:didFinishedCaptureWithVideoURL:)]) {
        [self.delegate jf_videoCapture:self didFinishedCaptureWithVideoURL:self.videoCachedURL];
    }
}

# pragma mark - AVCaptureFileOutputRecordingDelegate

// 录制完毕
- (void)                captureOutput:(AVCaptureFileOutput *)output
  didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                      fromConnections:(NSArray<AVCaptureConnection *> *)connections
                                error:(nullable NSError *)error
{
    // 保存视频的缓存路径
    self.videoCachedURL = outputFileURL;
    __weak typeof(self) wself = self;
    if (self.shouldCompressVideo) {
        // 压缩视频
        [self compressVideoWithURL:outputFileURL onCompletion:^{
            wself.state = JFVideoCaptureStateDone;
        }];
    } else {
        self.state = JFVideoCaptureStateDone;
    }
}

# pragma mark - KVO

// 监听state的变动
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.state) {
            // 等待拍摄
            case JFVideoCaptureStateWaiting:
            {
                self.timerLabel.text = [NSString stringWithFormat:@"%ld", self.captureDuration];
                self.revokeBtn.hidden = YES;
                self.doneBtn.hidden = YES;
                self.captureBtn.hiddenProgress = YES;
                [self startRunning];
            }
                break;
            // 正在拍摄
            case JFVideoCaptureStateExecuting:
            {
                self.revokeBtn.hidden = YES;
                self.doneBtn.hidden = YES;
                self.captureBtn.hiddenProgress = NO;
                self.captureBtn.progress = 0;
                self.captureBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
                [self startTimer];
            }
                break;
            // 拍摄完毕
            case JFVideoCaptureStateDone:
            {
                self.revokeBtn.hidden = NO;
                self.doneBtn.hidden = NO;
                self.captureBtn.hiddenProgress = YES;
                self.captureBtn.backgroundColor = [UIColor whiteColor];
                [self stopTimer];
            }
                break;
            default:
                break;
        }
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
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
    self.backgroundColor = [UIColor blackColor];
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    _shouldSaveVideo = YES;
    _shouldCompressVideo = YES;
    self.captureDuration = 0;
    self.state = JFVideoCaptureStateWaiting;
    ((AVCaptureVideoPreviewLayer*)self.layer).session = self.captureSession;
    ((AVCaptureVideoPreviewLayer*)self.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void) setupViews {
    [self addSubview:self.captureBtn];
    [self addSubview:self.timerLabel];
    [self addSubview:self.revokeBtn];
    [self addSubview:self.doneBtn];
    [self addSubview:self.noteLabel];
    
    self.captureBtn.layer.cornerRadius = JFVideoCaptureBtnWidth * 0.5;
    [self.captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(- JFVideoCaptureBtnBottm);
        make.width.height.mas_equalTo(JFVideoCaptureBtnWidth);
    }];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.captureBtn.mas_top).offset(-15);
    }];
    [self.revokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captureBtn.mas_centerY);
        make.centerX.equalTo(self.captureBtn.mas_left).multipliedBy(0.5);
        make.width.height.mas_equalTo(JFVideoRevokeBtnWidth);
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captureBtn.mas_centerY);
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5).offset(JFVideoCaptureBtnWidth * 0.25);
        make.width.height.mas_equalTo(JFVideoDoneBtnWidth);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.captureBtn.mas_bottom).offset(15);
    }];
}

# pragma mark - setter

- (void)setCaptureDuration:(NSInteger)captureDuration {
    _captureDuration = captureDuration;
    self.timerLabel.text = [NSString stringWithFormat:@"%ld", captureDuration];
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
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
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

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [UILabel new];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.font = [UIFont boldSystemFontOfSize:15];
        _timerLabel.textColor = [UIColor whiteColor];
    }
    return _timerLabel;
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
        _noteLabel.font = [UIFont systemFontOfSize:13];
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        _noteLabel.text = @"长按拍摄视频";
    }
    return _noteLabel;
}



@end

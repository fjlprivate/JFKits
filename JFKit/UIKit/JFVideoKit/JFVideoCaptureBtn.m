//
//  JFVideoCaptureBtn.m
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/25.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import "JFVideoCaptureBtn.h"

@interface JFVideoCaptureBtn()
@property (nonatomic, strong) CAShapeLayer* shaperLayer;
@end

@implementation JFVideoCaptureBtn

# pragma mark - tools

- (void) resetPathToShapeLayer {
    CGFloat radius = CGRectGetWidth(self.bounds) * 0.5 - self.progressWidth * 0.5;
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.progressWidth * 0.5, self.progressWidth * 0.5) cornerRadius:radius];
    self.shaperLayer.path = bezierPath.CGPath;
    self.shaperLayer.strokeEnd = 1;
}

# pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.shaperLayer];
        self.progressWidth = 4.f;
        self.progressTintColor = [UIColor blueColor];
        self.progress = 0;
        self.hiddenProgress = YES;
    }
    return self;
}

- (void)layoutSubviews {
    self.shaperLayer.frame = self.bounds;
    [self resetPathToShapeLayer];
}

# pragma mark - setter

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = [progressTintColor copy];
    _shaperLayer.strokeColor = progressTintColor.CGColor;
}
- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    _shaperLayer.lineWidth = progressWidth;
}
- (void)setProgress:(CGFloat)progress {
    if (progress > 1) {
        progress = 1;
    }
    else if (progress < 0) {
        progress = 0;
    }
    self.shaperLayer.strokeStart = progress;
}
- (void)setHiddenProgress:(BOOL)hiddenProgress {
    _hiddenProgress = hiddenProgress;
    self.shaperLayer.opacity = hiddenProgress ? 0 : 1;
}

# pragma mark - getter

- (CAShapeLayer *)shaperLayer {
    if (!_shaperLayer) {
        _shaperLayer = [CAShapeLayer layer];
        _shaperLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shaperLayer;
}

@end

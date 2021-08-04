//
//  JFToast.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/5/11.
//  Copyright © 2021 冯金龙(EX-FENGJINLONG001). All rights reserved.
//

#import "JFToast.h"
#import "UIFont+FontAwesome.h"

static CGFloat const JFToastIndicatorWidth = 34; // 指示器宽度
static CGFloat const JFToastIndicatorAnimationDuration = 1.05; // 指示器转一圈时间
static CGFloat const JFToastContentMaxWidthScale = 0.8; // 内容层宽度占superView宽度的最大比例
static CGFloat const JFToastContentMinWidthScale = 0.2; // 内容层宽度占superView宽度的最小比例


// ===== 内容层 =====
@interface JFToastContent : UIView
@property (nonatomic, assign) JFToastStyle style;
@property (nonatomic, strong) UILabel* labIndicator; // 指示器
@property (nonatomic, strong) UIImageView* imgContent;
@property (nonatomic, strong) UILabel* labContent;

- (instancetype) initWithStyle:(JFToastStyle)style title:(NSString*)title image:(UIImage*)image;

@property (nonatomic, assign) CGFloat imgHeight; // 宽度自适应
@property (nonatomic, assign) CGFloat gapTop;
@property (nonatomic, assign) CGFloat gapBottom;
@property (nonatomic, assign) CGFloat gapLeft;
@property (nonatomic, assign) CGFloat gapRight;
@property (nonatomic, assign) CGFloat gapImg2Title;
@property (nonatomic, assign) CGFloat indicatorSize;
@property (nonatomic, assign) BOOL shouldIndicatorAnimation;
@end


@implementation JFToast
@synthesize vContent = _vContent;


/// 等待：指示器+文字；需要主动hide；
/// @param text  没有文字时，只显示指示器；
+ (instancetype) waitingWithText:(nullable NSString*)text {
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleActivityText text:text image:nil inView:nil];
    return toast;
}

/// 仅显示文字；2s后消失
+ (instancetype) toastWithText:(NSString*)text {
    return [self toastWithText:text hideAfterSecs:2];
}
/// 仅显示文字；
/// @param text  【必须】要显示的文字
/// @param secs  几秒后消失；0时不消失；需要主动hide
+ (instancetype) toastWithText:(NSString*)text hideAfterSecs:(NSTimeInterval)secs {
    if (!text) {
        return nil;
    }
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleText text:text image:nil inView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast hide];
    });
    return toast;
}

/// 仅显示图片；2s后消失
+ (instancetype) toastWithImage:(UIImage*)image {
    return [self toastWithImage:image hideAfterSecs:2];
}
/// 仅显示图片
/// @param image  【必须】要显示的图片
/// @param secs  几秒后消失；0时不消失；需要主动hide
+ (instancetype) toastWithImage:(UIImage*)image hideAfterSecs:(NSTimeInterval)secs {
    if (!image) {
        return nil;
    }
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleImage text:nil image:image inView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast hide];
    });
    return toast;
}


/// 显示图片+文字
/// @param image 【必须】图片
/// @param text  【必须】文字
/// @param secs 几秒后消失；0时不消失；需要主动hide
+ (instancetype) toastWithImage:(UIImage*)image text:(NSString*)text hideAfterSecs:(NSTimeInterval)secs {
    if (!image || !text) {
        return nil;
    }
    JFToast* toast = [JFToast tostWithStyle:JFToastStyleImageText text:text image:image inView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast hide];
    });
    return toast;
}


/// 创建并加载toast
/// @param style  toast类型
/// @param text  文字
/// @param image  图片
/// @param view  加载在哪个视图;nil则为window
+ (instancetype) tostWithStyle:(JFToastStyle)style
                          text:(nullable NSString*)text
                         image:(nullable UIImage*)image
                        inView:(nullable UIView*)view
{
    JFToast* toast = [[JFToast alloc] initWithAnimateStyle:JFPresenterAnimateStyleFade];
    toast.bgColor = UIColor.clearColor;
    [toast setupWithStyle:style text:text image:image];
    [toast showInView:view];
    return toast;
}


- (void) setupWithStyle:(JFToastStyle)style
                   text:(nullable NSString*)text
                  image:(nullable UIImage*)image
{
    // 创建并加载content
    _vContent = [[JFToastContent alloc] initWithStyle:style title:text image:image];
    JFToastContent* toastContent = (JFToastContent*)_vContent;
    [self addSubview:self.vContent];
    [self setupDatas];
    [toastContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(0);
        make.width.greaterThanOrEqualTo(self.mas_width).multipliedBy(JFToastContentMinWidthScale);
        make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(JFToastContentMaxWidthScale);
        if (style == JFToastStyleImage) {
            make.bottom.greaterThanOrEqualTo(toastContent.imgContent.mas_bottom).offset(self.gapBottom);
        }
        else if (style == JFToastStyleActivity) {
            make.height.greaterThanOrEqualTo(toastContent.mas_width);
        }
        else {
            make.bottom.equalTo(toastContent.labContent.mas_bottom).offset(self.gapBottom);
        }
    }];
}


- (void) setupDatas {
    self.contBgColor = [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:0.99];
    self.contCornerRadius = 8;
    self.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.textColor = UIColor.blackColor;
    self.indicatorColor = UIColor.blackColor;
    self.lineSpacing = 4;
    self.imgHeight = 54;
    self.gapTop = self.gapBottom = 15;
    self.gapLeft = self.gapRight = 20;
    self.gapImg2Title = 10;
    self.indicator = FAGlass + 243;
    self.indicatorSize = 28;
    self.shouldIndicatorAnimation = YES;
}

- (JFToastContent*) toastContent {
    return (JFToastContent*)self.vContent;
}

#pragma mark - setter

- (void)setContBgColor:(UIColor *)contBgColor {
    _contBgColor = contBgColor;
    [self toastContent].backgroundColor = contBgColor;
}
- (void)setContCornerRadius:(CGFloat)contCornerRadius {
    _contCornerRadius = contCornerRadius;
    [self toastContent].layer.masksToBounds = YES;
    [self toastContent].layer.cornerRadius = contCornerRadius;
}
- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self toastContent].labContent.font = textFont;
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self toastContent].labContent.textColor = textColor;
}
- (void)setImgHeight:(CGFloat)imgHeight {
    _imgHeight = imgHeight;
    [self toastContent].imgHeight = imgHeight;
}
- (void)setGapTop:(CGFloat)gapTop {
    _gapTop = gapTop;
    [self toastContent].gapTop = gapTop;
}
- (void)setGapBottom:(CGFloat)gapBottom {
    _gapBottom = gapBottom;
    [self toastContent].gapBottom = gapBottom;
}
- (void)setGapLeft:(CGFloat)gapLeft {
    _gapLeft = gapLeft;
    [self toastContent].gapLeft = gapLeft;
}
- (void)setGapRight:(CGFloat)gapRight {
    _gapRight = gapRight;
    [self toastContent].gapRight = gapRight;
}
- (void)setGapImg2Title:(CGFloat)gapImg2Title {
    _gapImg2Title = gapImg2Title;
    [self toastContent].gapImg2Title = gapImg2Title;
}
- (void)setIndicatorSize:(CGFloat)indicatorSize {
    _indicatorSize = indicatorSize;
    [self toastContent].indicatorSize = indicatorSize;
}
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    [self toastContent].labIndicator.textColor = indicatorColor;
}
- (void)setIndicator:(FAIcon)indicator {
    [self toastContent].labIndicator.text = [NSString fontAwesomeIconStringForEnum:indicator];
}
- (void)setShouldIndicatorAnimation:(BOOL)shouldIndicatorAnimation {
    [self toastContent].shouldIndicatorAnimation = shouldIndicatorAnimation;
}

@end



// ===== 内容层 =====
@interface JFToastContent()

@end
@implementation JFToastContent

- (instancetype) initWithStyle:(JFToastStyle)style
                         title:(NSString*)title
                         image:(UIImage*)image {
    if (self = [super initWithFrame:CGRectZero]) {
        self.style = style;
        if (style == JFToastStyleText) {
            NSAssert(title, @"");
            self.labContent.text = title;
            [self addSubview:self.labContent];
        }
        else if (style == JFToastStyleImage) {
            NSAssert(image, @"");
            self.imgContent.image = image;
            [self addSubview:self.imgContent];
        }
        else if (style == JFToastStyleActivity) {
            [self addSubview:self.labIndicator];
        }
        else if (style == JFToastStyleActivityText) {
            NSAssert(title, @"");
            self.labContent.text = title;
            self.labContent.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.labIndicator];
            [self addSubview:self.labContent];
        }
        else if (style == JFToastStyleImageText) {
            NSAssert(title, @"");
            NSAssert(image, @"");
            self.labContent.text = title;
            [self addSubview:self.labContent];
            self.imgContent.image = image;
            [self addSubview:self.imgContent];
        }
        [self remakeConstant];
    }
    return self;
}


- (void) remakeConstant {
    if (self.style == JFToastStyleText) {
        [self.labContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gapLeft);
            make.right.mas_equalTo(-self.gapRight);
            make.top.mas_equalTo(self.gapTop);
        }];
    }
    else if (self.style == JFToastStyleImage) {
        CGFloat rate = 1;
        if (self.imgContent.image) {
            CGSize size = self.imgContent.image.size;
            if (size.height > 0) {
                rate = size.width/size.height;
            }
        }
        [self.imgContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gapLeft);
            make.right.mas_equalTo(-self.gapRight);
            make.top.mas_greaterThanOrEqualTo(self.gapTop);
            make.height.mas_equalTo(self.imgHeight);
            make.width.equalTo(self.imgContent.mas_height).multipliedBy(rate);
            make.centerY.mas_equalTo(0);
        }];
    }
    else if (self.style == JFToastStyleActivity) {
        [self.labIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gapLeft);
            make.right.mas_equalTo(-self.gapRight);
            make.centerY.mas_equalTo(0);
        }];
    }
    else if (self.style == JFToastStyleActivityText) {
        [self.labIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.gapTop);
            make.width.height.mas_equalTo(JFToastIndicatorWidth);
        }];
        [self.labContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gapLeft);
            make.right.mas_equalTo(-self.gapRight);
            make.top.equalTo(self.labIndicator.mas_bottom).offset(self.gapImg2Title);
        }];
    }
    else if (self.style == JFToastStyleImageText) {
        [self.imgContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.gapTop);
            make.height.mas_equalTo(self.imgHeight);
        }];
        [self.labContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gapLeft);
            make.right.mas_equalTo(-self.gapRight);
            make.top.equalTo(self.imgContent.mas_bottom).offset(self.gapImg2Title);
        }];
    }
}

#pragma mark - 动画
- (void) startIndicatorAnimating {
    // 旋转 
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = JFToastIndicatorAnimationDuration;
    animation.repeatCount = 10000;
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    [self.labIndicator.layer addAnimation:animation forKey:@"rotationAnimation"];
}
- (void) stopIndicatorAnimating {
    [self.labIndicator.layer removeAllAnimations];
}

#pragma mark - setter

- (void)setImgHeight:(CGFloat)imgHeight {
    _imgHeight = imgHeight;
    [self remakeConstant];
}
- (void)setGapTop:(CGFloat)gapTop {
    _gapTop = gapTop;
    [self remakeConstant];
}
- (void)setGapLeft:(CGFloat)gapLeft {
    _gapLeft = gapLeft;
    [self remakeConstant];
}
- (void)setGapRight:(CGFloat)gapRight {
    _gapRight = gapRight;
    [self remakeConstant];
}
- (void)setGapImg2Title:(CGFloat)gapImg2Title {
    _gapImg2Title = gapImg2Title;
    [self remakeConstant];
}
- (void)setIndicatorSize:(CGFloat)indicatorSize {
    _indicatorSize = indicatorSize;
    self.labIndicator.font = [UIFont fontAwesomeFontOfSize:indicatorSize];
    // 需要刷新布局么
}
- (void)setShouldIndicatorAnimation:(BOOL)shouldIndicatorAnimation {
    if (shouldIndicatorAnimation) {
        [self startIndicatorAnimating];
    } else {
        [self stopIndicatorAnimating];
    }
}

#pragma mark - getter

- (UILabel *)labIndicator {
    if (!_labIndicator) {
        _labIndicator = [UILabel new];
        _labIndicator.textAlignment = NSTextAlignmentCenter;
    }
    return _labIndicator;
}


- (UIImageView *)imgContent {
    if (!_imgContent) {
        _imgContent = [UIImageView new];
        _imgContent.contentMode = UIViewContentModeScaleAspectFit;
        _imgContent.clipsToBounds = YES;
    }
    return _imgContent;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

@end



//
//  JFAlertView.m
//  AntPocket
//
//  Created by JohhnyFeng on 2020/5/15.
//  Copyright © 2020 AntPocket. All rights reserved.
//

#import "JFAlertView.h"
#import <Masonry.h>
#import <objc/runtime.h>
#import "JFHelper.h"


const char* JFAlertBtnActionKey = "JFAlertBtnActionKey";

@interface JFAlertView()
// 背景视图
@property (nonatomic, strong) UIView* bgView;
// 内容视图
@property (nonatomic, strong) UIView* contentView;
// 图标
@property (nonatomic, strong) UIImageView* imageView;
// 按钮区的背景视图
@property (nonatomic, strong) UIView* btnBgView;
// 按钮组
@property (nonatomic, strong) NSMutableArray* btnList;

@end


@implementation JFAlertView

# pragma mark - public

/// 创建JFAlertView
/// @param title 标题
/// @param detail 详情文本
/// @param image 图标
+ (instancetype) alertWithTitle:(nullable NSString*)title detail:(nullable NSString*)detail image:(nullable UIImage*)image {
     JFAlertView* alert = [[JFAlertView alloc] initWithFrame:CGRectZero];
    alert.labTitle.text = title;
    alert.labDetail.text = detail;
    alert.image = image;
    return alert;
}

/// 添加按钮
/// @param title 按钮标题
/// @param textColor [可选]文本颜色
/// @param textFont [可选]文本字体
/// @param bgColor [可选]按钮背景色
/// @param action 按钮事件；
- (void) addButtonWithTitle:(NSString*)title
                  textColor:(nullable UIColor*)textColor
                   textFont:(nullable UIFont*)textFont
                    bgColor:(nullable UIColor*)bgColor
                     action:(void (^) (void))action
{
    UIButton* btn = [[UIButton alloc] init];
    [self.btnList addObject:btn];
    [self.contentView addSubview:btn];
    if (title && title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    UIColor* normalColor = textColor ? textColor:self.labDetail.textColor;
    UIColor* highlightColor = [normalColor colorWithAlphaComponent:0.4];
    [btn setTitleColor:normalColor  forState:UIControlStateNormal];
    [btn setTitleColor:highlightColor  forState:UIControlStateHighlighted];

    btn.titleLabel.font = textFont ? textFont:self.labDetail.font;
    if (bgColor) {
        btn.backgroundColor = bgColor;
    } else {
        btn.backgroundColor = self.contentBgColor;
    }
    if (action) {
        objc_setAssociatedObject(btn, JFAlertBtnActionKey, action, OBJC_ASSOCIATION_COPY);
    }
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
}

// 显示
- (void) show {
    if (self.superview) {
        return;
    }
    [self setupViews];
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView performWithoutAnimation:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.bgView.alpha = 0;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 1;
    }];
}
// 隐藏
- (void) hide {
    if (!self.superview) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

# pragma mark - private

- (void) setupViews {
    self.bgView.backgroundColor = self.bgColor;
    self.contentView.backgroundColor = self.contentBgColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = self.cornerRadius;
    if (self.btnSeperatorStyle == JFAlertButtonSeperatorStyleLine) {
        self.btnBgView.hidden = NO;
    } else {
        self.btnBgView.hidden = YES;
    }
    // 有自定义视图，则只加载自定义视图
    if (self.customView) {
        [self.contentView addSubview:self.customView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.height.equalTo(self.customView);
        }];
    }
    // 无自定义视图，加载默认的元素
    else {
        [self.contentView addSubview:self.labDetail];
        [self.contentView addSubview:self.labTitle];
        
        if (self.image) {
            self.imageView.image = self.image;
            [self.contentView addSubview:self.imageView];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(self.fGapL);
                make.height.mas_equalTo(self.imageSize);
            }];
        }
        
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fGapL);
            make.right.mas_equalTo(-self.fGapL);
            if (self.image) {
                make.top.equalTo(self.imageView.mas_bottom).offset(self.fGapM);
            } else {
                make.top.mas_equalTo(self.fGapL);
            }
        }];
        [self.labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fGapL);
            make.right.mas_equalTo(-self.fGapL);
            make.top.equalTo(self.labTitle.mas_bottom).offset((self.labTitle.text || self.labTitle.attributedText) ? self.fGapS:0);
        }];
        
        
        [self.contentView addSubview:self.btnBgView];
        [self.btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if (self.btnSeperatorStyle == JFAlertButtonSeperatorStyleSpace) {
                make.height.mas_equalTo(self.btnList.count > 0 ? self.btnHeight + self.btnSeperatorInsetV:0 );
            }
            else if (self.btnSeperatorStyle == JFAlertButtonSeperatorStyleLine) {
                make.height.mas_equalTo(self.btnList.count > 0 ? self.btnHeight + 1:0 );
            }
            if (self.labDetail.text.length > 0 || self.labDetail.attributedText.length > 0) {
                make.top.equalTo(self.labDetail.mas_bottom).offset(self.fGapL);
            }
            else if (self.labTitle.text.length > 0 || self.labTitle.attributedText.length > 0) {
                make.top.equalTo(self.labDetail.mas_bottom).offset(self.fGapL - self.fGapS);
            }
            else {
                make.top.equalTo(self.labDetail.mas_bottom).offset(self.fGapL);
            }
        }];
        
        UIButton* preBtn = nil;
        for (UIButton* btn in self.btnList) {
            [self.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.btnSeperatorStyle == JFAlertButtonSeperatorStyleSpace) {
                    btn.layer.cornerRadius = self.btnCornerRadius;
                    make.top.equalTo(self.btnBgView.mas_top).offset(1);
                    make.bottom.equalTo(self.btnBgView.mas_bottom).offset(-self.btnSeperatorInsetV);
                    if (preBtn) {
                        make.left.equalTo(preBtn.mas_right).offset(self.btnSeperatorInsetH);
                        make.width.equalTo(preBtn.mas_width);
                    } else {
                        make.left.mas_equalTo(self.btnSeperatorInsetH);
                    }
                    if (btn == self.btnList.lastObject) {
                        make.right.equalTo(self.btnBgView).offset(-self.btnSeperatorInsetH);
                    }
                }
                else if (self.btnSeperatorStyle == JFAlertButtonSeperatorStyleLine) {
                    btn.layer.cornerRadius = 0;
                    make.top.equalTo(self.btnBgView.mas_top).offset(1);
                    make.bottom.equalTo(self.btnBgView.mas_bottom);
                    if (preBtn) {
                        make.left.equalTo(preBtn.mas_right).offset(1);
                        make.width.equalTo(preBtn.mas_width);
                    } else {
                        make.left.mas_equalTo(0);
                    }
                    if (btn == self.btnList.lastObject) {
                        make.right.equalTo(self.btnBgView);
                    }
                }
                
            }];
            preBtn = btn;
        }

        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(JFScaleWidth6(40));
            make.right.mas_equalTo(JFScaleWidth6(-40));
            make.centerY.mas_equalTo(0);
            make.bottom.equalTo(self.btnBgView.mas_bottom);
        }];

    }
    
}

- (IBAction) clickedBtn:(UIButton*)sender {
    void (^ handleBlock) (void) = objc_getAssociatedObject(sender, JFAlertBtnActionKey);
    if (handleBlock) {
        handleBlock();
    }
    [self hide];
}

- (void) handleWithTapGes:(UITapGestureRecognizer*)tapGes {
    CGPoint location = [tapGes locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, location) && self.hiddenOnClickedOutSpace) {
        [self hide];
    }
}

# pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _imageSize = JFScaleWidth6(30);
        _btnSeperatorStyle = JFAlertButtonSeperatorStyleLine;
        _btnSeperatorInsetH = JFScaleWidth6(15);
        _btnSeperatorInsetV = JFScaleWidth6(10);
        _cornerRadius = JFScaleWidth6(14);
        _bgColor = JFRGBAColor(0x14161A, 0.4);
        _contentBgColor = [UIColor whiteColor];
        _fGapL = JFScaleWidth6(20);
        _fGapM = JFScaleWidth6(10);
        _fGapS = JFScaleWidth6(5);
        _btnHeight = JFScaleWidth6(44);
        _btnCornerRadius = JFScaleWidth6(5);
        _hiddenOnClickedOutSpace = NO;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithTapGes:)]];
        
        [self addSubview:self.bgView];
        [self addSubview:self.contentView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}


# pragma mark - getter
- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = JFRGBAColor(0x1B2233, 1);
        _labTitle.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}
- (UILabel *)labDetail {
    if (!_labDetail) {
        _labDetail = [UILabel new];
        _labDetail.textColor = JFRGBAColor(0x444444, 1);
        _labDetail.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _labDetail.textAlignment = NSTextAlignmentCenter;
        _labDetail.numberOfLines = 0;
    }
    return _labDetail;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}
- (UIView *)btnBgView {
    if (!_btnBgView) {
        _btnBgView = [UIView new];
        _btnBgView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
    }
    return _btnBgView;
}
- (NSMutableArray *)btnList {
    if (!_btnList) {
        _btnList = @[].mutableCopy;
    }
    return _btnList;
}
@end

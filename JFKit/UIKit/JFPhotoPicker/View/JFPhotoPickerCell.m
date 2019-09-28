//
//  JFPhotoPickerCell.m
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFPhotoPickerCell.h"
#import "JFHelper.h"
#import "JFButton.h"
#import "Masonry.h"
#import "JFPhotoPickerModel.h"
#import "JFKit.h"

@interface JFPhotoPickerCell()

@property (nonatomic, strong) UIImageView* jf_imageView;
@property (nonatomic, strong) UIView* jf_maskView;
@property (nonatomic, strong) UILabel* jf_timeLabel;
@property (nonatomic, strong) JFButton* jf_selectBtn;
@property (nonatomic, assign) PHImageRequestID requestID;

@end



@implementation JFPhotoPickerCell

- (IBAction) clickedSelectBtn:(id)sender {
    if (self.didUpdateSelectState) {
        self.didUpdateSelectState(self, self.model);
    }
}

- (void) updateImage {
    WeakSelf(wself);
    if (!self.model) {
        return;
    }
    PHImageManager* imageMan = [PHImageManager defaultManager];
    if (self.requestID != NSNotFound) {
        [imageMan cancelImageRequest:self.requestID];
    }
    PHImageRequestOptions* op = [PHImageRequestOptions new];
    op.networkAccessAllowed = YES;
    /*
     PHImageRequestOptionsDeliveryModeOpportunistic:为了平衡图像质量和响应速度，Photos会提供一个或多个结果
     PHImageRequestOptionsDeliveryModeHighQualityFormat:只提供最高质量的图像，无论它需要多少时间加载
     PHImageRequestOptionsResizeModeFast:最快速的得到一个图像结果，可能会牺牲图像质量
     */
    op.resizeMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    // 获取缩略图:图片|视频的
    self.requestID = [imageMan requestImageForAsset:self.model.asset
                                         targetSize:self.model.thumbSize
                                        contentMode:PHImageContentModeAspectFit
                                            options:op
                                      resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                          wself.jf_imageView.image = result;
                                      }];
    
}

# pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.requestID = NSNotFound;
        [self addSubview:self.jf_imageView];
        [self addSubview:self.jf_maskView];
        [self addSubview:self.jf_timeLabel];
        [self addSubview:self.jf_selectBtn];
        
        CGFloat selectWidth = JFScaleWidth6(18);
        [self.jf_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.jf_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.jf_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(JFScaleWidth6(5));
            make.bottom.mas_equalTo(JFScaleWidth6(-3));
        }];
        [self.jf_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(selectWidth);
            make.right.mas_equalTo(JFScaleWidth6(-5));
            make.bottom.mas_equalTo(JFScaleWidth6(-5));
        }];
        self.jf_selectBtn.layer.cornerRadius = selectWidth * 0.5;
    }
    return self;
}
- (void)dealloc {
    [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
}

# pragma mark - setter
- (void)setModel:(JFPhotoPickerModel *)model {
    _model = model;
    if (model) {
        [self updateImage];
        if (model.asset.mediaType == PHAssetMediaTypeVideo) {
            self.jf_timeLabel.text = JFFormatDuration(model.asset.duration);
        }
        else {
            self.jf_timeLabel.text = nil;
        }
    } else {
        self.jf_imageView.image = nil;
        self.jf_timeLabel.text = nil;
        self.jf_selectBtn.hidden = YES;
    }
    self.jf_selectBtn.hidden = !model.enableSelect;
    if (model.isSelected) {
        self.jf_selectBtn.backgroundColor = [UIColor redColor];
        [self.jf_selectBtn setTitle:[NSString stringWithFormat:@"%ld", model.selectedIndex] forState:UIControlStateNormal];
        self.jf_selectBtn.layer.borderWidth = 0;
    } else {
        self.jf_selectBtn.backgroundColor = JFRGBAColor(0, 0.2);
        [self.jf_selectBtn setTitle:nil forState:UIControlStateNormal];
        self.jf_selectBtn.layer.borderWidth = 1;
    }
}

# pragma mark - getter
- (UIImageView *)jf_imageView {
    if (!_jf_imageView) {
        _jf_imageView = [UIImageView new];
        _jf_imageView.clipsToBounds = YES;
        _jf_imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _jf_imageView;
}
- (UIView *)jf_maskView {
    if (!_jf_maskView) {
        _jf_maskView = [UIView new];
        _jf_maskView.backgroundColor = JFRGBAColor(0, 0.05);
    }
    return _jf_maskView;
}
- (UILabel *)jf_timeLabel {
    if (!_jf_timeLabel) {
        _jf_timeLabel = [UILabel new];
        _jf_timeLabel.font = [UIFont systemFontOfSize:12];
        _jf_timeLabel.textColor = JFColorWhite;
    }
    return _jf_timeLabel;
}
- (JFButton *)jf_selectBtn {
    if (!_jf_selectBtn) {
        _jf_selectBtn = [JFButton new];
        _jf_selectBtn.layer.borderColor = JFColorWhite.CGColor;
        _jf_selectBtn.layer.borderWidth = 1;
        [_jf_selectBtn setTitleColor:JFColorWhite forState:UIControlStateNormal];
        _jf_selectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_jf_selectBtn addTarget:self action:@selector(clickedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jf_selectBtn;
}

@end

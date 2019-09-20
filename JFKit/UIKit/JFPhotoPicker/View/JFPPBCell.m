//
//  JFPPBCell.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/1.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFPPBCell.h"
#import <Masonry.h>
#import "UIView+Extension.h"
#import "JFHelper.h"
#import "JFPhotoPickerViewModel.h"
#import "JFZoomImageView.h"
#import "JFVideoDisplay.h"
#import "JFKit.h"

@interface JFPPBCell() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) JFZoomImageView* imageView;
@property (nonatomic, assign) PHImageRequestID thumbRequestID;
@property (nonatomic, assign) PHImageRequestID originRequestID;

@end

@implementation JFPPBCell


- (void) updateImage {
    WeakSelf(wself);
    if (!self.model) {
        return;
    }
    PHImageManager* imageMan = [PHImageManager defaultManager];
    if (self.thumbRequestID != NSNotFound) {
        [imageMan cancelImageRequest:self.thumbRequestID];
    }
    if (self.originRequestID != NSNotFound) {
        [imageMan cancelImageRequest:self.originRequestID];
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
    self.thumbRequestID = [imageMan requestImageForAsset:self.model.asset
                                              targetSize:self.model.thumbSize
                                             contentMode:PHImageContentModeAspectFit
                                                 options:op
                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                               [imageMan cancelImageRequest:wself.thumbRequestID];
                                               [wself.imageView setImage:result];
                                           }];
    
    PHImageRequestOptions* originOp = [PHImageRequestOptions new];
    originOp.networkAccessAllowed = YES;
    self.originRequestID = [imageMan requestImageDataForAsset:self.model.asset
                                                      options:originOp
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                        [imageMan cancelImageRequest:wself.thumbRequestID];
                                                        UIImage* image = nil;
                                                        if (originOp == UIImageOrientationUp) {
                                                            image = [UIImage imageWithData:imageData];
                                                        } else {
                                                            image = [[UIImage imageWithData:imageData] jf_normalizedImage];
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [wself.imageView setImage:image];
                                                        });
                                                    });
                                                }];
    
}



# pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbRequestID = NSNotFound;
        self.originRequestID = NSNotFound;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}
- (void) dealloc {
    [[PHImageManager defaultManager] cancelImageRequest:self.thumbRequestID];
    [[PHImageManager defaultManager] cancelImageRequest:self.originRequestID];
}

- (void)setModel:(JFPhotoPickerModel *)model {
    if (_model != model) {
    }
    _model = model;
    // 图片
    if (model.asset.mediaType == PHAssetMediaTypeImage) {
        self.imageView.hidden = NO;
        [self updateImage];
//        [self.imageView setImage:model.thumbImage];
//        if (model.originData) {
//            [self.imageView setImage:[NSURL fileURLWithPath:model.originData]];
//        }
    }
    // 视频
    else if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        self.imageView.hidden = YES;
        if (model.originData) {
        }
    }
    
}
- (JFZoomImageView *)imageView {
    if (!_imageView) {
        WeakSelf(wself);
        _imageView = [JFZoomImageView new];
        _imageView.tapGesEvent = ^(NSInteger numberOfTouches) {
            if (wself.handleWithTap) {
                wself.handleWithTap(numberOfTouches);
            }
        };
    }
    return _imageView;
}
@end

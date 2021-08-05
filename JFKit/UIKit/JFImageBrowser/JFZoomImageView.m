//
//  JFZoomImageView.m
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFZoomImageView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "YYWebImage.h"
#import "JFHelper.h"
#import <Masonry/Masonry.h>

@implementation JFZoomImageView

/**
 设置图片;
 @param image 可以是如下格式:
 UIImage:直接加载
 NSString:网页图片;SDWebImage异步加载;
 NSURL->fileURL:静态图片;直接加载;
 NSURL->URL:网页图片;SDWebImage异步加载;
 */
- (void) setImage:(id)image {
    if (!image) {
        return;
    }
    WeakSelf(wself);
    
    void (^ handleImage) (UIImage* image) = ^(UIImage* image) {
        wself.imageView.image = image;
        wself.minimumZoomScale = 0;
        [wself.imageView sizeToFit];
    };
    
    if ([image isKindOfClass:[UIImage class]]) {
        handleImage(image);
    }
    else if ([image isKindOfClass:[NSString class]]) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:image] options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            NSLog(@"++++++++ 下在图片进度::receivedSize(%ld) / expectedSize(%ld) = (%lf)", receivedSize, expectedSize, (CGFloat)receivedSize/(CGFloat)expectedSize);
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    handleImage(image);
                }];
        
    }
    else if ([image isKindOfClass:[NSURL class]]) {
        [[SDWebImageManager sharedManager] loadImageWithURL:image options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    handleImage(image);
                }];
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.delegate = self;
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 0;
        UITapGestureRecognizer* tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesTouched:)];
        UITapGestureRecognizer* tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesTouched:)];
        tapGes1.numberOfTapsRequired = 1;
        tapGes2.numberOfTapsRequired = 2;
        [tapGes1 requireGestureRecognizerToFail:tapGes2];
        [self addGestureRecognizer:tapGes1];
        [self addGestureRecognizer:tapGes2];
        UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithLongpress:)];
        [self addGestureRecognizer:longpress];
        
        if (@available(ios 11, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.bounds.size.height <= 0) {
        return;
    }

    // 设置minScale，如果未设置
    if (self.minimumZoomScale == 0 && self.imageView.image && self.bounds.size.height > 0) {
        CGFloat minScale = 1;
        CGSize imageSize =  self.imageView.image.size;
        CGFloat boundsWidth = self.bounds.size.width;
        CGFloat boundsHeight = self.bounds.size.height;

        // 宽顶格
        if (imageSize.width/imageSize.height > boundsWidth/boundsHeight) {
            minScale = boundsWidth / imageSize.width;
        }
        // 高顶格
        else {
            minScale = boundsHeight / imageSize.height;
        }
        self.minimumZoomScale = minScale;
        [self setZoomScale:minScale animated:NO];
    }

    // 更新图片中心;不放在 scrollViewDidZoom 调用的原因是，偶尔不会触发 scrollViewDidZoom
    [self updateImageViewCenter];

    
    
}

// 更新图片的中心
- (void) updateImageViewCenter {
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                        self.contentSize.height * 0.5 + offsetY);
}

- (IBAction) tapGesTouched:(UITapGestureRecognizer*)sender {
    if (sender.numberOfTapsRequired == 2) {
        if (self.zoomScale == self.maximumZoomScale) {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        } else {
            [self setZoomScale:self.maximumZoomScale animated:YES];
        }
    }
    if (self.tapGesEvent) {
        self.tapGesEvent(sender.numberOfTapsRequired);
    }
    
}

- (IBAction) handleWithLongpress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.longpressEvent) {
            self.longpressEvent();
        }
    }
}

# pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

# pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
@end

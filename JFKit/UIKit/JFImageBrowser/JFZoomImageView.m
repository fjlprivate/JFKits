//
//  JFZoomImageView.m
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFZoomImageView.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>
#import <YYWebImage.h>

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
    if ([image isKindOfClass:[UIImage class]]) {
        self.imageView.image = image;
    }
    else if ([image isKindOfClass:[NSString class]]) {
        [self.imageView yy_setImageWithURL:[NSURL URLWithString:image] options:YYWebImageOptionSetImageWithFadeAnimation];
    }
    else if ([image isKindOfClass:[NSURL class]]) {
        NSURL* imageUrl = (NSURL*)image;
        [self.imageView yy_setImageWithURL:imageUrl options:YYWebImageOptionSetImageWithFadeAnimation];
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.delegate = self;
        self.maximumZoomScale = 1;
        self.contentSize = self.bounds.size;
        UITapGestureRecognizer* tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesTouched:)];
        UITapGestureRecognizer* tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesTouched:)];
        tapGes1.numberOfTapsRequired = 1;
        tapGes2.numberOfTapsRequired = 2;
        [tapGes1 requireGestureRecognizerToFail:tapGes2];
        [self addGestureRecognizer:tapGes1];
        [self addGestureRecognizer:tapGes2];
        UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithLongpress:)];
        [self addGestureRecognizer:longpress];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (IBAction) tapGesTouched:(UITapGestureRecognizer*)sender {
    if (sender.numberOfTapsRequired == 2) {
        if (self.zoomScale < 1 || self.zoomScale == self.maximumZoomScale) {
            [self setZoomScale:1 animated:YES];
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

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale < 1) {
        self.imageView.center = CGPointMake(scrollView.bounds.size.width * 0.5,
                                            scrollView.bounds.size.height * 0.5);
    } else {
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5,
                                            scrollView.contentSize.height * 0.5);
    }
}

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

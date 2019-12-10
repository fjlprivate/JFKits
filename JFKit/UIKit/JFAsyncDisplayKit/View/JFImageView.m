//
//  JFImageView.m
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/20.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import "JFImageView.h"
#import "JFMacro.h"
#import "UIImageView+WebCache.h"
#import "YYWebImage.h"

@implementation JFImageView

- (void)setImageLayout:(JFImageLayout *)imageLayout {
    _imageLayout = imageLayout;
    [UIView performWithoutAnimation:^{
        if (imageLayout) {
            self.tag = imageLayout.tag;
            // 先移除旧的显示
//            id image = self.image;
//            self.image = nil;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [image class];
//            });

            self.frame = imageLayout.frame;
            self.clipsToBounds = YES;
            self.contentMode = imageLayout.contentMode;
            self.backgroundColor = imageLayout.backgroundColor;
            self.layer.cornerRadius = MAX(imageLayout.cornerRadius.width, imageLayout.cornerRadius.height);
            if (imageLayout.image) {
                // UIImage
                if ([imageLayout.image isKindOfClass:[UIImage class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = imageLayout.image;
                    });
                }
                // NSURL
                else if ([imageLayout.image isKindOfClass:[NSURL class]]) {
//                    [self sd_setImageWithURL:imageLayout.image placeholderImage:imageLayout.placeHolder];
//                    [self yy_setImageWithURL:imageLayout.image placeholder:imageLayout.placeHolder];
                    NSURL* imageUrl = (NSURL*)imageLayout.image;
                    if ([imageUrl isFileURL]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSData* data = [NSData dataWithContentsOfURL:imageUrl];
                            UIImage* aImage = [UIImage imageWithData:data];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.image = aImage;
                            });
                        });
                    }
                    else {
                        [self yy_setImageWithURL:imageLayout.image placeholder:imageLayout.placeHolder options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        }];
                    }
                }
                // NSString
                else if ([imageLayout.image isKindOfClass:[NSString class]]) {
                    NSURL* url = [NSURL URLWithString:imageLayout.image];
//                    [self sd_setImageWithURL:url placeholderImage:imageLayout.placeHolder];
//                    [self yy_setImageWithURL:url placeholder:imageLayout.placeHolder];
                    [self yy_setImageWithURL:url placeholder:imageLayout.placeHolder options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    }];
                }
            }
            else if (imageLayout.placeHolder) {
                self.image = imageLayout.placeHolder;
            }
        } else {
            self.tag = NSNotFound;
            self.frame = CGRectZero;
            id image = self.image;
            self.image = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [image class];
            });
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedImageView:)]) {
        [self.delegate didClickedImageView:self];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect enlargeRect = CGRectInset(self.bounds, -20, -20);
    return CGRectContainsPoint(enlargeRect, point);
}

@end

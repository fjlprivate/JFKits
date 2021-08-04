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
#import "JFAsyncFlag.h"


@interface JFImageView()
@property (nonatomic, strong) JFAsyncFlag* asyncFlag;
@end


@implementation JFImageView

- (void)setImageLayout:(JFImageLayout *)imageLayout {
    _imageLayout = imageLayout;
    [self.asyncFlag incrementFlag];
    int curFlag = self.asyncFlag.curFlag;
    WeakSelf(wself);
    BOOL (^ cancelled) (void) = ^ BOOL {
        return curFlag != wself.asyncFlag.curFlag;
    };
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView performWithoutAnimation:^{
            if (imageLayout) {
                // 先移除旧的显示
                //            id image = self.image;
                //            self.image = nil;
                //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                [image class];
                //            });
                if (cancelled()) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tag = imageLayout.tag;
                    self.frame = imageLayout.frame;
                    self.clipsToBounds = YES;
                    self.contentMode = imageLayout.contentMode;
                    self.backgroundColor = imageLayout.backgroundColor;
                    self.layer.cornerRadius = MAX(imageLayout.cornerRadius.width, imageLayout.cornerRadius.height);
                });
                if (cancelled()) {
                    return;
                }
                if (imageLayout.image) {
                    // UIImage
                    if ([imageLayout.image isKindOfClass:[UIImage class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (cancelled()) {
                                return;
                            }
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
                                if (cancelled()) {
                                    return;
                                }
                                NSData* data = [NSData dataWithContentsOfURL:imageUrl];
                                UIImage* aImage = [UIImage imageWithData:data];
                                if (cancelled()) {
                                    return;
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (cancelled()) {
                                        return;
                                    }
                                    self.image = aImage;
                                });
                            });
                        }
                        else {
                            if (cancelled()) {
                                return;
                            }
                            [self yy_setImageWithURL:imageLayout.image placeholder:imageLayout.placeHolder options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                            }];
                        }
                    }
                    // NSString
                    else if ([imageLayout.image isKindOfClass:[NSString class]]) {
                        if (cancelled()) {
                            return;
                        }
                        NSURL* url = [NSURL URLWithString:imageLayout.image];
                        //                    [self sd_setImageWithURL:url placeholderImage:imageLayout.placeHolder];
                        //                    [self yy_setImageWithURL:url placeholder:imageLayout.placeHolder];
                        [self yy_setImageWithURL:url placeholder:imageLayout.placeHolder options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        }];
                    }
                }
                else if (imageLayout.placeHolder) {
                    if (cancelled()) {
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = imageLayout.placeHolder;
                    });
                }
            } else {
                if (cancelled()) {
                    return;
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.tag = NSNotFound;
                    self.frame = CGRectZero;
                    id image = self.image;
                    self.image = nil;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [image class];
                    });
                });
            }
//        }];
//    });
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


# pragma mark - getter
- (JFAsyncFlag *)asyncFlag {
    if (!_asyncFlag) {
        _asyncFlag = [JFAsyncFlag new];
    }
    return _asyncFlag;
}

@end

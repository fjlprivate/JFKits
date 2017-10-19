//
//  JFAsyncDisplayView.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFAsyncDisplayView.h"
#import "JFAsyncDisplayLayer.h"
#import "JFMacro.h"
#import "UIImageView+WebCache.h"
#import <libkern/OSAtomic.h>
#import "UIImage+Extension.h"
#import "FLAnimatedImageView+WebCache.h"

// 图片类型
typedef NS_ENUM(NSInteger, JFAsyncImageType) {
    JFAsyncImageTypeStatic, // 静态图片
    JFAsyncImageTypeGif // gif动图
};

@interface JFAsyncDisplayView() <JFAsyncDisplayDelegate> {
    int32_t cancelFlag;
}

@property (nonatomic, assign) CGPoint clickedPosition;
@property (nonatomic, strong) NSMutableArray* displayImageViews; // 存放当前正在显示的imageView组
@property (nonatomic, strong) NSMutableArray* reuseImageViews; // imageView的重用池;
@property (nonatomic, strong) BOOL (^ isCancel) (int32_t flag);

@end

@implementation JFAsyncDisplayView

# pragma mask 1 刷新标志

- (void) incrementCancelFlag {
    OSAtomicIncrement32(&cancelFlag);
}

# pragma mask 1 图片加载器操作

// 使用重用池图片加载器加载所有的URL类型的图片
- (void) displayAllURLPictures {
    int32_t curFlag = cancelFlag;
    for (JFStorage* storage in self.layout.storages) {
        if (self.isCancel(curFlag)) {
            break;
        }
        if ([storage isKindOfClass:[JFImageStorage class]]) {
            JFImageStorage* imageStorage = (JFImageStorage*)storage;
            if (imageStorage.contents && [imageStorage.contents isKindOfClass:[NSURL class]]) {
                NSURL* url = imageStorage.contents;
                
                if ([[url.absoluteString lowercaseString] hasSuffix:@".gif"]) {
                    FLAnimatedImageView* animatedImageV = (FLAnimatedImageView*)[self jf_dequeueImageViewWithType:JFAsyncImageTypeGif];
                    animatedImageV.frame = imageStorage.frame;
                    [animatedImageV sd_setImageWithURL:url placeholderImage:imageStorage.placeHolder];
                } else {
                    UIImageView* imageView = [self jf_dequeueImageView];
                    imageView.frame = imageStorage.frame;
                    // 下载图片完成后需要进行裁剪
                    [imageView sd_setImageWithURL:url placeholderImage:imageStorage.placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        CGSize imageSize = image.size;
                        if (imageSize.width != imageSize.height) {
                            CGFloat newWidth = MIN(imageSize.width, imageSize.height);
                            dispatch_queue_t distQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                            dispatch_async(distQ, ^{
                                UIImage* cutedImage = [image imageCutedWithNewSize:CGSizeMake(newWidth, newWidth) contentMode:UIViewContentModeCenter];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    imageView.image = cutedImage;
                                });
                            });
                            
                        }
                        
                    }];
                }
            }
        }
    }
}

// 从重用池中取出一个imageView用来显示图片
- (UIImageView*) jf_dequeueImageView {
    UIImageView* imageView = [self.reuseImageViews lastObject];
    if (!imageView) {
        imageView = [UIImageView new];
        [self addSubview:imageView];
    } else {
        imageView.hidden = NO;
        [self.reuseImageViews removeObject:imageView];
    }
    [self.displayImageViews addObject:imageView];
    return imageView;
}

- (UIImageView*) jf_dequeueImageViewWithType:(JFAsyncImageType)imageType {
    if (imageType == JFAsyncImageTypeStatic) { // 取静态图片imageView
        UIImageView* imageView = [self.reuseImageViews lastObject];
        if (!imageView) {
            imageView = [UIImageView new];
            [self addSubview:imageView];
        } else {
            imageView.hidden = NO;
            [self.reuseImageViews removeObject:imageView];
        }
        [self.displayImageViews addObject:imageView];
        return imageView;
    } else { // 取动态图FLAnimatedImageView
        UIImageView* availableImgV = nil;
        for (UIImageView* imageV in self.reuseImageViews) {
            if ([imageV isKindOfClass:[FLAnimatedImageView class]]) {
                imageV.hidden = NO;
                availableImgV = imageV;
                break;
            }
        }
        // 取到: 从重用池删除
        if (availableImgV) {
            [self.reuseImageViews removeObject:availableImgV];
        }
        // 没取到: 创建一个新的，并加载到当前视图
        else {
            availableImgV = [[FLAnimatedImageView alloc] init];
            [self addSubview:availableImgV];
        }
        [self.displayImageViews addObject:availableImgV];
        return availableImgV;
    }
}


// 清空当前正在使用的imageView组;并保存到重用池中
- (void) jf_inquequeAllDisplayImageViews {
    int32_t curFlag = cancelFlag;
    for (UIImageView* imageView in self.displayImageViews) {
        if (self.isCancel(curFlag)) {
            break;
        }
        __block UIImage* image = imageView.image;
        imageView.image = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            image = nil;
        });
        imageView.hidden = YES;
        imageView.frame = CGRectZero;
        [self.reuseImageViews addObject:imageView];
    }
    [self.displayImageViews removeAllObjects];
}

# pragma mask 2 tools 

- (void) setLayerDisplayAsynchronously:(BOOL)async {
    JFAsyncDisplayLayer* layer = (JFAsyncDisplayLayer*)self.layer;
    layer.displayedAsyncchronous = async;
    [layer setNeedsDisplay];
}

# pragma mask 2 touchs

// 点击开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];

    // 检查所有storages: texts + images
    for (JFStorage* storage in self.layout.storages) {
        // textStorage
        if ([storage isKindOfClass:[JFTextStorage class]]) {
            JFTextStorage* textStorage = (JFTextStorage*)storage;
            // 判断点击坐标点是否在
            CGRect highLightRect = [textStorage didClickedHighLightPosition:curP];
            if (!CGRectEqualToRect(highLightRect, CGRectZero)) {
                // 更新高亮
                [textStorage turnningHightLightSwitch:YES atPosition:curP];
                self.clickedPosition = curP;
                // 同步刷新绘制(如果没有selectedColor,就不用刷新绘制)
//                [self setLayerDisplayAsynchronously:YES];
                return;
            }
        }
        // imageStorage
        else if ([storage isKindOfClass:[JFImageStorage class]]) {
            JFImageStorage* imageStorage = (JFImageStorage*)storage;
            if (CGRectContainsPoint(imageStorage.suggustFrame, curP)) {
                self.clickedPosition = curP;
                return;
            }
        }
    }
}

// 点击移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

// 点击结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];

    if (!CGPointEqualToPoint(self.clickedPosition, CGPointZero)) {
        for (JFStorage* storage in self.layout.storages) {
            // textStorage
            if ([storage isKindOfClass:[JFTextStorage class]]) {
                JFTextStorage* textStorage = (JFTextStorage*)storage;
                // 判断当前textStorage是否是被点击的高亮storage，如果是：则取消高亮
                CGRect highLightRect = [textStorage didClickedHighLightPosition:self.clickedPosition];
                if (!CGRectEqualToRect(highLightRect, CGRectZero)) {
                    // 取消高亮
                    [textStorage turnningHightLightSwitch:NO atPosition:self.clickedPosition];
                    self.clickedPosition = CGPointZero;
                    // 同步绘制
//                    [self setLayerDisplayAsynchronously:YES];
                    // 如果是在高亮区内退出点击的，则回调
                    if (CGRectContainsPoint(highLightRect, curP)) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(asyncDisplayView:didClickedTextStorage:withLinkData:)]) {
                            [self.delegate asyncDisplayView:self didClickedTextStorage:textStorage withLinkData:[textStorage bindingDataWithHighLightAtPosition:curP]];
                        }
                    }
                    return;
                }
            }
            // imageStorage
            else if ([storage isKindOfClass:[JFImageStorage class]]) {
                JFImageStorage* imageStorage = (JFImageStorage*)storage;
                if (CGRectContainsPoint(imageStorage.suggustFrame, self.clickedPosition)) {
                    self.clickedPosition = CGPointZero;
                    if (CGRectContainsPoint(imageStorage.suggustFrame, curP)) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(asyncDIsplayView:didClickedImageStorage:)]) {
                            [self.delegate asyncDIsplayView:self didClickedImageStorage:imageStorage];
                        }
                    }
                    return;
                }
            }
        }

    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!CGPointEqualToPoint(self.clickedPosition, CGPointZero)) {
        for (JFStorage* storage in self.layout.storages) {
            if ([storage isKindOfClass:[JFTextStorage class]]) {
                JFTextStorage* textStorage = (JFTextStorage*)storage;
                CGRect highLightRect = [textStorage didClickedHighLightPosition:self.clickedPosition];
                if (!CGRectEqualToRect(highLightRect, CGRectZero)) {
                    [textStorage turnningHightLightSwitch:NO atPosition:self.clickedPosition];
                    self.clickedPosition = CGPointZero;
                    [self setLayerDisplayAsynchronously:YES];
                    return;
                }
            }
        }
        
    }

}


# pragma mask 2 JFAsyncDisplayDelegate

- (JFAsyncDisplayCallBacks*) asyncDisplayCallBacks {
    __weak typeof(self) wself = self;
    JFAsyncDisplayCallBacks* callBack = [JFAsyncDisplayCallBacks new];
    // 即将绘制
    callBack.willDisplay = ^(JFAsyncDisplayLayer *layer) {
        layer.contentsScale = JFSCREEN_SCALE;
        if (wself.backgroundColor) {
            layer.backgroundColor = wself.backgroundColor.CGColor;
        }
    };
    // 执行绘制任务
    callBack.display = ^(CGContextRef context, CGSize size, isCanceledBlock isCanceled) {
        __strong typeof(wself) sself = wself;
        // 即将开始绘制
        if (sself.delegate && [sself.delegate respondsToSelector:@selector(asyncDisplayView:willBeginDrawingInContext:)]) {
            [sself.delegate asyncDisplayView:sself willBeginDrawingInContext:context];
        }
        // 开始绘制文本+图片
        for (JFStorage* storage in sself.layout.storages) {
            [storage drawInContext:context isCanceled:isCanceled];
        }
        // 即将结束绘制
        if (sself.delegate && [sself.delegate respondsToSelector:@selector(asyncDisplayView:willEndDrawingInContext:)]) {
            [sself.delegate asyncDisplayView:sself willEndDrawingInContext:context];
        }
    };
    // 绘制完毕
    callBack.didDisplayed = ^(JFAsyncDisplayLayer *layer, BOOL finished) {
        
    };
    
    return callBack;
}

# pragma mask 3 life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _clickedPosition = CGPointZero;
        _displayImageViews = [NSMutableArray array];
        _reuseImageViews = [NSMutableArray array];
        _isCancel = ^ BOOL (int32_t flag) {
            return !(flag == cancelFlag);
        };
    }
    return self;
}

+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}

# pragma mask 4 setter

- (void)setLayout:(JFLayout *)layout {
    if (layout != _layout) {
        [self incrementCancelFlag];
        _layout = layout;
        // 清空显示图并保存到重用池
        [self jf_inquequeAllDisplayImageViews];
        // 先绘制可以绘制的
        [self setLayerDisplayAsynchronously:YES];
        // 加载并显示NSURL图片
        [self displayAllURLPictures];
    }
}


@end

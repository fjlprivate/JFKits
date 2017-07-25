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
                UIImageView* imageView = [self jf_dequeueImageView];
                imageView.frame = imageStorage.frame;
                [imageView sd_setImageWithURL:url placeholderImage:imageStorage.placeHolder];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    for (JFStorage* storage in self.layout.storages) {
        if ([storage isKindOfClass:[JFTextStorage class]]) {
            JFTextStorage* textStorage = (JFTextStorage*)storage;
            if ([textStorage didClickedHighLightPosition:curP]) {
                [textStorage turnningHightLightSwitch:YES atPosition:curP];
                self.clickedPosition = curP;
                [self setLayerDisplayAsynchronously:NO];
                return;
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!CGPointEqualToPoint(self.clickedPosition, CGPointZero)) {
        for (JFStorage* storage in self.layout.storages) {
            if ([storage isKindOfClass:[JFTextStorage class]]) {
                JFTextStorage* textStorage = (JFTextStorage*)storage;
                if ([textStorage didClickedHighLightPosition:self.clickedPosition]) {
                    [textStorage turnningHightLightSwitch:NO atPosition:self.clickedPosition];
                    self.clickedPosition = CGPointZero;
                    [self setLayerDisplayAsynchronously:NO];
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
                if ([textStorage didClickedHighLightPosition:self.clickedPosition]) {
                    [textStorage turnningHightLightSwitch:NO atPosition:self.clickedPosition];
                    self.clickedPosition = CGPointZero;
                    [self setLayerDisplayAsynchronously:NO];
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
        for (JFStorage* storage in sself.layout.storages) {
            [storage drawInContext:context isCanceled:isCanceled];
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
    if (_layout != layout) {
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

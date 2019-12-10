//
//  JFAsyncView.m
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/18.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import "JFAsyncView.h"
#import "JFHelper.h"
#import "JFAsyncFlag.h"
#import "JFImageView.h"
#import "JFAsyncDisplayLayer.h"


@interface JFAsyncView() <JFImageViewDelegate,JFAsyncDisplayLayerDelegate>
//@property (nonatomic, strong) NSMutableArray* labelsStorage;
//@property (nonatomic, strong) NSMutableArray* labelsDisplay;
@property (nonatomic, strong) NSMutableArray* imageViewsStorage; // 图片视图缓存列表[未加载]
@property (nonatomic, strong) NSMutableArray* imageViewsDisplay; // 图片视图缓存列表[已加载]
@property (nonatomic, strong) JFAsyncFlag* flag;
@property (nonatomic, weak) JFTextAttachmentHighlight* selectedHighlight; // 选中的高亮属性
@end

@implementation JFAsyncView

- (void) handleWithLongpress:(UILongPressGestureRecognizer*)longpress {
    if (longpress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressAtAsyncView)]) {
            [self.delegate didLongPressAtAsyncView];
        }
    }
}

# pragma mark - 图片加载
/* 加载图片
 * 1. 从缓存中取出一个imageView
 * 2. 已取出，则用来显示图片
 * 3. 没取出，则创建一个imageView，用来显示图片；同时把这个imageView添加到缓存中；
 * 4. 在view释放的时候清空
 */


/*
 * storage列表 和 display列表
 * 不显示的统统放在storage列表，正在显示的统统放在display列表
 * 1. 轮训diaplay列表，比对tag对应的imageView，并加载image；所有比对不上的放到临时数组，状态都不动
        未加载完的所有image也要缓存到临时数组
 * 2. 轮训未加载的image列表，从临时数组中取出一个imageView，进行image的加载
        结果1：imageView还多，则重置掉它们，从当前view移除，缓存到storage列表
        结果2：image还多，从storage中取出imageview进行加载；
 * 3. 从storage中取出剩下的imageView进行image的加载
        如果storage列表还是不够，则新建imageView，并加载，并添加到display列表；所有已加载的storage列表也移除到display列表
 */
- (void) relayoutImages:(NSArray<JFImageLayout*>*)images cancelled:(IsCancelled)cancelled{
    // 视图临时缓存列表
    NSMutableArray<JFImageView*>* tmpList = @[].mutableCopy;
    // 剩余未加载的图片缓存列表
    NSMutableArray<JFImageLayout*>* unloadImages = [NSMutableArray arrayWithArray:images];
    NSMutableArray<JFImageLayout*>* loadedImages = @[].mutableCopy;
    
    // 1. 匹配并加载
    for (JFImageView* imageView in self.imageViewsDisplay) {
        if (cancelled()) {
            return;
        }
        JFImageLayout* loadImage = nil;
        // 从图片缓存中查找跟imageView.tag一致的图片
        for (JFImageLayout* image in unloadImages) {
            if (cancelled()) {
                return;
            }
            if (image.tag == imageView.tag) {
                loadImage = image;
                break;
            }
        }
        // 匹配到:加载
        if (loadImage) {
            imageView.imageLayout = loadImage;
            // 转移到已加载列表
            [loadedImages addObject:loadImage];
            [unloadImages removeObject:loadImage];
        }
        // 未匹配到:添加到临时列表
        else {
            [tmpList addObject:imageView];
        }
    }
    if (cancelled()) {
        return;
    }

    // 2. 轮训临时缓存和未加载image列表
    if (tmpList.count > 0 && unloadImages.count > 0) {
        NSMutableArray* list = @[].mutableCopy;
        for (JFImageLayout* image in unloadImages) {
            if (cancelled()) {
                return;
            }
            // 判空
            if (tmpList.count == 0) {
                break;
            }
            // 出栈一个imageView
            JFImageView* imageView = tmpList.lastObject;
            [tmpList removeLastObject];
            // 加载图片
            imageView.imageLayout = image;
            // 转移到已加载列表
            [loadedImages addObject:image];
            [list addObject:image];
        }
        if (list.count) {
            [unloadImages removeObjectsInArray:list];
        }
    }
    // 图片容器有剩余:重置并移除到storage
    if (tmpList.count > 0) {
        for (JFImageView* imageView in tmpList) {
            if (cancelled()) {
                return;
            }
            imageView.imageLayout = nil;
            [imageView removeFromSuperview];
            [self.imageViewsStorage addObject:imageView];
        }
        [tmpList removeAllObjects];
    }
    // 图片缓存有剩余:从storage中取imageView进行加载
    else if (unloadImages.count > 0) {
        for (JFImageLayout* image in unloadImages) {
            if (cancelled()) {
                return;
            }
            // 从storage中取出一个并加载
            JFImageView* imageView = nil;
            if (self.imageViewsStorage.count > 0) {
                imageView = self.imageViewsStorage.lastObject;
                [self.imageViewsStorage removeLastObject];
                [self addSubview:imageView];
                imageView.imageLayout = image;
            }
            // 新建一个imageView加载
            else {
                imageView = [JFImageView new];
                imageView.delegate = self;
                [self addSubview:imageView];
                imageView.imageLayout = image;
            }
            // 加载完毕后添加到display列表
            if (imageView) {
                [self.imageViewsDisplay addObject:imageView];
            }
        }
    }
}

- (void) cleanImageViews {
    for (JFImageView* imageView in self.imageViewsDisplay) {
        imageView.imageLayout = nil;
        [imageView removeFromSuperview];
        [self.imageViewsStorage addObject:imageView];
    }
    if (self.imageViewsDisplay.count) {
        [self.imageViewsDisplay removeAllObjects];
    }
    
}



# pragma mark - UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    self.selectedHighlight = [self.layouts raiseHighlightAtPoint:location];
    if (self.selectedHighlight) {
        [self.layer setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectedHighlight) {
        JFTextLayout* textLayout = self.layouts.highlightedTextLayout;
        JFTextAttachmentHighlight* highlight = self.layouts.selectedHighlight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(asyncView:didClickedAtTextLayout:withHighlight:)]) {
            [self.delegate asyncView:self didClickedAtTextLayout:textLayout withHighlight:highlight];
        }
        [self.layouts resetHighlightWhichRaised];
        if (self.selectedHighlight) {
            [self.layer setNeedsDisplay];
        }
        self.selectedHighlight = nil;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectedHighlight) {
        [self.layouts resetHighlightWhichRaised];
        if (self.selectedHighlight) {
            [self.layer setNeedsDisplay];
        }
        self.selectedHighlight = nil;
    }
}


# pragma mark - JFImageViewDelegate
- (void)didClickedImageView:(JFImageView *)imageView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(asyncView:didClickedAtImageLayout:)]) {
        [self.delegate asyncView:self didClickedAtImageLayout:imageView.imageLayout];
    }
}


# pragma mark - JFAsyncDisplayLayerDelegate

- (void)asyncDisplayLayerWillDisplay:(JFAsyncDisplayLayer *)layer {
    layer.backgroundColor = self.backgroundColor.CGColor;
    layer.opaque = YES;
}

- (void)asyncDisplayLayer:(JFAsyncDisplayLayer *)layer displayingInContext:(CGContextRef)context cancelled:(IsCancelled)cancelled
{
    NSMutableArray<JFImageLayout*>* images = @[].mutableCopy;
    for (JFLayout* layout in self.layouts.layouts) {
        if (cancelled()) {
            return;
        }
        // 文本的绘制
        if ([layout isKindOfClass:[JFTextLayout class]]) {
            JFTextLayout* textLayout = (JFTextLayout*)layout;
            [textLayout drawInContext:context cancelled:cancelled];
        }
        // 缓存图片列表
        else if ([layout isKindOfClass:[JFImageLayout class]]) {
            JFImageLayout* imageLayout = (JFImageLayout*)layout;
            [images addObject:imageLayout];
        }
    }
    // 图片的加载
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (images.count > 0) {
            [self relayoutImages:images cancelled:cancelled];
        } else {
            [self cleanImageViews];
        }
    });
}

- (void)asyncDisplayLayerDidEndDisplay:(JFAsyncDisplayLayer *)layer {
    
}


# pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldTruncateWidth = NO;
        self.shouldTruncateHeight = YES;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithLongpress:)]];
    }
    return self;
}
+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}

# pragma mark - setter

- (void)setLayouts:(JFAsyncViewLayouts *)layouts {
    _layouts = layouts;
    self.layer.contents = nil;
    [UIView performWithoutAnimation:^{
        if (layouts) {
            self.frame = layouts.viewFrame;
        } else {
            self.frame = CGRectZero;
        }
    }];
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer setNeedsDisplay];
}

# pragma mark - getter

//- (NSMutableArray *)labelsStorage {
//    if (!_labelsStorage) {
//        _labelsStorage = @[].mutableCopy;
//    }
//    return _labelsStorage;
//}
//- (NSMutableArray *)labelsDisplay {
//    if (!_labelsDisplay) {
//        _labelsDisplay = @[].mutableCopy;
//    }
//    return _labelsDisplay;
//}
- (NSMutableArray *)imageViewsStorage {
    if (!_imageViewsStorage) {
        _imageViewsStorage = @[].mutableCopy;
    }
    return _imageViewsStorage;
}
- (NSMutableArray *)imageViewsDisplay {
    if (!_imageViewsDisplay) {
        _imageViewsDisplay = @[].mutableCopy;
    }
    return _imageViewsDisplay;
}
- (JFAsyncFlag *)flag {
    if (!_flag) {
        _flag = [JFAsyncFlag new];
    }
    return _flag;
}

@end

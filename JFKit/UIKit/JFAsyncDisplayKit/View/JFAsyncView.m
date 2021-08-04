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

/* 图片容器池
 * @{
 *      @(JFImageLayout.tag):JFImageView,
 *      @(JFImageLayout.tag):JFImageView,
 *      ...
 *  }
 */
@property (nonatomic, strong) NSMutableDictionary* imageViews;

@property (nonatomic, strong) JFAsyncFlag* flag;
@property (nonatomic, weak) JFTextAttachmentHighlight* selectedHighlight; // 选中的高亮属性

@end



@interface JFAsyncView(LoadImages)
// 加载图片
- (void) reloadImages:(NSArray<JFImageLayout*>*)images cancelled:(IsCancelled)cancelled;
@end




@implementation JFAsyncView

- (void) handleWithLongpress:(UILongPressGestureRecognizer*)longpress {
    if (longpress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressAtAsyncView)]) {
            [self.delegate didLongPressAtAsyncView];
        }
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
        // 更新状态前中断绘制
        JFAsyncDisplayLayer* layer = (JFAsyncDisplayLayer*)self.layer;
        [layer cancelDisplaying];
        [self.layouts resetHighlightWhichRaised];
        if (self.selectedHighlight) {
            [self.layer setNeedsDisplay];
        }
        self.selectedHighlight = nil;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectedHighlight) {
        JFAsyncDisplayLayer* layer = (JFAsyncDisplayLayer*)self.layer;
        [layer cancelDisplaying];
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(asyncView:willDrawInContext:cancelled:)]) {
        [self.delegate asyncView:self willDrawInContext:context cancelled:cancelled];
    }
    
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
    [self reloadImages:images cancelled:cancelled];
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
- (JFAsyncFlag *)flag {
    if (!_flag) {
        _flag = [JFAsyncFlag new];
    }
    return _flag;
}
- (NSMutableDictionary *)imageViews {
    if (!_imageViews) {
        _imageViews = @{}.mutableCopy;
    }
    return _imageViews;
}

@end





@implementation JFAsyncView (LoadImages)

# pragma mark - 图片加载

/* 重载图片源
 * step1. 从容器池取出匹配tag的容器加载
 * step2. 仍有图片未加载完，从容器池中取出未匹配的容器进行加载，并重置缓存key
 * step3. 如果容器池用完了还有图片要加载，则新建容器进行加载，并添加到缓存
 * step4. 清空多余的没有匹配的容器内容
 */
- (void) reloadImages:(NSArray<JFImageLayout*>*)images cancelled:(IsCancelled)cancelled {
    
    // 用来保存没有装载的图片
    NSMutableArray<JFImageLayout*>* notLoadedImages = @[].mutableCopy;
    // 用来保存所有未装载的容器
    NSMutableArray<NSNumber*>* notLoadedKeys = [[NSMutableArray alloc] initWithArray:self.imageViews.allKeys];
    
    // 轮询数据源
    for (JFImageLayout* image in images) {
        if (cancelled()) {
            return;
        }
        // 取图片tag对应的容器
        JFImageView* imageView = [self.imageViews objectForKey:@(image.tag)];
        
        // 取到容器
        if (imageView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!imageView.superview) {
                    [self addSubview:imageView];
                }
            });
            // 装载
            imageView.imageLayout = image;
            // tag从未装载列表移除
            [notLoadedKeys removeObject:@(image.tag)];
        }
        // 没取到容器
        else {
            // image添加到未装载列表
            [notLoadedImages addObject:image];
        }
    }
    // 有未装载的图片
    for (JFImageLayout* image in notLoadedImages) {
        if (cancelled()) {
            return;
        }
        // 还有未装载的容器
        if (notLoadedKeys.count > 0) {
            // 取一个容器来装载
            NSNumber* tag = notLoadedKeys.lastObject;
            JFImageView* imageView = [self.imageViews objectForKey:tag];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!imageView.superview) {
                    [self addSubview:imageView];
                }
            });
            imageView.imageLayout = image;
            if (cancelled()) {
                return;
            }
            // 新增key
            [self.imageViews setObject:imageView forKey:@(image.tag)];
            // 移除旧key
            [self.imageViews removeObjectForKey:tag];
            // 装载完后从未装载列表删除容器
            [notLoadedKeys removeObject:tag];
        }
        // 已经没有未装载的容器了
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                JFImageView* imageView = [[JFImageView alloc] init];
                [self.imageViews setObject:imageView forKey:@(image.tag)];
                [self addSubview:imageView];
                imageView.imageLayout = image;
                imageView.delegate = self;
            });
        }
    }
    
    // 有未装载的容器，置空容器
    for (NSNumber* tag in notLoadedKeys) {
        if (cancelled()) {
            return;
        }
        JFImageView* imageView = [self.imageViews objectForKey:tag];
        if (imageView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView removeFromSuperview];
            });
            imageView.imageLayout = nil;
        }
    }
    
}

@end

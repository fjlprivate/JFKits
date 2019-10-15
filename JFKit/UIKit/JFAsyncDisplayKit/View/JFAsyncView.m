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
#import "JFLabel.h"
#import "JFImageView.h"
#import "JFAsyncDisplayLayer.h"


@interface JFAsyncView() <JFLabelDelegate, JFImageViewDelegate>
@property (nonatomic, strong) NSMutableArray* labelsStorage;
@property (nonatomic, strong) NSMutableArray* imageViewsStorage;
@property (nonatomic, strong) NSMutableArray* labelsDisplay;
@property (nonatomic, strong) NSMutableArray* imageViewsDisplay;
@property (nonatomic, strong) JFAsyncFlag* flag;
@end

@implementation JFAsyncView

- (void) handleWithLongpress:(UILongPressGestureRecognizer*)longpress {
    if (longpress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressAtAsyncView)]) {
            [self.delegate didLongPressAtAsyncView];
        }
    }
}

# pragma mark - layout

//- (void) layoutAllViews {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(willRelayoutInAsyncView:)]) {
//        [self.delegate willRelayoutInAsyncView:self];
//    }
//
//    int curFlag = self.flag.curFlag;
//    WeakSelf(wself);
//    BOOL (^ cancelled) (void) = ^ BOOL (void) {
//        return curFlag != wself.flag.curFlag;
//    };
//    if (self.layouts) {
//        CGRect frame = self.layouts.viewFrame;
//        if (self.shouldTruncateWidth) {
//            frame.size.width = self.layouts.contentSize.width;
//        }
//        if (self.shouldTruncateHeight) {
//            frame.size.height = self.layouts.contentSize.height;
//        }
//        self.frame = frame;
//    } else {
//        self.frame = CGRectZero;
//    }
//    // 清理旧的显示
//    [self clearAllDisplayingOnCancelled:cancelled];
//    // 加载新的显示
//    [self relayoutAllDisplayingOnCancelled:cancelled];
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didRelayoutInAsyncView:)]) {
//        [self.delegate didRelayoutInAsyncView:self];
//    }
//}


/**
 清理正在显示的所有label和imageView;
 要注意多线程的取消操作;
 @param cancelled 判断是否退出;
 */
//- (void) clearAllDisplayingOnCancelled:(BOOL (^) (void))cancelled {
//    if (cancelled()) {
//        return;
//    }
//    NSMutableArray* labelList = @[].mutableCopy;
//    NSMutableArray* imgList = @[].mutableCopy;
//
//    for (JFLabel* label in self.labelsDisplay) {
//        if (cancelled()) {
//            break;
//        }
//        label.textLayout = nil;
//        [self.labelsStorage addObject:label];
//        [labelList addObject:label];
//    }
//    if (!IsNon(labelList)) {
//        [self.labelsDisplay removeObjectsInArray:labelList];
//    }
//    for (JFImageView* imageView in self.imageViewsDisplay) {
//        if (cancelled()) {
//            break;
//        }
//        imageView.imageLayout = nil;
//        [self.imageViewsStorage addObject:imageView];
//        [imgList addObject:imageView];
//    }
//    if (!IsNon(imgList)) {
//        [self.imageViewsDisplay removeObjectsInArray:imgList];
//    }
//}


/**
 从layouts组中提取text或image的布局对象,
 对应JFLabel组或JFImageView组中提取控件,
 一一对应加载;
 不够的控件要创建新的;
 @param cancelled 判断是否退出;
 */
//- (void) relayoutAllDisplayingOnCancelled:(BOOL (^) (void))cancelled {
//    for (JFLayout* layout in self.layouts.layouts) {
//        if (cancelled()) {
//            return;
//        }
//        if ([layout isKindOfClass:[JFTextLayout class]]) {
//            // 从缓存容器中取出一个
//            JFLabel* label = self.labelsStorage.firstObject;
//            // 如果存在，则显示它，并将它从缓存容器中清除，添加到显示容器中
//            if (label) {
//                [self bringSubviewToFront:label];
//                label.textLayout = (JFTextLayout*)layout;
//                [self.labelsDisplay addObject:label];
//                [self.labelsStorage removeObject:label];
//            }
//            // 如果不存在，则创建一个JFLabel，并将它添加到显示容器中
//            else {
//                label = [JFLabel new];
//                [self addSubview:label];
//                label.textLayout = (JFTextLayout*)layout;
//                [self.labelsDisplay addObject:label];
//            }
//            label.delegate = self;
//        }
//        else if ([layout isKindOfClass:[JFImageLayout class]]) {
//            JFImageView* imageView = self.imageViewsStorage.firstObject;
//            if (imageView) {
//                [self bringSubviewToFront:imageView];
//                imageView.imageLayout = (JFImageLayout*)layout;
//                [self.imageViewsDisplay addObject:imageView];
//                [self.imageViewsStorage removeObject:imageView];
//            }
//            else {
//                imageView = [JFImageView new];
//                [self addSubview:imageView];
//                imageView.imageLayout = (JFImageLayout*)layout;
//                [self.imageViewsDisplay addObject:imageView];
//            }
//            imageView.delegate = self;
//        }
//    }
//}

# pragma mark - JFLabelDelegate
- (void)label:(JFLabel *)label didClickedTextAtHighlight:(JFTextAttachmentHighlight *)highlight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(asyncView:didClickedAtTextLayout:withHighlight:)]) {
        [self.delegate asyncView:self didClickedAtTextLayout:label.textLayout withHighlight:highlight];
    }
}
- (void)label:(JFLabel *)label didLongPressAtHighlight:(JFTextAttachmentHighlight *)highlight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(asyncView:didLongpressAtTextLayout:withHighlight:)]) {
        [self.delegate asyncView:self didLongpressAtTextLayout:label.textLayout withHighlight:highlight];
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
//    if (self.textLayout) {
//        [self.textLayout drawInContext:context cancelled:cancelled];
//    }
    for (JFLayout* layout in self.layouts.layouts) {
        if ([layout isKindOfClass:[JFTextLayout class]]) {
            JFTextLayout* textLayout = (JFTextLayout*)layout;
            [textLayout drawInContext:context cancelled:cancelled];
        }
    }
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
//    [self.flag incrementFlag];
//    [self layoutAllViews];
    self.layer.contents = nil;
    [UIView performWithoutAnimation:^{
        if (layouts) {
            self.frame = CGRectMake(CGRectGetMinX(layouts.viewFrame),
                                    CGRectGetMinY(layouts.viewFrame),
                                    CGRectGetWidth(layouts.viewFrame),
                                    CGRectGetHeight(layouts.viewFrame));
        } else {
            self.frame = CGRectZero;
        }
    }];
//    self.backgroundColor = layouts.backgroundColor ? textLayout.backgroundColor : [UIColor whiteColor];
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer setNeedsDisplay];
//    if (!CGSizeEqualToSize(layouts.cornerRadius, CGSizeZero)) {
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = textLayout.cornerRadius.height;
//    }
}

# pragma mark - getter

- (NSMutableArray *)labelsStorage {
    if (!_labelsStorage) {
        _labelsStorage = @[].mutableCopy;
    }
    return _labelsStorage;
}
- (NSMutableArray *)labelsDisplay {
    if (!_labelsDisplay) {
        _labelsDisplay = @[].mutableCopy;
    }
    return _labelsDisplay;
}
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

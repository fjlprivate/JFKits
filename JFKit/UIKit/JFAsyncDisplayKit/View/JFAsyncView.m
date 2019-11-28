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


@interface JFAsyncView() < JFImageViewDelegate>
@property (nonatomic, strong) NSMutableArray* labelsStorage;
@property (nonatomic, strong) NSMutableArray* imageViewsStorage;
@property (nonatomic, strong) NSMutableArray* labelsDisplay;
@property (nonatomic, strong) NSMutableArray* imageViewsDisplay;
@property (nonatomic, strong) JFAsyncFlag* flag;
@property (nonatomic, assign) BOOL selectedHighlight;
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
        [self.layouts resetHighlightWhichRaised];
        [self.layer setNeedsDisplay];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        });
        self.selectedHighlight = NO;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectedHighlight) {
        [self.layouts resetHighlightWhichRaised];
        [self.layer setNeedsDisplay];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        });
        self.selectedHighlight = NO;
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

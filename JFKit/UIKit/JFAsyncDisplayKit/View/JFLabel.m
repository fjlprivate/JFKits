//
//  JFLabel.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFLabel.h"
#import "JFAsyncDisplayLayer.h"
#import "JFTextLayout.h"
#import "JFTextAttachment.h"

@interface JFLabel() <JFAsyncDisplayLayerDelegate>
@property (nonatomic, strong) JFTextAttachmentHighlight* selectedHighlight;
@end

@implementation JFLabel

+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.asynchronized = YES;
        self.layer.masksToBounds = YES;
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithLongPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

# pragma mark - setter

- (void)setAsynchronized:(BOOL)asynchronized {
    _asynchronized = asynchronized;
    ((JFAsyncDisplayLayer*)self.layer).asynchronized = asynchronized;
}

- (void)setTextLayout:(JFTextLayout *)textLayout {
    _textLayout = textLayout;
    self.layer.contents = nil;
    [UIView performWithoutAnimation:^{
        if (textLayout) {
            self.frame = CGRectMake(textLayout.viewOrigin.x,
                                    textLayout.viewOrigin.y,
                                    textLayout.suggustSize.width,
                                    textLayout.suggustSize.height);
        } else {
            self.frame = CGRectZero;
        }
    }];
    self.backgroundColor = textLayout.backgroundColor ? textLayout.backgroundColor : [UIColor whiteColor];
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer setNeedsDisplay];
    if (!CGSizeEqualToSize(textLayout.cornerRadius, CGSizeZero)) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = textLayout.cornerRadius.height;
    }
}

# pragma mark - JFAsyncDisplayLayerDelegate

- (void)asyncDisplayLayerWillDisplay:(JFAsyncDisplayLayer *)layer {
    layer.backgroundColor = self.backgroundColor.CGColor;
    layer.opaque = YES;
}

- (void)asyncDisplayLayer:(JFAsyncDisplayLayer *)layer displayingInContext:(CGContextRef)context cancelled:(IsCancelled)cancelled
{
    if (self.textLayout) {
        [self.textLayout drawInContext:context cancelled:cancelled];
    }
}

- (void)asyncDisplayLayerDidEndDisplay:(JFAsyncDisplayLayer *)layer {
    
}

# pragma mark - long press
- (void) handleWithLongPress:(UIGestureRecognizer*)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint curPoint = [longPress locationInView:self];
        self.selectedHighlight = [self checkHighlightAtPosition:curPoint];
        if (self.selectedHighlight) {
            [self updateHighlightOn:YES forTextHighlight:self.selectedHighlight];
        }
        // 回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didLongPressAtHighlight:)]) {
            [self.delegate label:self didLongPressAtHighlight:self.selectedHighlight];
        }
    }
    else {
        if (self.selectedHighlight) {
            [self updateHighlightOn:NO forTextHighlight:self.selectedHighlight];
        }
    }

}

# pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = touches.anyObject;
    CGPoint curTouchP = [touch locationInView:self];
    self.selectedHighlight = [self checkHighlightAtPosition:curTouchP];
    if (self.selectedHighlight) {
        [self updateHighlightOn:YES forTextHighlight:self.selectedHighlight];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectedHighlight) {
        [self updateHighlightOn:NO forTextHighlight:self.selectedHighlight];
        // 回调:有高亮
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didClickedTextAtHighlight:)]) {
            [self.delegate label:self didClickedTextAtHighlight:self.selectedHighlight];
        }
    } else {
        // 回调:无高亮
        if (self.delegate && [self.delegate respondsToSelector:@selector(label:didClickedTextAtHighlight:)]) {
            [self.delegate label:self didClickedTextAtHighlight:nil];
        }
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateAllHighlightsDown];
}


// 检查坐标是否点击在高亮属性上
- (JFTextAttachmentHighlight*) checkHighlightAtPosition:(CGPoint)position {
    // 轮询所有的高亮
    for (JFTextAttachmentHighlight* highlight in self.textLayout.textStorage.highlights) {
        // 检查高亮的所有区域:高亮可能有换行
        for (NSValue* highlightFrame in highlight.uiFrames) {
            CGRect frame = [highlightFrame CGRectValue];
            // 如果点击的点在高亮区域内部
            if (CGRectContainsPoint(frame, position)) {
                return highlight;
            }
        }
    }
    return nil;
}

- (void) updateHighlightOn:(BOOL)on forTextHighlight:(JFTextAttachmentHighlight*)highlight {
    highlight.isHighlight = on;
    [self.textLayout.textStorage addHighlight:highlight];
    [self.layer setNeedsDisplay];
}

- (void) updateAllHighlightsDown {
    for (JFTextAttachmentHighlight* highlight in self.textLayout.textStorage.highlights) {
        highlight.isHighlight = NO;
        [self.textLayout.textStorage addHighlight:highlight];
    }
    [self.layer setNeedsDisplay];
}


@end

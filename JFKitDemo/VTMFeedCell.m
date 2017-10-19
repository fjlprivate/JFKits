//
//  VTMFeedCell.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "VTMFeedCell.h"
#import "MFeedLayout.h"

@interface VTMFeedCell() <JFAsyncDisplayViewDelegate>
@property (nonatomic, strong) JFAsyncDisplayView* asyncView;
@end

@implementation VTMFeedCell

# pragma mask 2 JFAsyncDisplayViewDelegate

- (void)asyncDisplayView:(JFAsyncDisplayView *)asyncView willBeginDrawingInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    // 绘制web背景色
    if (self.layout.webFrame.size.width > 0 && self.layout.webFrame.size.height > 0) {
        CGContextSetFillColorWithColor(context, self.layout.webBackColor.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.layout.webFrame);
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGPathRelease(path);
    }
    // 绘制回复模块背景色
    if (self.layout.commentFrame.size.width > 0 && self.layout.commentFrame.size.height > 0) {
        CGContextSetFillColorWithColor(context, self.layout.commentBackColor.CGColor);
        CGFloat startX = self.layout.commentFrame.origin.x;
        CGFloat startY = self.layout.commentFrame.origin.y;
        CGFloat width = self.layout.commentFrame.size.width;
        CGFloat height = self.layout.commentFrame.size.height;
        CGContextMoveToPoint(context, startX, startY + ChatBubbleTriHeight);
        CGContextAddLineToPoint(context, startX + ChatBubbleTriWidth, startY + ChatBubbleTriHeight);
        CGContextAddLineToPoint(context, startX + ChatBubbleTriWidth * 1.5, startY);
        CGContextAddLineToPoint(context, startX + ChatBubbleTriWidth * 2, startY + ChatBubbleTriHeight);
        CGContextAddLineToPoint(context, startX + width, startY + ChatBubbleTriHeight);
        CGContextAddLineToPoint(context, startX + width, startY + height);
        CGContextAddLineToPoint(context, startX, startY + height);
        CGContextAddLineToPoint(context, startX, startY + ChatBubbleTriHeight);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
    // 绘制点赞分割线
    if (self.layout.seperateLineWidth > 0) {
        CGContextMoveToPoint(context, self.layout.seperateLineStartP.x, self.layout.seperateLineStartP.y);
        CGContextAddLineToPoint(context, self.layout.seperateLineEndP.x, self.layout.seperateLineEndP.y);
        CGContextSetLineWidth(context, self.layout.seperateLineWidth);
        CGContextClosePath(context);
        CGContextSetStrokeColorWithColor(context, self.layout.seperateLineColor.CGColor);
        CGContextStrokePath(context);
        
    }

    CGContextRestoreGState(context);
}

- (void)asyncDisplayView:(JFAsyncDisplayView *)asyncView willEndDrawingInContext:(CGContextRef)context {
    
}

// 点击了textStorage
- (void)asyncDisplayView:(JFAsyncDisplayView *)asyncView didClickedTextStorage:(JFTextStorage *)textStorage withLinkData:(id)linkData {
    if ([linkData isKindOfClass:[NSString class]]) {
        // 先回调去刷新table高度
        if (self.delegate && [self.delegate respondsToSelector:@selector(feedCell:didClickedTextData:)]) {
            [self.delegate feedCell:self didClickedTextData:linkData];
        }
    }
}

// 点击了imageStorage
- (void)asyncDIsplayView:(JFAsyncDisplayView *)asyncView didClickedImageStorage:(JFImageStorage *)imageStorage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCell:didClickedImageData:)]) {
        [self.delegate feedCell:self didClickedImageData:imageStorage.contents];
    }
}


# pragma mask 3 life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _asyncView = [JFAsyncDisplayView new];
        _asyncView.delegate = self;
        [self.contentView addSubview:_asyncView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncView.frame = self.contentView.frame;
}

- (void)setLayout:(MFeedLayout *)layout {
    if (_layout == layout) {
        return;
    }
    _layout = layout;
    self.asyncView.layout = layout;
}


@end

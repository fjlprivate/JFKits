//
//  JFAsyncViewLayouts.m
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/18.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import "JFAsyncViewLayouts.h"
#import "JFHelper.h"

@interface JFAsyncViewLayouts()
@end

@implementation JFAsyncViewLayouts



# pragma mark - 高亮相关

// 点亮指定坐标point的高亮;点亮成功返回:YES;否则返回:NO;
- (BOOL) raiseHighlightAtPoint:(CGPoint)point {
    for (JFLayout* layout in self.layouts) {
        if ([layout isKindOfClass:[JFTextLayout class]]) {
            JFTextLayout* textLayout = (JFTextLayout*)layout;
            for (JFTextAttachmentHighlight* hightlight in textLayout.textStorage.highlights) {
                for (NSValue* frameValue in hightlight.uiFrames) {
                    CGRect frame = [frameValue CGRectValue];
                    if (CGRectContainsPoint(frame, point)) {
                        hightlight.isHighlight = YES;
                        [textLayout.textStorage setTextColor:hightlight.highlightTextColor atRange:hightlight.range];
                        // 引发relayouting
                        textLayout.textStorage = textLayout.textStorage;
                        self.highlightedTextLayout = textLayout;
                        self.selectedHighlight = hightlight;
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

// 恢复被点亮的高亮
- (void) resetHighlightWhichRaised {
    if (self.highlightedTextLayout && self.selectedHighlight) {
        self.selectedHighlight.isHighlight = NO;
        [self.highlightedTextLayout.textStorage setTextColor:self.selectedHighlight.normalTextColor atRange:self.selectedHighlight.range];
        // 引发relayouting
        self.highlightedTextLayout.textStorage = self.highlightedTextLayout.textStorage;
        self.highlightedTextLayout = nil;
        self.selectedHighlight = nil;
    }
}


# pragma mark - ** 必须使用下面的3个方法来[增减]layout
- (void) addLayout:(JFLayout*)layout {
    if (!layout) {
        return;
    }
    [self.layouts addObject:layout];
}
- (void) removeLayout:(JFLayout*)layout {
    if (!layout) {
        return;
    }
    [self.layouts removeObject:layout];
}
- (void) removeAllLayouts {
    [self.layouts removeAllObjects];
}
- (void) replaceLayout:(JFLayout*)layout atIndex:(NSInteger)index {
    if (IsNon(self.layouts)) {
        return;
    }
    if (index >= 0 && index <= self.layouts.count) {
        [self.layouts replaceObjectAtIndex:index withObject:layout];
    }
}
- (NSInteger) indexForLayout:(JFLayout*)layout {
    NSInteger index = NSNotFound;
    for (JFLayout* ilayout in self.layouts) {
        if (ilayout == layout) {
            index = [self.layouts indexOfObject:ilayout];
            break;
        }
    }
    return index;
}



# pragma mark - getter
- (NSMutableArray<JFLayout *> *)layouts {
    if (!_layouts) {
        _layouts = @[].mutableCopy;
    }
    return _layouts;
}

@end

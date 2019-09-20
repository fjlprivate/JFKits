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


# pragma mark - ** 必须使用下面的3个方法来[增减]layout
- (void) addLayout:(JFLayout*)layout {
    if (!layout) {
        return;
    }
    [self.layouts addObject:layout];
    [self resizeContentSize];
}
- (void) removeLayout:(JFLayout*)layout {
    if (!layout) {
        return;
    }
    [self.layouts removeObject:layout];
    [self resizeContentSize];
}
- (void) removeAllLayouts {
    [self.layouts removeAllObjects];
    [self resizeContentSize];
}
- (void) replaceLayout:(JFLayout*)layout atIndex:(NSInteger)index {
    if (IsNon(self.layouts)) {
        return;
    }
    if (index >= 0 && index <= self.layouts.count) {
        [self.layouts replaceObjectAtIndex:index withObject:layout];
        [self resizeContentSize];
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




# pragma mark - 计算内容尺寸
- (void) resizeContentSize {
    CGFloat w = 0;
    CGFloat h = 0;
    for (JFLayout* layout in self.layouts) {
        if (w < layout.right) {
            w = layout.right;
        }
        if (h < layout.bottom) {
            h = layout.bottom;
        }
    }
    self.contentSize = CGSizeMake(w, h);
}

# pragma mark - getter
- (NSMutableArray<JFLayout *> *)layouts {
    if (!_layouts) {
        _layouts = @[].mutableCopy;
    }
    return _layouts;
}

@end

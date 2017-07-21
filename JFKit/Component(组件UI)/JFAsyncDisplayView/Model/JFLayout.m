//
//  JFLayout.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFLayout.h"

@implementation JFLayout

- (void)addStorage:(JFStorage *)storage {
    if (![self.storages containsObject:storage]) {
        [self.storages addObject:storage];
    }
}



# pragma mask 4 getter

- (NSMutableArray<JFStorage *> *)storages {
    if (!_storages) {
        _storages = [NSMutableArray array];
    }
    return _storages;
}

- (CGFloat)bottom {
    _bottom = 0;
    for (JFStorage* storage in _storages) {
        if (_bottom < storage.bottom) {
            _bottom = storage.bottom;
        }
    }
    return _bottom;
}

@end

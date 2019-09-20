//
//  JFAsyncFlag.m
//  RuralMeet
//
//  Created by LiChong on 2017/11/24.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "JFAsyncFlag.h"
#import <stdatomic.h>
#import <libkern/OSAtomic.h>
@interface JFAsyncFlag() {
//    atomic_int flag;
    int32_t flag;
}
@end

@implementation JFAsyncFlag

- (int)curFlag {
    return flag;
}
- (void)incrementFlag {
//    atomic_fetch_add(&flag, 1);
    OSAtomicIncrement32(&flag);
}

@end

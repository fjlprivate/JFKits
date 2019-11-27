//
//  JFImageLayout.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFImageLayout.h"

@implementation JFImageLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}



@end

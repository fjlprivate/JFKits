//
//  NSBundle+JFExtension.m
//  JFKitDemo
//
//  Created by 严美 on 2019/9/28.
//  Copyright © 2019 JohnnyFeng. All rights reserved.
//

#import "NSBundle+JFExtension.h"
#import "JFHelper.h"

@implementation NSBundle (JFExtension)

/**
 获取JFKit.bundle
 @return NSBundle
 */
+ (instancetype) jf_kitBundle {
    NSBundle* bundle = [NSBundle bundleForClass:[JFHelper class]];
    NSString* path = [bundle pathForResource:@"JFKit" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}

@end

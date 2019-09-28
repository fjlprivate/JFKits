//
//  NSBundle+JFExtension.h
//  JFKitDemo
//
//  Created by 严美 on 2019/9/28.
//  Copyright © 2019 JohnnyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (JFExtension)

/**
 获取JFKit.bundle
 @return NSBundle
 */
+ (instancetype) jf_kitBundle;
@end

NS_ASSUME_NONNULL_END

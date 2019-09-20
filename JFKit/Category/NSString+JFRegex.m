//
//  NSString+JFRegex.m
//  QiangQiang
//
//  Created by LiChong on 2018/3/23.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "NSString+JFRegex.h"
#import "JFHelper.h"

@implementation NSString (JFRegex)

/**
 是否全数字字符串;
 @return yes|no
 */
- (BOOL) jf_isAllNumber {
    if (IsNon(self)) {
        return NO;
    }
    NSString* regex = @"[0-9]*";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

@end

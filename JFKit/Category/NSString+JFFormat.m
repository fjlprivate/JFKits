//
//  NSString+JFFormat.m
//  QiangQiang
//
//  Created by LiChong on 2018/4/17.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import "NSString+JFFormat.h"
#import "JFHelper.h"

@implementation NSString (JFFormat)

/**
 检查字符串是否为手机号
 @return YES:是手机号;NO:不是;
 */
- (BOOL) jf_isPhoneNumber {
    if (IsNon(self)) {
        return NO;
    }
    if (self.length != 11) {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    return ([regextestmobile evaluateWithObject:self] == YES)
    || ([regextestcm evaluateWithObject:self] == YES)
    || ([regextestct evaluateWithObject:self] == YES)
    || ([regextestcu evaluateWithObject:self] == YES);
}

/**
 匹配出字符串中的所有手机号的range组;
 @return 手机号range组;
 */
- (NSArray*) jf_phoneStringRangesFetched {
    if (IsNon(self)) {
        return nil;
    }
    if (self.length < 11) {
        return nil;
    }
    
    NSMutableArray* list = @[].mutableCopy;
    for (NSInteger i = 0; i < self.length; i++) {
        NSString* temp = [self substringWithRange:NSMakeRange(i, 1)];
        if (self.length - i < 11) {
            break;
        }
        if ([temp isEqualToString:@"1"]) {
            NSString* phone = [self substringWithRange:NSMakeRange(i, 11)];
            if ([phone jf_isPhoneNumber]) {
                [list addObject:[NSValue valueWithRange:NSMakeRange(i, 11)]];
            }
        }
    }

    return list;
}

/**
 匹配出字符串中的所有网页url的range组;
 @return 网页url的range组;
 */
- (NSArray*) jf_urlRangesFetched {
    if (IsNon(self)) {
        return nil;
    }
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        return nil;
    }
    NSArray *arrayOfAllMatches = [regex matchesInString:self
                                                options:0
                                                  range:NSMakeRange(0, [self length])];
    
    NSMutableArray *arr = @[].mutableCopy;
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        [arr addObject:[NSValue valueWithRange:match.range]];
    }
    return arr;
}


@end

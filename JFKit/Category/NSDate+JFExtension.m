//
//  NSDate+JFExtension.m
//  AntPocket
//
//  Created by cui on 2019/8/22.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import "NSDate+JFExtension.h"

@implementation NSDate (JFExtension)

- (NSString *)jf_readableString {
    if (!self) {
        return nil;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    // 刚刚
    if ([self jf_inOneMin]) {
        return @"刚刚";
    }
    // 今天
    else if ([self jf_isToday]) {
        dateFormatter.dateFormat = @"HH:mm";
        return [dateFormatter stringFromDate:self];
    }
    // 昨天
    else if ([self jf_isYesterday]) {
        return @"昨天";
    }
    // 一周内
    else if ([self jf_inOneWeek]) {
        NSInteger weekDay = [self jf_weekDay];
        NSArray* weaks = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        return weaks[weekDay];
    }
    // 显示整个时间
    else {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [dateFormatter stringFromDate:self];
    }
}

// 今天
- (BOOL) jf_isToday {
    if (!self) {
        return NO;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMdd"; //yyyyMMddHHmmss
    NSString* selfDateString = [dateFormatter stringFromDate:self];
    NSString* curDateString = [dateFormatter stringFromDate:[NSDate date]];
    return [selfDateString isEqualToString:curDateString];
}
// 明天
- (BOOL) jf_isTomorrow {
    if (!self) {
        return NO;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMdd"; //yyyyMMddHHmmss
    NSString* selfDateString = [dateFormatter stringFromDate:self];
    NSString* curDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger curDay = [[curDateString substringFromIndex:curDateString.length - 2] integerValue];
    NSInteger selfDay = [[selfDateString substringFromIndex:curDateString.length - 2] integerValue];
    return selfDay - curDay == 1;
}
// 昨天
- (BOOL) jf_isYesterday {
    if (!self) {
        return NO;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMdd"; //yyyyMMddHHmmss
    NSString* selfDateString = [dateFormatter stringFromDate:self];
    NSString* curDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger curDay = [[curDateString substringFromIndex:curDateString.length - 2] integerValue];
    NSInteger selfDay = [[selfDateString substringFromIndex:curDateString.length - 2] integerValue];
    return curDay - selfDay == 1;
}

// 本周
- (BOOL) jf_isWeek {
    if ([self jf_inOneWeek]) {
        NSDateFormatter* dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyyMMdd"; //yyyyMMddHHmmss
        NSDate* curDate = [NSDate date];
        NSInteger curDay = [[dateFormatter stringFromDate:self] integerValue];
        NSInteger selfDay = [[dateFormatter stringFromDate:curDate] integerValue];
        NSInteger curWeekDay = [curDate jf_weekDay];
        NSInteger selfWeekDay = [self jf_weekDay];
        if (curDay == selfDay) {
            return YES;
        }
        else if (curDay > selfDay) {
            return selfWeekDay < curWeekDay;
        }
        else { // curDay < selfDay
            return curWeekDay < selfWeekDay;
        }
    }
    return NO;
}
// 本月
- (BOOL) jf_isMonth {
    if (!self) {
        return NO;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMM"; //yyyyMMddHHmmss
    NSString* selfDateString = [dateFormatter stringFromDate:self];
    NSString* curDateString = [dateFormatter stringFromDate:[NSDate date]];
    return [selfDateString isEqualToString:curDateString];
}
// 本年
- (BOOL) jf_isYear {
    if (!self) {
        return NO;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy"; //yyyyMMddHHmmss
    NSString* selfDateString = [dateFormatter stringFromDate:self];
    NSString* curDateString = [dateFormatter stringFromDate:[NSDate date]];
    return [selfDateString isEqualToString:curDateString];
}

// 一分钟内
- (BOOL) jf_inOneMin {
    NSDate* curDate = [NSDate date];
    NSTimeInterval curTimeInterval = [curDate timeIntervalSince1970];
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    return ABS(curTimeInterval - selfTimeInterval) < 60;
}

// 一天内
- (BOOL) jf_inOneDay {
    NSDate* curDate = [NSDate date];
    NSTimeInterval curTimeInterval = [curDate timeIntervalSince1970];
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    return ABS(curTimeInterval - selfTimeInterval) < 24 * 60 * 60;
}
// 一周内
- (BOOL) jf_inOneWeek {
    NSDate* curDate = [NSDate date];
    NSTimeInterval curTimeInterval = [curDate timeIntervalSince1970];
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    return ABS(curTimeInterval - selfTimeInterval) < (7 - 1) * 24 * 60 * 60;
}
// 一月内
- (BOOL) jf_inOneMonth {
    NSDate* curDate = [NSDate date];
    NSTimeInterval curTimeInterval = [curDate timeIntervalSince1970];
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    return ABS(curTimeInterval - selfTimeInterval) < 30 * 24 * 60 * 60;
}
// 一年内
- (BOOL) jf_inOneYear {
    NSDate* curDate = [NSDate date];
    NSTimeInterval curTimeInterval = [curDate timeIntervalSince1970];
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    return ABS(curTimeInterval - selfTimeInterval) < 365 * 24 * 60 * 60;
}

// 星期几:0(周天),1(周一),2(周二),3(周三),4(周四),5(周五),6(周六)
- (NSInteger) jf_weekDay {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    NSDateComponents* components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekDay = components.weekday - 1;
    if (weekDay < 0) {
        weekDay = 0;
    }
    return weekDay;
}


@end

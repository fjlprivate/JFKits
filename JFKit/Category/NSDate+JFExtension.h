//
//  NSDate+JFExtension.h
//  AntPocket
//
//  Created by cui on 2019/8/22.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (JFExtension)

// 可读的时间
- (NSString*) jf_readableString;

// 今天
- (BOOL) jf_isToday;
// 明天
- (BOOL) jf_isTomorrow;
// 昨天
- (BOOL) jf_isYesterday;

// 本周
- (BOOL) jf_isWeek;
// 本月
- (BOOL) jf_isMonth;
// 本年
- (BOOL) jf_isYear;

// 一分钟内
- (BOOL) jf_inOneMin;
// 一天内
- (BOOL) jf_inOneDay;
// 一周内
- (BOOL) jf_inOneWeek;
// 一月内
- (BOOL) jf_inOneMonth;
// 一年内
- (BOOL) jf_inOneYear;

// 星期几:0(周天),1(周一),2(周二),3(周三),4(周四),5(周五),6(周六)
- (NSInteger) jf_weekDay;


/**
 根据给定的格式生成日期字符串
 @param format 日期格式;如果为nil,默认: yyyy-MM-dd HH:mm:ss
 @return 格式化后的日期字符串
 */
- (NSString*) stringWithFormat:(NSString*)format;



@end

NS_ASSUME_NONNULL_END

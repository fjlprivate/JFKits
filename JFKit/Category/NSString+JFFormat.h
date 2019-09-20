//
//  NSString+JFFormat.h
//  QiangQiang
//
//  Created by LiChong on 2018/4/17.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JFFormat)

/**
 检查字符串是否为手机号
 @return YES:是手机号;NO:不是;
 */
- (BOOL) jf_isPhoneNumber;



/**
 匹配出字符串中的所有手机号的range组;
 @return 手机号range组;
 */
- (NSArray*) jf_phoneStringRangesFetched;


/**
 匹配出字符串中的所有网页url的range组;
 @return 网页url的range组;
 */
- (NSArray*) jf_urlRangesFetched;
@end

//
//  NSError+Extension.m
//  RuralMeet
//
//  Created by LiChong on 2018/1/17.
//  Copyright © 2018年 occ. All rights reserved.
//

#import "NSError+Extension.h"
#import "JFHelper.h"

@implementation NSError (Extension)

+ (instancetype) jf_errorWithCode:(NSInteger)code localizedDescription:(NSString*)description {
    if (IsNon(description)) {
        return nil;
    }
    return [NSError errorWithDomain:@"" code:code userInfo:@{NSLocalizedDescriptionKey:description}];
}

@end

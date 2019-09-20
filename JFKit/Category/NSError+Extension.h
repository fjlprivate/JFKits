//
//  NSError+Extension.h
//  RuralMeet
//
//  Created by LiChong on 2018/1/17.
//  Copyright © 2018年 occ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extension)

+ (instancetype) jf_errorWithCode:(NSInteger)code localizedDescription:(NSString*)description;

@end

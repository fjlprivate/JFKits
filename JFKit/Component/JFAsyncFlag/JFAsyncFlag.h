//
//  JFAsyncFlag.h
//  RuralMeet
//
//  Created by LiChong on 2017/11/24.
//  Copyright © 2017年 occ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFAsyncFlag : NSObject

@property (nonatomic, assign, readonly) int curFlag;

- (void) incrementFlag;

@end

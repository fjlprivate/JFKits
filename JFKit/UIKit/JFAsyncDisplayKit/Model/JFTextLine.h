//
//  JFTextLine.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "JFConstant.h"

@class JFTextRun;

@interface JFTextLine : NSObject

/**
 创建并初始化JFTextLine;
 @param ctLine CoreText的行属性对象;
 @param origin 行的baseLine起点<CoreText坐标系>;
 @param frame 文本的frame;
 @param cancelled 退出初始化步骤;
 @return JFTextLine;cancelled退出时,返回nil;
 */
+ (instancetype) textLineWithCTLine:(CTLineRef)ctLine origin:(CGPoint)origin frame:(CGRect)frame cancelled:(IsCancelled)cancelled;

@property (nonatomic, assign, readonly) CTLineRef ctLine;

@property (nonatomic, assign) CGPoint ctOrigin;
@property (nonatomic, assign, readonly) CGPoint uiOrigin;

@property (nonatomic, assign, readonly) CGFloat ascent;
@property (nonatomic, assign, readonly) CGFloat descent;
@property (nonatomic, assign, readonly) CGFloat leading;
@property (nonatomic, assign, readonly) CGFloat width;

@property (nonatomic, strong, readonly) NSArray<JFTextRun*>* ctRuns;

@end

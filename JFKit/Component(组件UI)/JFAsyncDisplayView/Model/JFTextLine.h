//
//  JFTextLine.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/13.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "JFTextRun.h"

@interface JFTextLine : NSObject

- (instancetype) initWithLine:(CTLineRef)lineRef origin:(CGPoint)position textFrame:(CGRect)textFrame;

@property (nonatomic, assign, readonly) CTLineRef lineRef; // 指针引用，指向一个文本行缓存数据

@property (nonatomic, assign, readonly) CGPoint lineOrigin; // <core text坐标系>,绘制前，需要先 CGContextSetTextOrigin

@property (nonatomic, assign, readonly) CGPoint uiLineOrigin; // <UIKit坐标系>

@property (nonatomic, assign, readonly) CGFloat typographicWidth; // 当前行的排版width

@property (nonatomic, assign, readonly) CGFloat ascent; // 上部
@property (nonatomic, assign, readonly) CGFloat desent; // 下部
@property (nonatomic, assign, readonly) CGFloat leading; // 行间距

@property (nonatomic, strong, readonly) NSArray<JFTextRun*>* glyphRuns; // 当前行的所有run

@end

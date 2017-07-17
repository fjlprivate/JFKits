//
//  JFTextRun.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/17.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "JFTextGlyph.h"

@interface JFTextRun : NSObject

- (instancetype) initWithRun:(CTRunRef)runRef linePosition:(CGPoint)linePosition textFrame:(CGRect)textFrame;

@property (nonatomic, assign, readonly) CTRunRef runRef; // 一个CTRun

@property (nonatomic, assign, readonly) CGPoint linePosition; // 当前run所属的line的起点坐标<Core text坐标系>

@property (nonatomic, assign, readonly) CGRect runFrame; // 当前run的frame<UIKit坐标系>

@property (nonatomic, strong, readonly) NSArray<JFTextGlyph*>* glyphs; // 当前run的所有字形

@end

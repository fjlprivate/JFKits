//
//  JFTextGlyph.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/17.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface JFTextGlyph : NSObject <NSCopying>

@property (nonatomic, assign) CGRect uiGlyphFrame;

@property (nonatomic, assign) CGRect ctGlyphFrame;

@end

//
//  JFTextGlyph.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/17.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFTextGlyph.h"

@implementation JFTextGlyph

- (id)copyWithZone:(NSZone *)zone {
    JFTextGlyph* glyph = [JFTextGlyph allocWithZone:zone];
    glyph.uiGlyphFrame = self.uiGlyphFrame;
    glyph.ctGlyphFrame = self.ctGlyphFrame;
    return glyph;
}


@end

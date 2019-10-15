//
//  JFTextStorage.m
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/25.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import "JFTextStorage.h"
#import "NSMutableAttributedString+Extension.h"
#import "JFHelper.h"

@interface JFTextStorage()
@end

@implementation JFTextStorage

+ (instancetype)storageWithText:(NSString *)text {
    if (IsNon(text)) {
        return nil;
    }
    NSMutableAttributedString* attriText = [[NSMutableAttributedString alloc] initWithString:text];
    return [[JFTextStorage alloc] initWithAttributedString:attriText];
}

- (instancetype) initWithAttributedString:(NSMutableAttributedString*)text {
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

- (void)addHighlight:(JFTextAttachmentHighlight *)highlight {
    if ([self.highlights containsObject:highlight]) {
        [self.highlights removeObject:highlight];
    }
    for (JFTextAttachmentHighlight* inHighlight in self.highlights) {
        if (NSEqualRanges(inHighlight.range, highlight.range)) {
            [self.highlights removeObject:inHighlight];
            break;
        }
    }
    if (highlight.range.location != NSNotFound) {
        [self.text jf_setHighlight:highlight];
    }
    [self.highlights addObject:highlight];
}
- (void)addImage:(JFTextAttachmentImage *)image {
    [self.text jf_addImage:image];
    [self.images addObject:image];
}

# pragma mark - setter
- (void) setFont:(UIFont *)font atRange:(NSRange)range {
    [self.text jf_setFont:font atRange:range];
}
- (void) setTextColor:(UIColor *)textColor atRange:(NSRange)range {
    [self.text jf_setTextColor:textColor atRange:range];
}
- (void) setLineSpacing:(CGFloat)lineSpacing atRange:(NSRange)range {
    [self.text jf_setLineSpacing:lineSpacing atRange:range];
}
- (void) setKern:(CGFloat)kern atRange:(NSRange)range {
    [self.text jf_setKern:kern atRange:range];
}
- (void) setBackgroundColor:(UIColor *)backgroundColor atRange:(NSRange)range {
    [self.text jf_setBackgroundColor:backgroundColor atRange:range];
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment atRange:(NSRange)range {
    [self.text jf_setTextAlignment:textAlignment atRange:range];
}


- (void)setFont:(UIFont *)font {
    _font = font;
    [self setFont:font atRange:NSMakeRange(0, self.text.length)];
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setTextColor:textColor atRange:NSMakeRange(0, self.text.length)];
}
- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    [self setLineSpacing:lineSpacing atRange:NSMakeRange(0, self.text.length)];
}
- (void)setKern:(CGFloat)kern {
    _kern = kern;
    [self setKern:kern atRange:NSMakeRange(0, self.text.length)];
}
//- (void)setBackgroundColor:(UIColor *)backgroundColor {
//    _backgroundColor = backgroundColor;
//    [self setBackgroundColor:backgroundColor atRange:NSMakeRange(0, self.text.length)];
//}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    [self setTextAlignment:textAlignment atRange:NSMakeRange(0, self.text.length)];
}


# pragma mark - getter
- (NSMutableArray *)highlights {
    if (!_highlights) {
        _highlights = @[].mutableCopy;
    }
    return _highlights;
}
- (NSMutableArray *)images {
    if (!_images) {
        _images = @[].mutableCopy;
    }
    return _images;
}


@end

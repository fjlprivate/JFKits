//
//  JFButton.m
//  JFKit
//
//  Created by warmjar on 2017/7/11.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFButton.h"

@implementation JFButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.touchEdges = UIEdgeInsetsMake(-20, -20, -20, -20);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (IBAction) touchUpInside:(UIButton*)sender {
    if (self.didTouchedUpInside) {
        self.didTouchedUpInside();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || self.alpha < 0.1) {
        return [super hitTest:point withEvent:event];
    }
    CGRect rect = CGRectMake(0 + self.touchEdges.left,
                             0 +self.touchEdges.top,
                             self.bounds.size.width - (self.touchEdges.left + self.touchEdges.right),
                             self.bounds.size.height - (self.touchEdges.top + self.touchEdges.bottom));
    if (CGRectContainsPoint(rect, point)) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return contentRect;
}

# pragma mask 4 setter

- (void)setNormalTitle:(NSString *)normalTitle {
    if (normalTitle) {
        [self setTitle:normalTitle forState:UIControlStateNormal];
    }
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    if (normalTitleColor) {
        [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
}

- (void)setHighLightTitleColor:(UIColor *)highLightTitleColor {
    if (highLightTitleColor) {
        [self setTitleColor:highLightTitleColor forState:UIControlStateHighlighted];
    }
}

- (void)setDisableTitleColor:(UIColor *)disableTitleColor {
    if (disableTitleColor) {
        [self setTitleColor:disableTitleColor forState:UIControlStateDisabled];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (titleFont) {
        self.titleLabel.font = titleFont;
    }
}

# pragma mask 4 getter

- (NSString *)normalTitle {
    return [self titleForState:UIControlStateNormal];
}
- (UIColor *)normalTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}
- (UIColor *)highLightTitleColor {
    return [self titleColorForState:UIControlStateHighlighted];
}
- (UIColor *)disableTitleColor {
    return [self titleColorForState:UIControlStateDisabled];
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

@end

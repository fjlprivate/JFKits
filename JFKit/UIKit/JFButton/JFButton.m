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
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (IBAction) touchUpInside:(UIButton*)sender {
    if (self.didTouchedUpInside) {
        self.didTouchedUpInside();
    }
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

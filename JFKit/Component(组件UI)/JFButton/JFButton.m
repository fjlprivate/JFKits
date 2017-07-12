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


@end

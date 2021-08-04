//
//  DecorationView.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/10.
//

#import "DecorationView.h"

@implementation DecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        self.layer.shadowRadius = 4;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}


@end

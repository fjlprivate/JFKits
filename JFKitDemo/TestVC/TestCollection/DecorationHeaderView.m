//
//  DecorationHeaderView.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/10.
//

#import "DecorationHeaderView.h"
#import <Masonry.h>

@implementation DecorationHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self addSubview:self.labContent];
        [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
        }];
    }
    return self;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.textColor = UIColor.blackColor;
        _labContent.font = [UIFont systemFontOfSize:15];
    }
    return _labContent;
}

@end

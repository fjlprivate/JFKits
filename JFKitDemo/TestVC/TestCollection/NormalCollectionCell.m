//
//  NormalCollectionCell.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/10.
//

#import "NormalCollectionCell.h"
#import <Masonry.h>

@implementation NormalCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 10;
        [self.contentView addSubview:self.labContent];
        [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
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

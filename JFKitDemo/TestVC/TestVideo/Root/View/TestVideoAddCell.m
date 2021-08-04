//
//  TestVideoAddCell.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/25.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestVideoAddCell.h"
#import "JFKit.h"

@interface TestVideoAddCell()
@property (nonatomic, strong) UILabel* labContent;
@end
@implementation TestVideoAddCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.labContent];
        [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
        }];
        self.contentView.backgroundColor = JFRGBAColor(0, 0.1);
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 10;
    }
    return self;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.text = [NSString fontAwesomeIconStringForEnum:FAPlus];
        _labContent.font = [UIFont fontAwesomeFontOfSize:25];
        _labContent.textColor = JFRGBAColor(0x666666, 1);
    }
    return _labContent;
}

@end

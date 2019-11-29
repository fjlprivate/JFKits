//
//  APTransHashCellHeader.m
//  AntPocket
//
//  Created by 严美 on 2019/10/9.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import "APTransHashCellHeader.h"
#import <Masonry.h>

@interface APTransHashCellHeader ()
@property (nonatomic, strong) UIView* vSection;
@property (nonatomic, strong) UIView* vLine;

@end

@implementation APTransHashCellHeader
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.asyncView];
        [self.contentView addSubview:self.vSection];
        [self.contentView addSubview:self.vLine];
        [self.asyncView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}
- (JFAsyncView *)asyncView {
    if (!_asyncView) {
        _asyncView = [JFAsyncView new];
    }
    return _asyncView;
}

- (void)setLayouts:(APTransHashHeaderLayouts *)layouts {
    _layouts = layouts;
    self.asyncView.layouts = layouts;
}

- (UIView *)vSection {
    if (!_vSection) {
        _vSection = [UIView new];
        _vSection.backgroundColor = JFRGBAColor(0xF5F5FA, 1);
    }
    return _vSection;
}
- (UIView *)vLine {
    if (!_vLine) {
        _vLine = [UIView new];
        _vLine.backgroundColor = JFRGBAColor(0xe6e6e6, 1);
    }
    return _vLine;
}
@end

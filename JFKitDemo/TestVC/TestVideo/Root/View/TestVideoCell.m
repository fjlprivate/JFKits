//
//  TestVideoCell.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/25.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestVideoCell.h"
#import "JFKit.h"

@interface TestVideoCell()
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* vMask;
@property (nonatomic, strong) UILabel* labDisplay;
@end

@implementation TestVideoCell

- (void)setCellModel:(TestVideoModel *)cellModel {
    _cellModel = cellModel;
    if (cellModel) {
        if (cellModel.type == TestVideoModelTypeVideo) {
            self.imageView.image = cellModel.thumbnail;
            self.labDisplay.text = [NSString fontAwesomeIconStringForEnum:FAVideoCamera];
        } else {
            self.imageView.image = cellModel.image;
            self.labDisplay.text = [NSString fontAwesomeIconStringForEnum:FAPictureO];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = JFRGBAColor(0, 0.1);
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 10;
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.vMask];
        [self.contentView addSubview:self.labDisplay];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.vMask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.labDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.bottom.mas_equalTo(-6);
        }];
    }
    return self;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UILabel *)labDisplay {
    if (!_labDisplay) {
        _labDisplay = [UILabel new];
        _labDisplay.font = [UIFont fontAwesomeFontOfSize:16];
        _labDisplay.textColor = JFRGBAColor(0xffffff, 1);
    }
    return _labDisplay;
}
- (UIView *)vMask {
    if (!_vMask) {
        _vMask = [UIView new];
        _vMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _vMask;
}
@end

//
//  TestImageBrowserCell.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/22.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestImageBrowserCell.h"
#import <Masonry.h>

@implementation TestImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return  self;
}

- (UIImageView *)imageView {
    if (!_imageView ){
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}



@end

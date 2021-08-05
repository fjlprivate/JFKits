//
//  JFImageBrowserCell.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/24.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "JFImageBrowserCell.h"
#import <Masonry/Masonry.h>

@implementation JFImageBrowserCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}
- (JFZoomImageView *)imageView {
    if (!_imageView) {
        _imageView = [JFZoomImageView new];
    }
    return _imageView;
}
@end

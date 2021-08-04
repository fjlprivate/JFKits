//
//  TestImageBrowserPreviewCell.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/23.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestImageBrowserPreviewCell.h"
#import <Masonry.h>

@implementation TestImageBrowserPreviewCell
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

- (JFZoomImageView *)imageView {
    if (!_imageView ){
        _imageView = [JFZoomImageView new];
        _imageView.maximumZoomScale = 5.f;
    }
    return _imageView;
}

@end

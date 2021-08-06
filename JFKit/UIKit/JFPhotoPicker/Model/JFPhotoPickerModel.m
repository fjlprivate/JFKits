//
//  JFPhotoPickerModel.m
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFPhotoPickerModel.h"
#import <UIKit/UIKit.h>
#import "JFMacro.h"

@implementation JFPhotoPickerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enableSelect = YES;
        self.isSelected = NO;
        self.selectedIndex = NSNotFound;
        self.requestID = NSNotFound;
    }
    return self;
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    if (!asset || asset.pixelWidth <= 0 || asset.pixelHeight <= 0) {
        return;
    }
    CGFloat maxWidth = JFSCREEN_WIDTH * 0.5;
    CGFloat maxHeight = JFSCREEN_HEIGHT * 0.5;
    CGSize size = CGSizeMake(maxWidth, maxHeight);
    // 宽高比 >= 屏幕宽高比
    if (asset.pixelWidth/asset.pixelHeight >= maxWidth/maxHeight) {
        size.width = asset.pixelWidth >= maxWidth ? maxWidth : asset.pixelWidth;
        size.height = size.width * asset.pixelHeight/asset.pixelWidth;
    }
    // 宽高比 < 屏幕宽高比
    else {
        size.height = asset.pixelHeight >= maxHeight ? maxHeight : asset.pixelHeight;
        size.width = size.height * asset.pixelWidth/asset.pixelHeight;
    }
    self.thumbSize = size;
}


@end

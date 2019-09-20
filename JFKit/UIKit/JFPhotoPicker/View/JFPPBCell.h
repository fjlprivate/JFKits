//
//  JFPPBCell.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/1.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFPhotoPickerModel;
@interface JFPPBCell : UICollectionViewCell
@property (nonatomic, strong) JFPhotoPickerModel* model;

// 单击事件
@property (nonatomic, copy) void (^ handleWithTap) (NSInteger numberOfTouchs);

@end

NS_ASSUME_NONNULL_END

//
//  JFPhotoPickerCell.h
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFPhotoPickerModel;
@interface JFPhotoPickerCell : UICollectionViewCell
@property (nonatomic, strong) JFPhotoPickerModel* model;

/**
 回调: 选中|未选中状态更新;
 只有btn点击事件引发此回调;
 */
@property (nonatomic, copy) void (^ didUpdateSelectState) (JFPhotoPickerCell* cell, JFPhotoPickerModel* model);


@end

NS_ASSUME_NONNULL_END

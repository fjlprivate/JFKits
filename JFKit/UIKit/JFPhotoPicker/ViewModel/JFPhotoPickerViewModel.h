//
//  JFPhotoPickerViewModel.h
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFPhotoPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

// 定义回调block
typedef void (^JFFinishedBlock)(NSArray<JFPhotoPickerModel*>* models);

@interface JFPhotoPickerViewModel : NSObject

/**
 * 最大采集数量;(默认0)
 * 0: 无限个;
 * 当为1时,不显示选择标签;
 */
@property (nonatomic, assign) NSInteger maxPickerCount;

/**
 获取照片|视频资源
 @param mediaType                           资源类型(PHAssetMediaType)
 @param finishedBlock                       回调:读取到相册中的图片|视频组<JFPhotoPickerModel*>
 */
- (void) jf_requestMediasForType:(PHAssetMediaType)mediaType onFinished:(JFFinishedBlock)finishedBlock;

/**
 请求所有被选择的model的原始多媒体数据;
 @param finishedBlock                       回调: NSArray<JFPhotoPickerModel*>;imagePath|videoPath必须填充好
 @param failedBlock                         回调: 失败
 */
- (void) jf_requestAllSelectedMediasOnFinished:(JFFinishedBlock)finishedBlock orFailed:(JFFinishedBlock)failedBlock;


/**
 获取指定位置的原始数据
 @param index                               指定位置
 @param finishedBlock                       回调: <JFPhotoPickerModel*>;imagePath|videoPath必须填充好
 @param failedBlock                         回调: 失败
 */
- (void) jf_requestOriginMediaAtIndex:(NSInteger)index onFinished:(JFFinishedBlock)finishedBlock orFailed:(JFFinishedBlock)failedBlock;


- (NSInteger) jf_numberOfSections;
- (NSInteger) jf_numberOfRowsInSection:(NSInteger)section;
- (JFPhotoPickerModel*) jf_modelForRowAtIndexPath:(NSIndexPath*)indexPath;


// 更新指定model的被选择状态;同时要更新其他model的状态和enable;
- (void) jf_exchangeModelSelectedState:(JFPhotoPickerModel*)model;

// 已被选中的model的个数
- (NSInteger) jf_numberOfSelectedModels;


// 生成模型的多媒体文件保存路径
+ (NSString*) mediaPathForModel:(JFPhotoPickerModel*)model;

@end

NS_ASSUME_NONNULL_END

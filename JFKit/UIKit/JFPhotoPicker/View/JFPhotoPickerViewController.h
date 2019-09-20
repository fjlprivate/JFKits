//
//  JFPhotoPickerViewController.h
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFPhotoPickerModel.h"

NS_ASSUME_NONNULL_BEGIN


@class JFPhotoPickerViewController;
@protocol JFPhotoPickerViewControllerDelegate <NSObject>


/**
 采集图片|视频完成;
 @param photoPicker                         照片采集器
 @param medias                              多媒体数组(图片|视频)
 */
- (void) jf_photoPicker:(JFPhotoPickerViewController*)photoPicker didPickedMedias:(NSArray<JFPhotoPickerModel*>*)medias;


@optional

/**
 取消采集器;
 @param photoPicker                         照片采集器
 */
- (void) jf_photoPickerCanced:(JFPhotoPickerViewController*)photoPicker;

@end


/* -- 图片|视频采集器 -- */
@interface JFPhotoPickerViewController : UIViewController


/**
 初始化;
 @param mediaType                           采集类型
 @param maxPickerCount                      最大采集数量
 @param delegate                            代理
 @return JFPhotoPickerViewController*
 */
- (instancetype) initWithMediaType:(PHAssetMediaType)mediaType
                    maxPickerCount:(NSInteger)maxPickerCount
                          delegate:(id<JFPhotoPickerViewControllerDelegate>)delegate;

/**
 * 采集类型;仅图片，或仅视频，或图片+视频
 */
@property (nonatomic, assign) PHAssetMediaType mediaType;


// ** 布局属性
// 每行多少个row;默认:4
@property (nonatomic, assign) NSInteger numberOfItemsPerLine;
// 行间距;默认:2
@property (nonatomic, assign) CGFloat minLineSpacing;
// item间距;默认:2
@property (nonatomic, assign) CGFloat minInteritemSpacing;
// 分部间距;默认:zero
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

// 背景色;默认:0x0E0D1A
@property (nonatomic, copy) UIColor* bgColor;
// 导航栏背景色;默认:0x0E0D1A
@property (nonatomic, copy) UIColor* navigationBarBgColor;
// 导航栏主题色;默认:0xFFFFFF
@property (nonatomic, copy) UIColor* navigationBarTintColor;
// 导航栏退出按钮图片名称;默认:delete
@property (nonatomic, copy) NSString* navigationCancelImageName;



@end

NS_ASSUME_NONNULL_END

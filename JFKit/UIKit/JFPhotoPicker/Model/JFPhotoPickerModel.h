//
//  JFPhotoPickerModel.h
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


NS_ASSUME_NONNULL_BEGIN

@interface JFPhotoPickerModel : NSObject
// 多媒体资源;包括类型、尺寸、时长、定位等信息;
@property (nonatomic, strong) PHAsset* asset;
// 缩略图
//@property (nonatomic, strong) UIImage* thumbImage;
// 缩略图尺寸;最大为屏幕尺寸;由asset.pixelWidth&pixelHeight计算;
@property (nonatomic, assign) CGSize thumbSize;
// 原始数据(图片:路径NSString|视频AVAsset)
@property (nonatomic, copy) id originData;
// 原始数据大小;单位byte
@property (nonatomic, assign) NSInteger originDataLength;

// 多媒体的请求id;如果没有请求,或者请求结束了,值为NSNotFound;默认:NSNotFound;
@property (nonatomic, assign) NSInteger requestID;


// 是否支持select;默认:YES;
@property (nonatomic, assign) BOOL enableSelect;
// 是否选中;默认:NO;
@property (nonatomic, assign) BOOL isSelected;
// 被选择的序号
@property (nonatomic, assign) NSInteger selectedIndex;


@end

NS_ASSUME_NONNULL_END

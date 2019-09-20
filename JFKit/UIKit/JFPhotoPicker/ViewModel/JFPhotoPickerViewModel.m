//
//  JFPhotoPickerViewModel.m
//  QiangQiang
//
//  Created by longerFeng on 2019/3/28.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "JFPhotoPickerViewModel.h"
#import "JFHelper.h"
#import "UIImage+JFExtension.h"
#import "UIImage+Format.h"

@interface JFPhotoPickerViewModel()
@property (nonatomic, strong) NSMutableArray<JFPhotoPickerModel*>* models;
@property (nonatomic, assign) PHAssetMediaType mediaType;
@property (nonatomic, copy) JFFinishedBlock finishedBlock;
@property (nonatomic, copy) JFFinishedBlock originFinishedBlock;
@property (nonatomic, copy) JFFinishedBlock originFailedBlock;
@property (nonatomic, strong) PHImageManager* imageMan;
@end
@implementation JFPhotoPickerViewModel

/**
 获取照片|视频资源
 @param mediaType                           资源类型(PHAssetMediaType)
 @param finishedBlock                       回调:读取到相册中的图片|视频组<JFPhotoPickerModel*>
 */
- (void) jf_requestMediasForType:(PHAssetMediaType)mediaType onFinished:(JFFinishedBlock)finishedBlock {
    [self.models removeAllObjects];
    self.mediaType = mediaType;
    self.finishedBlock = finishedBlock;
    PHFetchOptions* options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    WeakSelf(wself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult* results = [PHAsset fetchAssetsWithMediaType:mediaType options:options];
        for (PHAsset* asset in results) {
            JFPhotoPickerModel* model = [JFPhotoPickerModel new];
            model.asset = asset;
            [wself.models addObject:model];
        }
        // 下载缩略图
//        [wself downloadAllThumbImages];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wself.finishedBlock) {
                wself.finishedBlock(wself.models);
            }
        });
    });
}

/**
 请求所有被选择的model的原始多媒体数据;
 @param finishedBlock                       回调: NSArray<JFPhotoPickerModel*>;imagePath|videoPath必须填充好
 @param failedBlock                         回调: 失败
 */
- (void) jf_requestAllSelectedMediasOnFinished:(JFFinishedBlock)finishedBlock orFailed:(JFFinishedBlock)failedBlock {
    self.originFinishedBlock = finishedBlock;
    self.originFailedBlock = failedBlock;
    WeakSelf(wself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wself downloadOriginMedias];
    });
}

/**
 获取指定位置的原始数据
 @param index                               指定位置
 @param finishedBlock                       回调: <JFPhotoPickerModel*>;imagePath|videoPath必须填充好
 @param failedBlock                         回调: 失败
 */
- (void) jf_requestOriginMediaAtIndex:(NSInteger)index onFinished:(JFFinishedBlock)finishedBlock orFailed:(JFFinishedBlock)failedBlock {
    JFPhotoPickerModel* model = [self.models objectAtIndex:index];
    if (model.originData) {
        if (finishedBlock) {
            finishedBlock(@[model]);
        }
        return;
    }
    WeakSelf(wself);
    if (model.asset.mediaType == PHAssetMediaTypeImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHImageRequestOptions* imageOp = [PHImageRequestOptions new];
            imageOp.networkAccessAllowed = YES;
            [wself.imageMan requestImageDataForAsset:model.asset
                                             options:imageOp
                                       resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                           NSString* path = [JFPhotoPickerViewModel mediaPathForModel:model];
                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               NSError* error = nil;
                                               BOOL suc = [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
                                               model.originData = path;
                                               if (finishedBlock) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       finishedBlock(@[model]);
                                                   });
                                               }
                                           });
                                       }];
        });
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHVideoRequestOptions* videoOp = [PHVideoRequestOptions new];
            videoOp.networkAccessAllowed = YES;
            videoOp.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            [wself.imageMan requestAVAssetForVideo:model.asset
                                           options:videoOp
                                     resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                         model.originData = asset;
                                         // 检查原始文件是否都下载完毕;如果下载完毕，就回调
                                         if (finishedBlock) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 finishedBlock(@[model]);
                                             });
                                         }
                                     }];
        });
    }
}


// 更新指定model的被选择状态;同时要更新其他model的状态和enable;
- (void) jf_exchangeModelSelectedState:(JFPhotoPickerModel*)model {
    if (!model || IsNon(self.models)) {
        return;
    }
    NSInteger index = [self.models indexOfObject:model];
    if (index == NSNotFound) {
        return;
    }
    // 当前已被选的个数
    NSInteger count = [self jf_numberOfSelectedModels];
    // 当前状态
    BOOL curSelectedState = model.isSelected;
    // 被选中
    if (curSelectedState) {
        // 去掉被选中
        model.isSelected = NO;
        count -= 1;
        // 更新其他选中的index
        for (JFPhotoPickerModel* imodel in self.models) {
            if (imodel.isSelected && imodel.selectedIndex > model.selectedIndex) {
                imodel.selectedIndex -= 1;
            }
        }
        // 重置当前的选中序号
        model.selectedIndex = NSNotFound;
    }
    // 未被选
    else {
        if (count < self.maxPickerCount) {
            // 设置为选中
            model.isSelected = YES;
            // 更新总个数
            count += 1;
            // 更新当前的选中序号
            model.selectedIndex = count;
        }
    }
    // 更新所有的enable
    for (JFPhotoPickerModel* imodel in self.models) {
        if (imodel.isSelected) {
            imodel.enableSelect = YES;
        } else {
            // 未超限就可以继续选择
            imodel.enableSelect = count < self.maxPickerCount;
        }
    }
}


# pragma mark - tools

// 下载缩略图
- (void) downloadAllThumbImages {
    WeakSelf(wself);
    for (JFPhotoPickerModel* model in self.models) {
        PHImageRequestOptions* op = [PHImageRequestOptions new];
        op.networkAccessAllowed = YES;
        /*
         PHImageRequestOptionsDeliveryModeOpportunistic:为了平衡图像质量和响应速度，Photos会提供一个或多个结果
         PHImageRequestOptionsDeliveryModeHighQualityFormat:只提供最高质量的图像，无论它需要多少时间加载
         PHImageRequestOptionsResizeModeFast:最快速的得到一个图像结果，可能会牺牲图像质量
         */
        op.resizeMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        // 获取缩略图:图片|视频的
        [self.imageMan requestImageForAsset:model.asset
                                 targetSize:model.thumbSize
                                contentMode:PHImageContentModeAspectFit
                                    options:op
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                                  model.thumbImage = result;
                                  // 检查缩略图|视频链接是否都下载完毕;如果下载完毕，就回调
                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                      [wself checkIfAllThumbImagesDownloaded];
                                  });
                              }];
    }
}

// 下载原始图
- (void) downloadOriginMedias {
    WeakSelf(wself);
    BOOL isAllVideosDownloaded = YES;
    for (JFPhotoPickerModel* model in self.models) {
        if (!model.isSelected) {
            continue;
        }
        // 有原始数据就跳过
        if (model.originData) {
            continue;
        }
        // 只要有一个图片|视频的原始数据没有，就要置状态为NO
        else {
            isAllVideosDownloaded = NO;
        }
        // 图片
        if (model.asset.mediaType == PHAssetMediaTypeImage) {
            PHImageRequestOptions* imageOp = [PHImageRequestOptions new];
            imageOp.networkAccessAllowed = YES;
            [self.imageMan requestImageDataForAsset:model.asset
                                            options:imageOp
                                      resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                          NSString* path = [JFPhotoPickerViewModel mediaPathForModel:model];
                                          NSError* error = nil;
                                          if (orientation == UIImageOrientationUp) {
                                              BOOL suc = [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
                                          } else {
                                              UIImage* image = [UIImage imageWithData:imageData];
                                              UIImage* normalImage = [image jf_normalizedImage];
                                              JFImageFormat format = [imageData jf_imageFormat];
                                              if (format == JFImageFormatPNG) {
                                                  NSData* data = UIImagePNGRepresentation(normalImage);
                                                  [data writeToFile:path options:NSDataWritingAtomic error:&error];
                                              }
                                              else {
                                                  NSData* data = UIImageJPEGRepresentation(normalImage, 0.99);
                                                  [data writeToFile:path options:NSDataWritingAtomic error:&error];
                                              }
                                          }
                                          model.originData = path;
                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                              // 检查原始文件是否都下载完毕;如果下载完毕，就回调
                                              [wself checkIfAllOriginalMediasDownloaded];
                                          });
                                      }];
        }
        // 视频
        else if (model.asset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions* videoOp = [PHVideoRequestOptions new];
            videoOp.networkAccessAllowed = YES;
            videoOp.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            [self.imageMan requestAVAssetForVideo:model.asset
                                          options:videoOp
                                    resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                        model.originData = asset;
                                        // 检查原始文件是否都下载完毕;如果下载完毕，就回调
                                        [wself checkIfAllOriginalMediasDownloaded];
                                    }];
        }
    }
    // 如果视频都下载了，则去检查并执行后面的流程
    if (isAllVideosDownloaded) {
        // 检查原始文件是否都下载完毕;如果下载完毕，就回调
        [self checkIfAllOriginalMediasDownloaded];
    }
}

// 检查缩略图是否都下载完毕;如果下载完毕，就回调
- (void) checkIfAllThumbImagesDownloaded {
    BOOL allRequested = YES;
    for (JFPhotoPickerModel* model in self.models) {
//        if (!model.thumbImage) {
//            allRequested = NO;
//            break;
//        }
    }
    if (allRequested) {
        WeakSelf(wself);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wself.finishedBlock) {
                wself.finishedBlock(wself.models);
            }
        });
    }
}

// 检查原始文件是否都下载完毕;如果下载完毕，就回调
- (void) checkIfAllOriginalMediasDownloaded {
    BOOL allRequested = YES;
    NSMutableArray* list = @[].mutableCopy;
    for (JFPhotoPickerModel* model in self.models) {
        if (model.isSelected) {
            if (IsNon(model.originData)) {
                allRequested = NO;
                break;
            } else {
                [list addObject:model];
            }
        }
    }
    if (allRequested) {
        // 排序
        [list sortUsingComparator:^NSComparisonResult(JFPhotoPickerModel*  _Nonnull obj1, JFPhotoPickerModel*  _Nonnull obj2) {
            return obj1.selectedIndex <= obj2.selectedIndex ? NSOrderedAscending : NSOrderedDescending;
        }];
        WeakSelf(wself);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wself.originFinishedBlock) {
                wself.originFinishedBlock(list);
            }
        });
    }
}


/**
 视频缓存目录
 @return 全路径
 */
+ (NSString*) videoSavingDirectory {
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString* mediaDirectory = [documentPath stringByAppendingPathComponent:@"JFMediaDir"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mediaDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mediaDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return mediaDirectory;
}


// 生成模型的多媒体文件保存路径
+ (NSString*) mediaPathForModel:(JFPhotoPickerModel*)model {
    NSString* dir = [self videoSavingDirectory];
    if (model.asset.mediaType == PHAssetMediaTypeImage) {
        NSRange range = [model.asset.localIdentifier rangeOfString:@"/"];
        NSString* name = [[model.asset.localIdentifier substringToIndex:range.location] stringByAppendingString:@".jpg"];
        return [dir stringByAppendingPathComponent:name];
    }
    else if (model.asset.mediaType == PHAssetMediaTypeImage) {
        NSRange range = [model.asset.localIdentifier rangeOfString:@"/"];
        NSString* name = [[model.asset.localIdentifier substringToIndex:range.location] stringByAppendingString:@".mov"];
        return [dir stringByAppendingPathComponent:name];
    }
    return nil;
}






# pragma mark - data source
- (NSInteger) jf_numberOfSections {
    return 1;
}
- (NSInteger) jf_numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}
- (JFPhotoPickerModel*) jf_modelForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (IsNon(self.models) || indexPath.row >= self.models.count) {
        return nil;
    }
    return self.models[indexPath.row];
}
// 已被选中的model的个数
- (NSInteger) jf_numberOfSelectedModels {
    NSInteger count = 0;
    for (JFPhotoPickerModel* model in self.models) {
        if (model.isSelected) {
            count += 1;
        }
    }
    return count;
}


# pragma mark - getter
- (NSMutableArray *)models {
    if (!_models) {
        _models = @[].mutableCopy;
    }
    return _models;
}
- (PHImageManager *)imageMan {
    if (!_imageMan) {
        _imageMan = [PHImageManager defaultManager];
    }
    return _imageMan;
}
@end

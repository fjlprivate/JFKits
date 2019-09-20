//
//  AVAsset+JFExtension.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/22.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAsset (JFExtension)


/**
 拷贝
 @param time                指定的缩略图时间点
 @param thumbnailSize       指定的缩略图的尺寸
 @param finishedBlock       回调:拷贝的缩略图
 @param failedBlock         回调:失败
 */
- (void) jf_copyThumbnailAtTime:(NSTimeInterval)time
                  thumbnailSize:(CGSize)thumbnailSize
                     onFinished:(void (^) (UIImage* thumbnail))finishedBlock
                       orFailed:(void (^) (NSError* error))failedBlock;



@end

NS_ASSUME_NONNULL_END

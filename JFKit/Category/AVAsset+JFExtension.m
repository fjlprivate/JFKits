//
//  AVAsset+JFExtension.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/22.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "AVAsset+JFExtension.h"
#import <UIKit/UIKit.h>

static int32_t const kJFTimeScale = 600; // CMTime的timeScal,1秒的600分之一

@implementation AVAsset (JFExtension)

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
                       orFailed:(void (^) (NSError* error))failedBlock
{
    if (!self) {
        if (failedBlock) {
            failedBlock([NSError errorWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@"视频为空!"}]);
        }
        return;
    }
    AVAssetImageGenerator* imageGen = [AVAssetImageGenerator assetImageGeneratorWithAsset:self];
    imageGen.appliesPreferredTrackTransform = YES;
    imageGen.maximumSize = thumbnailSize;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        CGImageRef imageRef = [imageGen copyCGImageAtTime:CMTimeMake(time * kJFTimeScale, kJFTimeScale) actualTime:nil error:&error];
        if (error) {
            if (failedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedBlock(error);
                });
            }
        }
        else if (!imageRef) {
            if (failedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedBlock([NSError errorWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@"获取缩略图失败!"}]);
                });
            }
        }
        else {
            
            UIImage* newImage = [UIImage imageWithCGImage:imageRef];
            CFRelease(imageRef);
            if (finishedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(newImage);
                });
            }
        }
    });
}

@end

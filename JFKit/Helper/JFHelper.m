//
//  JFHelper.m
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFHelper.h"
#import <Photos/Photos.h>
#import "SDWebImage.h"

@implementation JFHelper

/**
 获取APP的启动图片;
 @return 启动图片;
 */
+ (UIImage*) getLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString* orientation = nil;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        orientation = @"Portrait";
    } else {
        orientation = @"Landscape";
    }
    NSString* launchImage = nil;
    NSArray* imagesDic = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dic in imagesDic) {
        CGSize imageSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(viewSize, imageSize) && [orientation isEqualToString:dic[@"UILaunchImageOrientation"]]) {
            launchImage = dic[@"UILaunchImageName"];
            break;
        }
    }
    return JFImageNamed(launchImage);
}

/**
 保存图片到相册;
 @param image UIImage|NSURL
 @param finishedBlock 回调: error == nil时:成功； 否则失败
 */
+ (void) saveImageToPhotoLibrary:(id)image onFinished:(void (^) (NSError* error))finishedBlock
{
    if (image == nil) {
        if (finishedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedBlock([NSError errorWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@"要保存的图片为空"}]);
            });
        }
        return;
    }
    
    // 保存图片的具体操作
    void (^ savingImage) (id image) = ^ (id image) {
        // 保存
        void (^ saving) (UIImage* iImage) = ^ (UIImage* iImage) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest* request = [PHAssetChangeRequest creationRequestForAssetFromImage:iImage];
                NSLog(@"&&正在保存图片:%@", request.placeholderForCreatedAsset.localIdentifier);
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"-----保存完毕");
                    if (finishedBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            finishedBlock(nil);
                        });
                    }
                }
                else {
                    if (finishedBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            finishedBlock([NSError errorWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@"保存失败"}]);
                        });
                    }
                }
            }];
        };
        // 网络图片:下载
        if ([image isKindOfClass:[NSURL class]]) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:image completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (finished) {
                    // 最终的保存
                    saving(image);
                }
                else if (error) {
                    if (finishedBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            finishedBlock([NSError errorWithDomain:@"" code:99 userInfo:@{NSLocalizedDescriptionKey:@"下载图片失败"}]);
                        });
                    }
                }
            }];
        }
        // 图片直接保存
        else {
            // 最终的保存
            saving(image);
        }
    };
    
    // 检查相册-写权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    // 被拒绝: 弹窗提示去打开设置
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"不能保存图片到相册" message:[NSString stringWithFormat:@"请打开'设置'-'%@'-'相册'开关", JFAppName()] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction* sure = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转系统设置
            NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                if (@available(iOS 10, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            };
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [JFCurrentViewController() presentViewController:alert animated:YES completion:nil];
    }
    // 未设置的: 请求权限
    else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 允许的才进行保存
            if (status == PHAuthorizationStatusAuthorized) {
                savingImage(image);
            }
        }];
    }
    // 允许的
    else {
        savingImage(image);
    }
}

@end

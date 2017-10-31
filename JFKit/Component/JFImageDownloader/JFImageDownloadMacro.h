//
//  JFImageDownloadMacro.h
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/13.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#ifndef JFImageDownloadMacro_h
#define JFImageDownloadMacro_h

@class UIImage;

// block定义: 失败
typedef void (^ JFBlockDownloadError) (NSError* error);
// block定义: 进度
typedef void (^ JFBlockDownloadProgress) (NSInteger received, NSInteger totalSize);
// block定义: 完成
typedef void (^ JFBlockDownloadCompletion) (UIImage* image, NSData* imageData);
// block定义: 无参
typedef void (^ JFBlockNonParams) (void);


/**
 下载状态
 */
typedef NS_ENUM(NSInteger, JFImageDownloadState) {
    JFImageDownloadStateWaiting,        // 等待下载
    JFImageDownloadStateExecuting,      // 正在下载
    JFImageDownloadStateDone,           // 下载完毕
    JFImageDownloadStateCanceled,       // 取消下载
    JFImageDownloadStateFailed          // 下载失败
};


#endif /* JFImageDownloadMacro_h */

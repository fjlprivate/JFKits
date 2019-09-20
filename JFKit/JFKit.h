//
//  JFKit.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>


//! Project version number for JFKit.
FOUNDATION_EXPORT double JFKitVersionNumber;

//! Project version string for JFKit.
FOUNDATION_EXPORT const unsigned char JFKitVersionString[];


/*
 * 外部只需要包含这个头文件就可以了；如果要用到具体的小功能，再去包含指定的小头文件;
 */


#pragma mark - Macro:宏定义
#import "JFMacro.h"
#import "JFConstant.h"

#pragma mark - Helper:辅助功能集
#import "JFHelper.h"

#pragma mark - Category:分类
#import "NSData+ImageFormat.h"
#import "NSMutableAttributedString+Extension.h"
#import "NSString+Extension.h"
#import "NSString+JFRegex.h"
#import "NSString+JFFormat.h"
#import "UIButton+JFExtension.h"
#import "UIImage+JFExtension.h"
#import "UIImage+Extension.h"
#import "UIImage+Format.h"
#import "UIView+Extension.h"
#import "CALayer+JFExtension.h"
#import "NSError+Extension.h"
#import "UIImageView+JFExtention.h"
#import "UIViewController+JFExtension.h"
#import "AVAsset+JFExtension.h"
#import "NSDate+JFExtension.h"


#pragma mark - UIKit:控件集
// 异步图文混排
#import "JFAsyncDisplayKit.h"

// banner
#import "JFBanner.h"


#import "JFButton.h"
#import "JFCycleImageView.h"
#import "JFPageView.h"
// 视频采集视图
#import "JFVideoCapture.h"
// 视频播放控件
#import "JFVideoDisplay.h"
// 图片浏览器
#import "JFImageBrowserViewController.h"
// 图片|视频采集器
#import "JFPhotoPickerViewController.h"

#pragma mark - Component:组件集
#import "JFAsyncFlag.h"
#import "JFImageDownloadManager.h"





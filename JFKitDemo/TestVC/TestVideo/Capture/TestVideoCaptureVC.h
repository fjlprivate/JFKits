//
//  TestVideoCaptureVC.h
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/25.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestVideoCaptureVC : BaseViewController

// 视频或图片的回调，只会回调一个
@property (nonatomic, copy) void (^ callBackCapturedVideo) (NSURL* videoUrl, UIImage* thumbnail);
@property (nonatomic, copy) void (^ callBackCapturedImage) (UIImage* image);

@end

NS_ASSUME_NONNULL_END

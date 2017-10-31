//
//  UIImage+Format.h
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+ImageFormat.h"

@interface UIImage (Format)


/**
 对image转化为data
 @param imageFormat image类型
 @return NSData;
 */
- (NSData*) jf_imageDataAsFormat:(JFImageFormat)imageFormat;


@end

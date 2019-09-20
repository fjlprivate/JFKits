//
//  NSData+ImageFormat.h
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JFImageFormat) {
    JFImageFormatPNG,
    JFImageFormatJPG,
    JFImageFormatGIF,
    JFImageFormatTIFF,
    JFImageFormatUndefined
};

@interface NSData (ImageFormat)

- (JFImageFormat) jf_imageFormat;

- (UIImage*) jf_makeImage;

@end

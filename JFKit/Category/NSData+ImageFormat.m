//
//  NSData+ImageFormat.m
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "NSData+ImageFormat.h"

@implementation NSData (ImageFormat)

- (JFImageFormat)jf_imageFormat {
    if (self.length < 1) {
        return JFImageFormatUndefined;
    }
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xff:
            return JFImageFormatJPG;
            break;
        case 0x89:
            return JFImageFormatPNG;
            break;
        case 0x47:
            return JFImageFormatGIF;
            break;
        case 0x4d:
            return JFImageFormatTIFF;
            break;
        default:
            return JFImageFormatUndefined;
            break;
    }
}


- (UIImage*) jf_makeImage {
    JFImageFormat format = [self jf_imageFormat];
    UIImage* image = nil;
    if (format == JFImageFormatGIF) {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self, NULL);
        size_t count = CGImageSourceGetCount(source);
        if (count <= 1) {
            image = [UIImage imageWithData:self];
        } else {
            // gif图片只取第一张
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, NULL);
            UIImage* oneImage = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
            image = [UIImage animatedImageWithImages:@[oneImage] duration:0];
            CGImageRelease(cgImage);
            // gif图片取n张
//            NSMutableArray* images = @[].mutableCopy;
//            for (int i = 0; i < count; i++) {
//                CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
//                [images addObject:[UIImage imageWithCGImage:cgImage]];
//                CGImageRelease(cgImage);
//            }
//            image = [UIImage animatedImageWithImages:images duration:count * 0.05];
        }
        CFRelease(source);
    } else {
        image = [UIImage imageWithData:self];
    }
    return image;
}


@end

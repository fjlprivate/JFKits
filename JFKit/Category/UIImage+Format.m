//
//  UIImage+Format.m
//  TestForOperation
//
//  Created by JohnnyFeng on 2017/10/17.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import "UIImage+Format.h"

@implementation UIImage (Format)

- (NSData*) jf_imageDataAsFormat:(JFImageFormat)imageFormat {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                   alphaInfo == kCGImageAlphaNoneSkipFirst ||
                   alphaInfo == kCGImageAlphaNoneSkipLast);
    BOOL isPNG = hasAlpha;
    if (imageFormat != JFImageFormatUndefined) {
        isPNG = (imageFormat == JFImageFormatPNG);
    }
    if (isPNG) {
        return UIImagePNGRepresentation(self);
    } else {
        return UIImageJPEGRepresentation(self, 1.0);
    }
}

@end

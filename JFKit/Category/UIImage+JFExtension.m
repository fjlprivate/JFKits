//
//  UIImage+JFExtension.m
//  RuralMeet
//
//  Created by LiChong on 2018/1/23.
//  Copyright © 2018年 occ. All rights reserved.
//

#import "UIImage+JFExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>
#import "NSBundle+JFExtension.h"

@implementation UIImage (JFExtension)

+ (instancetype) jf_imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0, 0, 0.5, 0.5);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (instancetype) jf_imageWithColor:(UIColor*)color inSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// 从video取指定时间的帧图片
+ (instancetype) jf_thumbnailImageForVideoURL:(NSURL*)videoURL atTime:(NSTimeInterval)time {
    if (!videoURL) {
        return nil;
    }
    AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator* assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError* error = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                                                    actualTime:NULL
                                                         error:&error];
    if (!thumbnailImageRef) {
        NSLog(@"thumbnailImageGenerationError %@",error);
        return nil;
    } else {
        UIImage* image = [UIImage imageWithCGImage:thumbnailImageRef];
        CFRelease(thumbnailImageRef);
        return image;
    }
}
+ (void) jf_thumbnailImageForVideoURL:(NSURL*)videoURL atTime:(NSTimeInterval)time onFinished:(void (^)(UIImage* image))finishedBlock {
    if (!videoURL) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator* assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError* error = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                                                        actualTime:NULL
                                                             error:&error];
        if (!thumbnailImageRef) {
            NSLog(@"thumbnailImageGenerationError %@",error);
            if (finishedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(nil);
                });
            }
            return ;
        } else {
            UIImage* image = [UIImage imageWithCGImage:thumbnailImageRef];
            CFRelease(thumbnailImageRef);
            if (finishedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(image);
                });
            }
        }
    });
}


// 高斯模糊
- (UIImage*) jf_blurImage:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

// 读取二维码信息
- (NSString*) jf_readQRCode {
    CIImage* ciImage = [[CIImage alloc] initWithCGImage:self.CGImage];
    // 软件渲染
    CIContext* ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}];
    // 二维码识别
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray* features = [detector featuresInImage:ciImage];
    if (features && features.count > 0) {
        for (CIQRCodeFeature* feature in features) {
            if (feature.messageString && feature.messageString.length > 0) {
                return feature.messageString;
            }
        }
    }
    return nil;
}

// 更正图片的方向
- (UIImage*) jf_normalizedImage {
    if (!self) {
        return nil;
    }
//    if (self.imageOrientation == UIImageOrientationUp) {
//        return self;
//    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    // drawInRect:系统会自动修正图片的方向
    [self drawInRect:(CGRect){0, 0 , self.size}];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 绘制文字到图片上面;
 @param text            富文本
 @param rect            要绘制的区域
 @return                绘制了文字的图片;
 */
- (UIImage*) jf_drawText:(NSAttributedString*)text inRect:(CGRect)rect newImageSize:(CGSize)newImageSize {
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return self;
    }
    if (CGSizeEqualToSize(newImageSize, CGSizeZero)) {
        return self;
    }
    if (!text || text.length == 0) {
        return self;
    }
    if (!self) {
        return self;
    }
    if (self.size.width < 0.1 || self.size.height < 0.1) {
        return self;
    }
    UIFont* textFont = [text attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    UIColor* textColor = [text attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    UIColor* textBackgroundColor = [text attribute:JFTextBackgroundColorAttributeKey atIndex:0 effectiveRange:NULL];
    if (!textFont) {
        textFont = [UIFont systemFontOfSize:15];
    }
    if (!textColor) {
        textColor = [UIColor whiteColor];
    }
    // 创建图片上下文
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0);
    // 绘制图片
    [self drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    if (textBackgroundColor) {
        CGContextSetFillColorWithColor(context, textBackgroundColor.CGColor);
        CGContextFillRect(context, rect);
    }
    [text drawInRect:rect];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 从JFKit.bundle取图片;如果取不到，再到工程去取
 @param name 图片名称
 @return UIImage
 */
+ (UIImage*) jf_kitImageWithName:(NSString*)name {
    if (name.length == 0) {
        return nil;
    }
    NSBundle* bundle = [NSBundle jf_kitBundle];
    NSString* path = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

@end

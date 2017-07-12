/*
 https://github.com/waynezxcv/Gallop
 
 Copyright (c) 2016 waynezxcv <liuweiself@126.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */





#import "LWAsyncImageView+WebCache.h"
#import "LWAsyncImageView+WebCacheOperation.h"
#import "NSData+ImageContentType.h"
#import <objc/runtime.h>
#import "LWGIFImage.h"
#import "LWImageProcessor.h"



static char imageURLKey;
static char blurURLKey;

#define LWAsyncImageVeiewLoadKey @"LWAsyncImageVeiewLoadKey"
#define LWAsyncBlurImageVeiewLoadKey @"LWAsyncBlurImageVeiewLoadKey"

@implementation LWAsyncImageView (WebCache)

- (void)lw_asyncSetImageWithURL:(NSURL *)url
               placeholderImage:(id)placeholder
                   cornerRadius:(CGFloat)cornerRadius
          cornerBackgroundColor:(UIColor *)cornerBackgroundColor
                    borderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                           size:(CGSize)size
                    contentMode:(UIViewContentMode)contentMode
                         isBlur:(BOOL)isBlur
                        options:(SDWebImageOptions)options
                       progress:(LWWebImageDownloaderProgressBlock)progressBlock
                      completed:(LWWebImageDownloaderCompletionBlock)completedBlock {
    
    //如果当前LWAsyncImageView上还有其他下载任务，取消掉
    [self lw_cancelCurrentImageLoad];
    
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //设置本地占位图
    if (!(options & SDWebImageDelayPlaceholder) && [placeholder isKindOfClass:[UIImage class]]) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    
    //    //设置了略缩模糊占位图
    //    if ([placeholder isKindOfClass:[NSURL class]]) {
    //
    //        objc_setAssociatedObject(self, &blurURLKey, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //
    //        __weak typeof(self) weakSelf = self;
    //        UIImage* cachedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:url.absoluteString];
    //        if (!cachedImage) {//缓存不存在,下载占位图，并模糊处理
    //            NSOperation* operation = [[SDWebImageManager sharedManager]
    //                                      lw_downloadImageWithURL:placeholder
    //                                      cornerRadius:cornerRadius
    //                                      cornerBackgroundColor:cornerBackgroundColor
    //                                      borderColor:borderColor
    //                                      borderWidth:borderWidth
    //                                      size:size
    //                                      contentMode:contentMode
    //                                      isBlur:NO
    //                                      options:0
    //                                      progress:nil
    //                                      completed:^(UIImage * _Nullable image,
    //                                                  NSData * _Nullable data,
    //                                                  NSError * _Nullable error,
    //                                                  SDImageCacheType cacheType,
    //                                                  BOOL finished,
    //                                                  NSURL * _Nullable imageURL) {
    //
    //                                          dispatch_main_async_safe(^{
    //                                              //赋值缩略模糊占位图
    //                                              [weakSelf synchronouslySetImage:image];
    //
    //
    //                                              //下载原图
    //                                              [weakSelf _asyncDownloadImageWithURL:url
    //                                                                  placeholderImage:image
    //                                                                      cornerRadius:cornerRadius
    //                                                             cornerBackgroundColor:cornerBackgroundColor
    //                                                                       borderColor:borderColor
    //                                                                       borderWidth:borderWidth
    //                                                                              size:size
    //                                                                       contentMode:contentMode
    //                                                                            isBlur:isBlur
    //                                                                           options:options
    //                                                                          progress:progressBlock
    //                                                                         completed:completedBlock];
    //                                          });
    //                                      }];
    //
    //
    //            [self lw_setImageLoadOperation:operation forKey:LWAsyncBlurImageVeiewLoadKey];
    //
    //        } else {//缓存已经存在了，不需要再加载placeHolder
    [self _asyncDownloadImageWithURL:url
                    placeholderImage:nil
                        cornerRadius:cornerRadius
               cornerBackgroundColor:cornerBackgroundColor
                         borderColor:borderColor
                         borderWidth:borderWidth
                                size:size
                         contentMode:contentMode
                              isBlur:isBlur
                             options:options
                            progress:progressBlock
                           completed:completedBlock];
    //        }
    //
    //    } else {//没有设置略缩模糊占位图,直接加载原图
    //
    //        [self _asyncDownloadImageWithURL:url
    //                        placeholderImage:(UIImage *)placeholder
    //                            cornerRadius:cornerRadius
    //                   cornerBackgroundColor:cornerBackgroundColor
    //                             borderColor:borderColor
    //                             borderWidth:borderWidth
    //                                    size:size
    //                             contentMode:contentMode
    //                                  isBlur:isBlur
    //                                 options:options
    //                                progress:progressBlock
    //                               completed:completedBlock];
    //
    //    }
}

- (void)_asyncDownloadImageWithURL:(NSURL *)url
                  placeholderImage:(UIImage *)placeholder
                      cornerRadius:(CGFloat)cornerRadius
             cornerBackgroundColor:(UIColor *)cornerBackgroundColor
                       borderColor:(UIColor *)borderColor
                       borderWidth:(CGFloat)borderWidth
                              size:(CGSize)size
                       contentMode:(UIViewContentMode)contentMode
                            isBlur:(BOOL)isBlur
                           options:(SDWebImageOptions)options
                          progress:(LWWebImageDownloaderProgressBlock)progressBlock
                         completed:(LWWebImageDownloaderCompletionBlock)completedBlock {
    if (url) {
        __weak typeof(self) weakSelf = self;
        id <SDWebImageOperation> operation = [[SDWebImageManager sharedManager]
                                              lw_downloadImageWithURL:url
                                              cornerRadius:cornerRadius
                                              cornerBackgroundColor:cornerBackgroundColor
                                              borderColor:borderColor
                                              borderWidth:borderWidth
                                              size:size
                                              contentMode:contentMode
                                              isBlur:isBlur
                                              options:options
                                              progress:progressBlock
                                              completed:^(UIImage * _Nullable image,
                                                          NSData * _Nullable data,
                                                          NSError * _Nullable error,
                                                          SDImageCacheType cacheType,
                                                          BOOL finished,
                                                          NSURL * _Nullable imageURL) {
                                                  
                                                  __strong typeof(weakSelf) sself = weakSelf;
                                                  if (!sself || !image) {
                                                      completedBlock(image,data,error);
                                                      return;
                                                  }
                                                  dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                      SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
                                                      if (imageFormat == SDImageFormatGIF) {
                                                          
                                                          //GIF
                                                          LWGIFImage* gif = [[LWGIFImage alloc] initWithGIFData:data];
                                                          dispatch_main_async_safe(^{
                                                              if (gif && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                                                                  completedBlock(gif,data,error);
                                                                  return;
                                                                  
                                                              } else if (gif) {
                                                                  sself.image = nil;
                                                                  sself.gifImage = gif;
                                                                  [sself setNeedsLayout];
                                                                  
                                                              } else {
                                                                  
                                                                  if ((options & SDWebImageDelayPlaceholder)) {
                                                                      sself.gifImage = nil;
                                                                      sself.image = placeholder;
                                                                      [sself setNeedsLayout];
                                                                  }
                                                              }
                                                              
                                                              if (completedBlock && finished) {
                                                                  completedBlock(gif,data,error);
                                                              }
                                                          });
                                                          
                                                      } else {
                                                          
                                                          //普通图片
                                                          dispatch_main_async_safe(^{
                                                              
                                                              if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                                                                  completedBlock(image,data,error);
                                                                  return ;
                                                                  
                                                              } else if (image) {
                                                                  sself.gifImage = nil;
                                                                  sself.image = image;
                                                                  [sself setNeedsLayout];
                                                                  
                                                              } else {
                                                                  
                                                                  if ((options & SDWebImageDelayPlaceholder)) {
                                                                      sself.gifImage = nil;
                                                                      sself.image = placeholder;
                                                                      [sself setNeedsLayout];
                                                                      
                                                                  }
                                                              }
                                                              
                                                              if (completedBlock && finished) {
                                                                  completedBlock(image,data,error);
                                                              }
                                                          });
                                                      }
                                                  });
                                              }];
        
        //把operation设置到LWAsyncImageView的关联对象operationDictionary上，用于取消操作
        [self lw_setImageLoadOperation:operation forKey:LWAsyncImageVeiewLoadKey];
        
    } else {
        dispatch_main_async_safe(^{
            NSError* error = [NSError errorWithDomain:SDWebImageErrorDomain
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil,nil,error);
            }
        });
    }
    
}




- (NSURL *)lw_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}


- (NSURL *)lw_blurImageURL {
    return objc_getAssociatedObject(self, &blurURLKey);
}

- (void)lw_cancelCurrentImageLoad {
    [self lw_cancelImageLoadOperationWithKey:LWAsyncImageVeiewLoadKey];
    [self lw_cancelImageLoadOperationWithKey:LWAsyncBlurImageVeiewLoadKey];
}



@end

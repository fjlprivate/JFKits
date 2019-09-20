//
//  JFAsyncDisplayKit.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/15.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#ifndef JFAsyncDisplayKit_h
#define JFAsyncDisplayKit_h

/*------ View ------*/
#import "JFAsyncView.h"
#import "JFLabel.h" /////-----
/*------ Model ------*/
//#import "JFAsyncViewLayouts.h"
#import "JFTextLayout.h" ////////
#import "JFImageLayout.h" ///////
#import "JFTextAttachment.h"


/*------ 图片附件RunDelegate回调 ------*/

// 静态函数: 获取图片附件的上部
static CGFloat JFImageRunGetAscent (void* config) {
    JFTextAttachmentImage* imageAttachment = (__bridge JFTextAttachmentImage*)config;
    return imageAttachment.imageSize.height * 0.77;
}
// 静态函数: 获取图片附件的下部
static CGFloat JFImageRunGetDescent (void* config) {
    JFTextAttachmentImage* imageAttachment = (__bridge JFTextAttachmentImage*)config;
    return imageAttachment.imageSize.height * (1 - 0.77);
}
// 静态函数: 获取图片附件的宽度
static CGFloat JFImageRunGetWidth (void* config) {
    JFTextAttachmentImage* imageAttachment = (__bridge JFTextAttachmentImage*)config;
    return imageAttachment.imageSize.width + imageAttachment.kern;
}


#endif /* JFAsyncDisplayKit_h */

//
//  JFTextRun.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/11.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "JFConstant.h"

@class JFTextAttachmentImage;
@class JFTextAttachmentHighlight;

@interface JFTextRun : NSObject

+ (instancetype) textRunWithCTRun:(CTRunRef)ctRun
                     ctLineOrigin:(CGPoint)ctLineOrigin
                            frame:(CGRect)frame
                        cancelled:(IsCancelled)cancelled;

// 行间距
@property (nonatomic, assign, readonly) CGFloat leading;
// 附件组:图片
@property (nonatomic, copy) NSArray<JFTextAttachmentImage*>* imageAttachments;
// 附件组:高亮
@property (nonatomic, copy) NSArray<JFTextAttachmentHighlight*>* highlightAttachments;

@end

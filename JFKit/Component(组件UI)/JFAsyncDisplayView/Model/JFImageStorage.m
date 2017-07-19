//
//  JFImageStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFImageStorage.h"

@implementation JFImageStorage

# pragma mask 1 

/**
 绘制图片到图形上下文;
 只有当contents是UIImage类型时才允许绘制;
 
 @param context 图形上下文;
 @param canceled 是否取消绘制的校验方法;
 */
- (void) drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled {
    if (![self.contents isKindOfClass:[UIImage class]]) {
        return;
    }
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return;
    }
    
    CGContextSaveGState(context);
    
    UIImage* image = self.contents;
    [image drawInRect:self.frame];
    
    CGContextRestoreGState(context);
}



# pragma mask 3 life cycle


+ (instancetype)jf_imageStroageWithContents:(id)contents frame:(CGRect)frame {
    if (!contents) {
        return nil;
    }
    JFImageStorage* imageStorage = [[JFImageStorage alloc] initWithContents:contents frame:frame];
    return imageStorage;
}

- (instancetype) initWithContents:(id)contents frame:(CGRect)frame {
    self = [super initWithFrame:frame insets:UIEdgeInsetsZero];
    if (self) {
        self.contents = contents;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}




@end

//
//  JFTextAttachment.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/10.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "JFTextAttachment.h"

@implementation JFTextAttachmentImage
@end

@implementation JFTextAttachmentHighlight

# pragma mark - getter

- (NSMutableArray *)uiFrames {
    if (!_uiFrames) {
        _uiFrames = @[].mutableCopy;
    }
    return _uiFrames;
}

@end



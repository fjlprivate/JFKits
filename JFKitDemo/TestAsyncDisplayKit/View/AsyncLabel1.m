//
//  AsyncLabel1.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/12.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "AsyncLabel1.h"
#import "JFAsyncFlag.h"
#import "JFTextLayout.h"

@interface AsyncLabel1()
@property (nonatomic, strong) JFAsyncFlag* asyncFlag;
@end

@implementation AsyncLabel1

- (void)setTextLayout:(JFTextLayout *)textLayout {
    _textLayout = textLayout;
    self.frame = CGRectMake(textLayout.viewOrigin.x, textLayout.viewOrigin.y, textLayout.suggustSize.width, textLayout.suggustSize.height);
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self.asyncFlag incrementFlag];
    int curFlag = self.asyncFlag.curFlag;
    __weak JFAsyncFlag* weakFlag = self.asyncFlag;
    IsCancelled cancelled = ^ BOOL {
        return curFlag != weakFlag.curFlag;
    };
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.textLayout drawInContext:context cancelled:cancelled];
}

- (JFAsyncFlag *)asyncFlag {
    if (!_asyncFlag) {
        _asyncFlag = [JFAsyncFlag new];
    }
    return _asyncFlag;
}

@end

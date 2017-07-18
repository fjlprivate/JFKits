//
//  JFTextLayout.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMacro.h"

@interface JFTextLayout : NSObject

@property (nonatomic, assign, readonly) CGRect suggestFrame; // 建议文本frame

@property (nonatomic, strong) UIColor* backgroundColor; // 整个frame的背景色

@property (nonatomic, assign) BOOL debugMode; // 是否开启调试模式


/**
 文本布局生成器;

 @param attributedString 富文本; 包含文本属性、附件、高亮等属性;
 @param textFrame 文本绘制区域;
 @param linesCount 文本行数;如果小于文本实际行数，则截取;
 @param insets 内嵌距离;
 @return 文本布局对象;
 */
+ (instancetype) jf_textLayoutWithAttributedString:(NSAttributedString*)attributedString
                                             frame:(CGRect)textFrame
                                        linesCount:(NSInteger)linesCount
                                            insets:(UIEdgeInsets)insets;



/**
 绘制文本和各附件属性到指定的上下文;

 @param context 文本上下文;
 @param canceled 是否退出的block;
 */
- (void) drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled;

@end

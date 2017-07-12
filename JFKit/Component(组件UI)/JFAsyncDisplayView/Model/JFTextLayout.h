//
//  JFTextLayout.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTextLayout : NSObject

@property (nonatomic, assign, readonly) CGRect suggestFrame; // 建议文本frame


/**
 文本布局生成器;

 @param attributedString 富文本; 包含文本属性、附件、高亮等属性;
 @param textFrame 文本绘制区域;
 @param numberOfLines 文本行数;如果小于文本实际行数，则截取;
 @return 文本布局对象;
 */
+ (instancetype) jf_textLayoutWithAttributedString:(NSAttributedString*)attributedString
                                             frame:(CGRect)textFrame
                                     numberOfLines:(NSInteger)numberOfLines;



/**
 绘制文本到指定的上下文;

 @param context 文本上下文;
 */
- (void) drawTextInContext:(CGContextRef)context;

@end

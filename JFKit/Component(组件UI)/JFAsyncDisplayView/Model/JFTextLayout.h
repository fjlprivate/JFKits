//
//  JFTextLayout.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMacro.h"

@class JFTextHighLight;

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
 判断是否点击了高亮区;
 逐个比较当前缓存中的所有高亮区;
 
 @param position 点击坐标
 @return 存在任意一个高亮区，则返回YES;否则返回NO;
 */
- (BOOL) didClickedHighLightPosition:(CGPoint)position;



/**
 获取指定坐标点的高亮属性;

 @param position 指定坐标点<UIKit坐标系>;
 @return 返回符合条件的高亮属性;没有则返回nil;
 */
- (JFTextHighLight*) highLightAtPosition:(CGPoint)position;


/**
 更新高亮区的显示开关;
 在执行这个方法前，最好先执行上面的判断;
 
 @param switchOn 高亮开关;
 @param position 高亮区所在的坐标;
 */
- (void) turnningHightLightSwitch:(BOOL)switchOn atPosition:(CGPoint)position;



/**
 绘制文本和各附件属性到指定的上下文;

 @param context 文本上下文;
 @param canceled 是否退出的block;
 */
- (void) drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled;

@end

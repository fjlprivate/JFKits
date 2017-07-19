//
//  JFTextStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "JFTextStorage.h"
#import "JFTextLayout.h"
#import "NSMutableAttributedString+Extension.h"

@interface JFTextStorage()

@property (nonatomic, strong) JFTextLayout* textLayout; // 缓存文本布局属性
@property (nonatomic, strong) NSMutableAttributedString* attributedString; // 富文本
@property (nonatomic, strong) NSMutableParagraphStyle* paragraphStyle; // 段落属性

@end

@implementation JFTextStorage

# pragma mask 1


/**
 生成textStorage
 
 @param text 文本
 @param frame 文本frame
 @param insets 横竖方向的内嵌距离
 @return textStorage
 
 */
+ (instancetype) jf_textStorageWithText:(NSString*)text frame:(CGRect)frame insets:(UIEdgeInsets)insets {
    if (!text || text.length == 0) {
        return nil;
    }
    JFTextStorage* textStorage = [[JFTextStorage alloc] initWithText:text frame:frame insets:insets];
    return textStorage;
}


- (void) setTextFont:(UIFont *)textFont atRange:(NSRange)range {
    [self.attributedString setAttribute:NSFontAttributeName withValue:textFont atRange:range];
    [self renewTextLayout];
}

- (void) setTextColor:(UIColor *)textColor atRange:(NSRange)range {
    [self.attributedString setAttribute:NSForegroundColorAttributeName withValue:textColor atRange:range];
    [self renewTextLayout];
}



/**
 设置[背景色]到指定的区间;
 
 @param backgroundColor 背景色;
 @param range 指定区间;
 */
- (void) setBackgroundColor:(UIColor*)backgroundColor atRange:(NSRange)range {
    
    JFTextBackgoundColor* backColor = [JFTextBackgoundColor new];
    backColor.backgroundColor = backgroundColor;
    backColor.range = range;
    [self.attributedString addTextBackgroundColor:backColor];
    [self renewTextLayout];
}


/**
 插入[图片]到指定的位置;
 如果指定的位置已经有图片了，则替换掉原来的图片;
 
 @param image 图片;
 @param position 指定的位置;
 */
- (void) setImage:(UIImage*)image imageSize:(CGSize)imageSize atPosition:(NSInteger)position {
    JFTextAttachment* textAttachment = [JFTextAttachment new];
    textAttachment.contents = image.copy;
    textAttachment.range = NSMakeRange(position, 1);
    textAttachment.contentSize = imageSize;
    [self.attributedString addTextAttachment:textAttachment];
    [self renewTextLayout];
}


/**
 添加[点击事件];
 指定区间和高亮颜色;
 绑定关联数据;
 
 @param data 关联数据: 比如，网址、电话号码等;在点击事件中，处理关联的数据;
 @param textSelectedColor 点击时的文本高亮色;
 @param backSelectedColor 点击时的文本背景色;
 @param range 指定区间;
 */
- (void) addLinkWithData:(id)data
       textSelectedColor:(UIColor*)textSelectedColor
       backSelectedColor:(UIColor*)backSelectedColor
                 atRange:(NSRange)range
{
    JFTextHighLight* highLight = [JFTextHighLight new];
    highLight.textSelectedColor = textSelectedColor;
    highLight.backSelectedColor = backSelectedColor;
    highLight.range = range;
    highLight.content = data;
    [self.attributedString addTextHighLight:highLight];
    [self renewTextLayout];
}


/**
 判断是否点击了高亮区;
 逐个比较当前缓存中的所有高亮区;
 
 @param position 点击坐标
 @return 存在任意一个高亮区，则返回YES;否则返回NO;
 */
- (BOOL) didClickedHighLightPosition:(CGPoint)position {
    return [self.textLayout didClickedHighLightPosition:position];
}

/**
 更新高亮区的显示开关;
 在执行这个方法前，需要先执行上面的判断;
 
 @param switchOn 高亮开关;
 @param position 高亮区所在的坐标;
 */
- (void) turnningHightLightSwitch:(BOOL)switchOn atPosition:(CGPoint)position {
    JFTextHighLight* highLight = [self.textLayout highLightAtPosition:position];
    if (highLight && highLight.textSelectedColor) {
        if (switchOn) {
            [self.attributedString setTextColor:highLight.textSelectedColor atRange:highLight.range];
        } else {
            [self.attributedString setTextColor:self.textColor atRange:highLight.range];
        }
        [self renewTextLayout];
    }
    [self.textLayout turnningHightLightSwitch:switchOn atPosition:position];
}



/**
 绘制文本缓存到上下文;
 分别绘制背景色、文本、边框、附件;
 
 @param context 图形上下文;
 */
- (void) drawInContext:(CGContextRef)context isCanceled:(isCanceledBlock)canceled {
    [self.textLayout drawInContext:context isCanceled:canceled];
}



# pragma mask 2 tools


/**
 重新生成文本布局属性
 */
- (void) renewTextLayout {
    JFTextLayout* layout = self.textLayout;
    self.textLayout = [JFTextLayout jf_textLayoutWithAttributedString:self.attributedString
                                                                frame:self.frame
                                                           linesCount:self.numberOfLines
                                                               insets:self.insets];
    self.textLayout.debugMode = self.debugMode;
    self.textLayout.backgroundColor = self.backgroundColor;
    self.suggustFrame = self.textLayout.suggestFrame;
    if (layout) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [layout class];
        });
    }
}


# pragma mask 3 life cycle 
- (instancetype) initWithText:(NSString*)text frame:(CGRect)frame insets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame insets:insets];
    if (self) {
        _attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        _numberOfLines = 0;
    }
    return self;
}

# pragma mask 4 setter

- (void)setTextFont:(UIFont *)textFont {
    if (textFont == _textFont) {
        return;
    }
    _textFont = textFont;
    [self.attributedString setFont:textFont];
    [self renewTextLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor == _textColor) {
        return;
    }
    _textColor = textColor;
    [self.attributedString setTextColor:textColor];
    [self renewTextLayout];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor == _backgroundColor) {
        return;
    }
    _backgroundColor = backgroundColor;
    self.textLayout.backgroundColor = backgroundColor;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (numberOfLines == _numberOfLines) {
        return;
    }
    _numberOfLines = numberOfLines;
    [self renewTextLayout];
}

- (void)setLineSpace:(CGFloat)lineSpace {
    if (lineSpace < 0) {
        return;
    }
    _lineSpace = lineSpace;
    if (!self.paragraphStyle) {
        self.paragraphStyle = [NSMutableParagraphStyle new];
    }
    self.paragraphStyle.lineSpacing = lineSpace;
    [self.attributedString setAttribute:NSParagraphStyleAttributeName withValue:self.paragraphStyle atRange:NSMakeRange(0, self.attributedString.length)];
    [self renewTextLayout];
}

- (void)setKernSpace:(CGFloat)kernSpace {
    if (kernSpace < 0) {
        return;
    }
    _kernSpace = kernSpace;
    [self.attributedString setAttribute:NSKernAttributeName withValue:@(kernSpace) atRange:NSMakeRange(0, self.attributedString.length)];
    [self renewTextLayout];
}

- (void)setDebugMode:(BOOL)debugMode {
    _debugMode = debugMode;
    self.textLayout.debugMode = debugMode;
}


@end

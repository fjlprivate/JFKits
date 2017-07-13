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

@property (nonatomic, strong) JFTextLayout* textLayout;
@property (nonatomic, strong) NSMutableAttributedString* attributedString; // 富文本

@end

@implementation JFTextStorage

# pragma mask 1

/**
 生成textStorage
 
 @param text 文本
 @param frame 文本frame
 @return textStorage
 */
+ (instancetype) jf_textStorageWithText:(NSString*)text frame:(CGRect)frame {
    if (!text || text.length == 0) {
        return nil;
    }
    JFTextStorage* textStorage = [JFTextStorage new];
    textStorage.attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    textStorage.frame = frame;
    return textStorage;
}

/**
 给文本的指定位置设置属性;
 
 @param attributeName 属性名: NSFontAttributeName, NSForegroundAttributeName等;
 @param value 属性相关值;
 @param range 指定的区间;
 */
- (void) setAttribute:(NSString*)attributeName withValue:(id)value atRange:(NSRange)range {
    [self.attributedString setAttribute:attributeName withValue:value atRange:range];
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
    highLight.textSelectedColor = textSelectedColor.copy;
    highLight.backSelectedColor = backSelectedColor.copy;
    highLight.range = range;
    highLight.content = data;
    [self.attributedString addTextHighLight:highLight];
    [self renewTextLayout];
}





/**
 绘制文本缓存到上下文;
 分别绘制背景色、文本、边框、附件;
 
 @param context 图形上下文;
 */
- (void) drawInContext:(CGContextRef)context {
    
}



# pragma mask 2 tools


/**
 重新生成
 */
- (void) renewTextLayout {
    JFTextLayout* layout = self.textLayout;
    self.textLayout = [JFTextLayout jf_textLayoutWithAttributedString:self.attributedString frame:self.frame linesCount:self.numberOfLines];
    if (layout) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [layout class];
        });
    }
}


# pragma mask 4 setter

// 设置frame
- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(self.frame, frame)) {
        _frame = frame;
        [self renewTextLayout];
    }
}

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
    JFTextBackgoundColor* textBack = [JFTextBackgoundColor new];
    textBack.backgroundColor = backgroundColor;
    textBack.range = NSMakeRange(0, self.attributedString.length);
    [self.attributedString addTextBackgroundColor:textBack];
    [self renewTextLayout];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (numberOfLines == _numberOfLines) {
        return;
    }
    _numberOfLines = numberOfLines;
    [self renewTextLayout];
}

@end

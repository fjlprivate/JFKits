//
//  NSString+Extension.m
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "NSString+Extension.h"
#import "JFHelper.h"

@implementation NSString (Extension)

/**
 计算文本区域size;
 @param width 给定宽度;
 @param font 字体;
 @return size;
 */
- (CGSize) sizeWithWidth:(CGFloat)width font:(UIFont*)font
{
    NSMutableDictionary* attributes = @{}.mutableCopy;
    if (font) {
        font = [UIFont systemFontOfSize:14];
    }
    [attributes setObject:font forKey:NSFontAttributeName];
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                           attributes:attributes
                              context:nil].size;
}





// 识别当前字符串url属于什么媒体类型
- (JFImageStringName) imageType {
    NSString* component = [self lastPathComponent];
    if ([component hasSuffix:@".png"] || [component hasSuffix:@".PNG"] || [component hasSuffix:@".jpeg"] || [component hasSuffix:@".JPEG"]) {
        return JFImageStringNameImage;
    }
    else if ([component hasSuffix:@".gif"] || [component hasSuffix:@".GIF"]) {
        return JFImageStringNameGif;
    }
    else if ([component hasSuffix:@".mp4"] || [component hasSuffix:@".MP4"]) {
        return JFImageStringNameMP4;
    }
    else {
        return JFImageStringNameUnkown;
    }
}


/**
 汉字 -> 拼音;
 @return 拼音;不带音标;
 */
- (NSString*) jf_pinyin {
    NSMutableString* pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}

/**
 将指定区间的字母替换为*
 @param range 指定区间
 @return 替换后的
 */
- (NSString*) jf_transferXingAtRange:(NSRange)range {
    if (IsNon(self)) {
        return nil;
    }
    if (range.location == NSNotFound && range.location >= self.length) {
        return nil;
    }
    NSRange aviableRange = range;
    if (range.location + range.length > self.length) {
        aviableRange.length = self.length - range.location;
    }
    NSMutableString* xing = [NSMutableString string];
    for (int i = 0; i < aviableRange.length; i++) {
        [xing appendString:@"*"];
    }
    return [self stringByReplacingCharactersInRange:aviableRange withString:xing];
}

// base64编码
- (NSString*) jf_base64Coding {
    if (IsNon(self)) {
        return nil;
    }
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
// base64解码
- (NSString*) jf_base64Decoding {
    if (IsNon(self)) {
        return nil;
    }
    NSData* data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



@end

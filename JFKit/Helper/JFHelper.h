//
//  JFHelper.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMacro.h"
#import "JFConstant.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>

# pragma mark - 颜色相关
/**
 十六进制颜色
 @param rgb         :十六进制值,如：0x00a1dc(支付宝蓝色)
 @param alpha       :alpha值通道, 0.f~1.f
 @return RGB颜色对象
 */
static inline UIColor* JFRGBAColor(NSInteger rgb, CGFloat alpha) {
    return [UIColor colorWithRed:(CGFloat)((rgb & 0xff0000) >> (8 * 2))/(CGFloat)0xff
                           green:(CGFloat)((rgb & 0x00ff00) >> (8 * 1))/(CGFloat)0xff
                            blue:(CGFloat)((rgb & 0x0000ff) >> (8 * 0))/(CGFloat)0xff
                           alpha:alpha];
}

# pragma mark - UIFont相关

// 生成粗体系统字体
static inline UIFont* JFBoldSystemFont(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
}

// 生成普通系统字体
static inline UIFont* JFSystemFont(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
}

/**
 生成字体:指定名称和大小;
 @param name 字体名称
 @param fontSize 字体大小
 @return UIFont*
 */
static inline UIFont* JFFontWithName(NSString* name, CGFloat fontSize) {
    if (!name || name.length == 0) {
        return JFSystemFont(fontSize);
    }
    if (@available(iOS 9, *)) {
        return [UIFont fontWithName:name size:fontSize];
    } else {
        // ios9之前是没有苹方字体的
        if ([name hasPrefix:@"PingFang"]) {
            return JFSystemFont(fontSize);
        } else {
            return [UIFont fontWithName:name size:fontSize];
        }
    }
}


/**
 计算文本指定字体的文本区域大小

 @param text 文本
 @param font 字体
 @return 文本尺寸
 */
static inline CGSize JFTextSizeInFont(NSString* text, UIFont* font) {
    if (!text || text.length == 0) {
        text = @"测试";
    }
    if (!font) {
        return CGSizeZero;
    }
    NSDictionary* textAttri = @{NSFontAttributeName:font};
    NSAttributedString* attriText = [[NSAttributedString alloc] initWithString:text attributes:textAttri];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attriText);
    CGSize constraints = CGSizeMake(10000, 10000);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,
                                                                   CFRangeMake(0, text.length),
                                                                   (__bridge CFDictionaryRef)textAttri,
                                                                   constraints,
                                                                   NULL);
    CFRelease(frameSetter);
    return textSize;
}
static inline CGFloat JFTextHeightInFont(NSString* text, UIFont* font, CGFloat textWidth) {
    if (!text || text.length == 0) {
        text = @"测试";
    }
    if (!font) {
        return 0;
    }
    NSDictionary* textAttri = @{NSFontAttributeName:font};
    NSAttributedString* attriText = [[NSAttributedString alloc] initWithString:text attributes:textAttri];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attriText);
    CGSize constraints = CGSizeMake(textWidth, 100000);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,
                                                                   CFRangeMake(0, text.length),
                                                                   (__bridge CFDictionaryRef)textAttri,
                                                                   constraints,
                                                                   NULL);
    CFRelease(frameSetter);
    return textSize.height;
}

// 指定了宽度、字间距
static inline CGFloat JFTextHeightInFontWithLinespacing(NSString* text, UIFont* font, CGFloat textWidth, CGFloat lineSpacing) {
    if (!text || text.length == 0) {
        text = @"测试";
    }
    if (!font) {
        return 0;
    }
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary* textAttri = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    NSAttributedString* attriText = [[NSAttributedString alloc] initWithString:text attributes:textAttri];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attriText);
    CGSize constraints = CGSizeMake(textWidth, 100000);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,
                                                                   CFRangeMake(0, text.length),
                                                                   (__bridge CFDictionaryRef)textAttri,
                                                                   constraints,
                                                                   NULL);
    CFRelease(frameSetter);
    return textSize.height;
}

# pragma mark - 格式化时间

/**
 转换日期格式: date -> 可视的日期时间格式

 @param date 日期时间
 @param format 时间格式
 @return 格式化的时间
 */
static inline NSString* JFTimeStringWithFormat(NSDate* date, NSString* format) {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}


/**
 获取当前日期的字符串: yyyyMMdd
 @return NSString;
 */
static inline NSString* JFCurrentDateString() {
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    return [dateFormat stringFromDate:date];
}

/**
 获取当前日期时间的字符串: yyyyMMddHHmmss
 @return NSString;
 */
static inline NSString* JFCurrentDateTimeString() {
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormat stringFromDate:date];
}


/**
 格式化时长;
 @param duration 时长;单位为浮点型的秒
 @return 输出'mm:ss'格式的字符串
 */
static inline NSString* JFFormatDuration(NSTimeInterval duration) {
    NSInteger min = ((NSInteger)duration) / 60;
    NSInteger sec = ((NSInteger)duration) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}

# pragma mark - image相关

/**
 简写:创建本地图片;
 @param imageName 本地图片名
 @return 图片对象;
 */
static inline UIImage* JFImageNamed(NSString* imageName) {
    return [UIImage imageNamed:imageName];
}


# pragma mark - 系统相关



/**
 获取手机型号
 @return JFIphoneType
 */
static inline NSString* JFIphoneType(void) {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceString = [NSString stringWithUTF8String:systemInfo.machine];
    if ([deviceString hasPrefix:@"iPhone3"])
        return JFIphoneType4;
    if ([deviceString isEqualToString:@"iPhone4,1"])
        return JFIphoneType4s;
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])
        return JFIphoneType5;
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])
        return JFIphoneType5c;
    if ([deviceString hasPrefix:@"iPhone6"])
        return JFIphoneType5s;
    if ([deviceString isEqualToString:@"iPhone7,1"])
        return JFIphoneType6_P;
    if ([deviceString isEqualToString:@"iPhone7,2"])
        return JFIphoneType6;
    if ([deviceString isEqualToString:@"iPhone8,1"])
        return JFIphoneType6s;
    if ([deviceString isEqualToString:@"iPhone8,2"])
        return JFIphoneType6s_P;
    if ([deviceString isEqualToString:@"iPhone8,4"])
        return JFIphoneTypeSE;
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])
        return JFIphoneType7;
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])
        return JFIphoneType7_P;
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])
        return JFIphoneType8;
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])
        return JFIphoneType8_P;
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])
        return JFIphoneTypeX;
    return nil;
}

static inline JFIPhoneV JFIphoneType_V(void) {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceString = [NSString stringWithUTF8String:systemInfo.machine];
    if ([deviceString hasPrefix:@"iPhone3"])
        return JFIPhoneV4;
    if ([deviceString isEqualToString:@"iPhone4,1"])
        return JFIPhoneV4S;
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])
        return JFIPhoneV5;
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])
        return JFIPhoneV5C;
    if ([deviceString hasPrefix:@"iPhone6"])
        return JFIPhoneV5S;
    if ([deviceString isEqualToString:@"iPhone7,1"])
        return JFIPhoneV6P;
    if ([deviceString isEqualToString:@"iPhone7,2"])
        return JFIPhoneV6;
    if ([deviceString isEqualToString:@"iPhone8,1"])
        return JFIPhoneV6S;
    if ([deviceString isEqualToString:@"iPhone8,2"])
        return JFIPhoneV6SP;
    if ([deviceString isEqualToString:@"iPhone8,4"])
        return JFIPhoneVSE;
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])
        return JFIPhoneV7;
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])
        return JFIPhoneV7P;
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])
        return JFIPhoneV8;
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])
        return JFIPhoneV8P;
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])
        return JFIPhoneVX;
    return JFIPhoneVX;
}

/**
 获取APP的名字;
 @return NSString
 */
static inline NSString* JFAppName(void) {
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleDisplayName"];
}
/**
 获取APP的版本号;
 @return NSString
 */
static inline NSString* JFAppVersion(void) {
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}


/**
 获取APP的logo;
 @return UIImage
 */
static inline UIImage* JFAppLogo(void) {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:icon];
}



/**
 获取系统版本;
 @return CGFloat;
 */
static inline CGFloat JFIOSVersion(void) {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}



/**
 获取当前正在显示的viewController
 @return UIViewController
 */
static inline UIViewController* JFCurrentViewController(void) {
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    UIViewController* topVC = window.rootViewController;
    while (true) {
        // 如果topVC有presentedVC,则置它为topVC，继续
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        // 如果topVC是navigationVC,则取它的topVC,继续
        else if ([topVC isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topVC topViewController]) {
            topVC = [(UINavigationController*)topVC topViewController];
        }
        // 如果topVC是tabController，则取它的selectedVC，继续
        else if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = [(UITabBarController*)topVC selectedViewController];
        }
        // 否则就可以返回它了
        else {
            break;
        }
    }
    return topVC;
}

// 获取iphoneX下边的边距
static inline CGFloat JFScreenSafeBottom(void) {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}


# pragma mark - 判断


/**
 判断对象是否为空;
 @param obj OC对象;
 @return YES:为空;NO:非空;
 */
static inline BOOL IsNon(id obj) {
    if (obj == nil || obj == NULL) {
        return YES;
    }
    if ([obj isEqual:[NSNull null]]) {
        return YES;
    }
    // 字符串
    if ([obj isKindOfClass:[NSString class]] ||
        [obj isKindOfClass:[NSAttributedString class]] ||
        [obj isKindOfClass:[NSMutableAttributedString class]]
        )
    {
        return [obj length] == 0;
    }
    // 集合:数组、字典等
    else if ([obj isKindOfClass:[NSArray class]] ||
             [obj isKindOfClass:[NSMutableArray class]] ||
             [obj isKindOfClass:[NSDictionary class]] ||
             [obj isKindOfClass:[NSMutableDictionary class]]
             )
    {
        return [obj count] == 0;
    }
    return NO;
}


# pragma mark - 数值计算


/**
 按iphone6的屏幕宽度来缩放宽度值;
 @param width 要缩放的宽度值;
 @return 缩放后的宽度值;
 */
static inline CGFloat JFScaleWidth6 (CGFloat width) {
    return width * JFSCREEN_WIDTH / 375.f;
}

# pragma mark - 编码加密

/**
 MD5编码;
 @param source 原始串;
 @return MD5编码的串;
 */
static inline NSString* JFMD5(NSString* source) {
    if (IsNon(source)) {
        return nil;
    }
    const char* cStr = [source UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString* outPut = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPut appendFormat:@"%02x", digest[i]];
    }
    return outPut.copy;
}



@interface JFHelper : NSObject

/**
 获取APP的启动图片;
 @return 启动图片;
 */
+ (UIImage*) getLaunchImage;


/**
 保存图片到相册;
 @param image UIImage|NSURL
 @param finishedBlock 回调: error == nil时:成功； 否则失败
 */
+ (void) saveImageToPhotoLibrary:(id)image onFinished:(void (^) (NSError* error))finishedBlock;

@end

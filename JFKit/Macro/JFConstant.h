//
//  JFConstant.h
//  JFKitDemo
//
//  Created by LiChong on 2018/1/8.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#ifndef JFConstant_h
#define JFConstant_h

static NSString* const JFIphoneType4        = @"iPhone 4";
static NSString* const JFIphoneType4s       = @"iPhone 4S";
static NSString* const JFIphoneType5        = @"iPhone 5";
static NSString* const JFIphoneType5c       = @"iPhone 5c";
static NSString* const JFIphoneType5s       = @"iPhone 5s";
static NSString* const JFIphoneType6        = @"iPhone 6";
static NSString* const JFIphoneType6_P      = @"iPhone 6 Plus";
static NSString* const JFIphoneType6s       = @"iPhone 6s";
static NSString* const JFIphoneType6s_P     = @"iPhone 6s Plus";
static NSString* const JFIphoneTypeSE       = @"iPhone SE";
static NSString* const JFIphoneType7        = @"iPhone 7";
static NSString* const JFIphoneType7_P      = @"iPhone 7 Plus";
static NSString* const JFIphoneType8        = @"iPhone 8";
static NSString* const JFIphoneType8_P      = @"iPhone 8 Plus";
static NSString* const JFIphoneTypeX        = @"iPhone X";


// IPhone型号
typedef NS_ENUM(NSInteger, JFIPhoneV) {
    JFIPhoneV4,
    JFIPhoneV4S,
    JFIPhoneV5,
    JFIPhoneV5C,
    JFIPhoneV5S,
    JFIPhoneV6,
    JFIPhoneV6P,
    JFIPhoneV6S,
    JFIPhoneV6SP,
    JFIPhoneVSE,
    JFIPhoneV7,
    JFIPhoneV7P,
    JFIPhoneV8,
    JFIPhoneV8P,
    JFIPhoneVX
};

typedef NS_ENUM(NSInteger, JFVideoPlayState) {
    JFVideoPlayStateWaiting             = 0,        // 等待播放
    JFVideoPlayStateReadToPlay          = 1,        // 准备好播放
    JFVideoPlayStatePlaying             = 2,        // 正在播放
    JFVideoPlayStatePausing             = 3,        // 暂停播放
    JFVideoPlayStateFinishing           = 4,        // 播放完毕
    JFVideoPlayStateFailed              = 5,        // 播放失败
};



// 判断是否退出的block
typedef BOOL (^ IsCancelled) (void);

#endif /* JFConstant_h */

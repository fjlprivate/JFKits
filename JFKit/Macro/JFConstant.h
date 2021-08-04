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

// 古典色
typedef NS_ENUM(NSInteger, JFColor) {
    JFColorShiLv         = 0x206864,   // 石绿
    JFColorCuiLv         = 0x02786a,   // 翠绿
    JFColorZhuShaHong    = 0xeb4b17,   // 朱砂红
    JFColorHuangLiLiu    = 0xfec85e,   // 黄栗留
    JFColorQieLan        = 0x88abda,   // 窃蓝
    JFColorEHuang        = 0xf2c867,   // 鹅黄
    JFColorCangJia       = 0xa8bf8f,   // 苍葭
    JFColorYanWei        = 0x4a4b9d,   // 延维
    JFColorQingMing      = 0x3271ae,   // 青冥
    JFColorShiYangJin    = 0xf8c6b5,   // 十样锦
    JFColorYangFei       = 0xf091a0,   // 杨妃
    JFColorCangLang      = 0x99bcac,   // 苍莨
    JFColorZhiZi         = 0xfac015,   // 栀子
    JFColorDanLi         = 0xe60012,   // 丹蘮
    JFColorRuMengLing    = 0xddbb99,   // 如梦令
    JFColorQingDai       = 0x45465e,   // 青黛
};



// 判断是否退出的block
typedef BOOL (^ IsCancelled) (void);

#endif /* JFConstant_h */

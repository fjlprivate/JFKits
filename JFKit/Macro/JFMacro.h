//
//  JFMacro.h
//  JFKit
//
//  Created by warmjar on 2017/7/5.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#ifndef JFMacro_h
#define JFMacro_h


// ******** [尺寸相关] ********

#define JFSCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define JFSCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define JFSCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height

#define JFSCREEN_SCALE          [UIScreen mainScreen].scale

// 导航栏高度
#define JFNavigationBarHeight   44.f
// 状态栏高度
#define JFStatusBarHeight       [UIApplication sharedApplication].statusBarFrame.size.height
// 导航栏+状态栏高度
#define JFNaviStatusBarHeight   (JFNavigationBarHeight+JFStatusBarHeight)
// 下部切换部件高度
#define JFTabBarHeight          self.tabBarController.tabBar.bounds.size.height
// 全屏手机底部间隔
#define JFSafeInsetBottom       34.f

// ******** [缩写] ********

#define WeakSelf(wself)         __weak typeof(self) wself = self


// ******** [颜色] ********
#define JFColorClear            [UIColor clearColor]
#define JFColorWhite            [UIColor whiteColor]
#define JFColorBlack            [UIColor blackColor]
#define JFColorOrange           [UIColor orangeColor]

#endif /* JFMacro_h */

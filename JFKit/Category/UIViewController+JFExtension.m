//
//  UIViewController+JFExtension.m
//  QiangQiang
//
//  Created by longerFeng on 2019/4/20.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import "UIViewController+JFExtension.h"

@implementation UIViewController (JFExtension)

// 当前界面是否正在显示
- (BOOL) jf_isDisplayingVC {
    return self.isViewLoaded && self.view.window;
}

@end

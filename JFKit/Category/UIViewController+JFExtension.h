//
//  UIViewController+JFExtension.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/20.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JFExtension)

// 当前界面是否正在显示
- (BOOL) jf_isDisplayingVC;

@end

NS_ASSUME_NONNULL_END

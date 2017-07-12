//
//  JFButton.h
//  JFKit
//
//  Created by warmjar on 2017/7/11.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ BlockTouchUpInside)(void);

@interface JFButton : UIButton

// 点击事件回调: touch up in-side
@property (nonatomic, copy) BlockTouchUpInside didTouchedUpInside;

@end

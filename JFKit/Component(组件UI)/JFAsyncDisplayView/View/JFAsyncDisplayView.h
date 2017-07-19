//
//  JFAsyncDisplayView.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFLayout.h"

@interface JFAsyncDisplayView : UIView

@property (nonatomic, strong) JFLayout* layout; // 混排布局对象;setter中刷新绘制;

@end

//
//  JFImageBrowserViewController.h
//  TestForTransition
//
//  Created by LiChong on 2017/12/25.
//  Copyright © 2017年 johnny feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFImageBrowserItem.h"
#import "JFImageBrowserHandler.h"


@interface JFImageBrowserViewController : UIViewController

/// 动画转场显示图片浏览器;
/// 并将创建的图片浏览器对象返回;
/// @param fromVC  加载图片浏览器的界面视图控制器
/// @param imageList  图片组; NSArray<JFImageBrowserItem*>
/// @param startAtIndex  起始浏览图片的索引
/// @param handleAfterLongpressed  回调：从调用方获取长按事件的处理handles
+ (instancetype) jf_showFromVC:(UIViewController*)fromVC
                 withImageList:(NSArray<JFImageBrowserItem*>*)imageList
                  startAtIndex:(NSInteger)startAtIndex
        handleAfterLongpressed:(NSArray<JFImageBrowserHandler*>* (^) (NSInteger atIndex))handleAfterLongpressed;


// 背景色;默认:黑色
@property (nonatomic, copy) UIColor* bgColor;



@end

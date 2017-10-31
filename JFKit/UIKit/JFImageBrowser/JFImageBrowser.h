//
//  JFImageBrowser.h
//  JFKitDemo
//
//  Created by johnny feng on 2017/8/16.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFImageBrowserDelegate <NSObject>

@required


/**
 数据源: image的个数;

 @return image的个数;
 */
- (NSInteger) numberOfImageSections;


/**
 数据源: 获取指定section的image数据;

 @param section 指定section;
 @return image数据:<UIImage> or <NSURL>;
 */
- (id) imageDataAtSection:(NSInteger)section;

@end



@interface JFImageBrowser : UIViewController


- (instancetype) initWithFromVC:(UIViewController*)fromVC;

@property (nonatomic, weak) id<JFImageBrowserDelegate> delegate;

// 背景图片;默认白色图片
@property (nonatomic, strong) UIImage* backgroundImage;

- (void) show;
- (void) hide;

@end

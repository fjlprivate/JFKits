//
//  JFLayout.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/12.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTextStorage.h"
#import "JFImageStorage.h"


@interface JFLayout : NSObject

@property (nonatomic, strong) NSMutableArray<JFStorage*>* storages; // 保存添加的缓存对象，text和image保存在一起
@property (nonatomic, assign) CGFloat bottom; // 添加完缓存对象后，根据布局计算底部

/**
 添加缓存对象;

 @param storage 缓存对象(text|image);
 */
- (void) addStorage:(JFStorage*)storage;


@end

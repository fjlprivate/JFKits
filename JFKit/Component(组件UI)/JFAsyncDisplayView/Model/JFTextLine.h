//
//  JFTextLine.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/13.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface JFTextLine : NSObject

@property (nonatomic, assign) CTLineRef lineRef;

@property (nonatomic, assign) CGPoint lineOrigin;

@end

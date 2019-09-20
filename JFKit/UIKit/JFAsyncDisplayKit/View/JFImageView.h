//
//  JFImageView.h
//  JFKitDemo
//
//  Created by johnny feng on 2018/2/20.
//  Copyright © 2018年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFImageLayout.h"

@class JFImageView;

@protocol JFImageViewDelegate <NSObject>
- (void) didClickedImageView:(JFImageView*)imageView;
@end


@interface JFImageView : UIImageView

@property (nonatomic, strong) JFImageLayout* imageLayout;

@property (nonatomic, weak) id<JFImageViewDelegate> delegate;

@end

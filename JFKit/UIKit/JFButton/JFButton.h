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


// [self titleForState:UIControlStateNormal]
@property (nonatomic, strong) NSString* normalTitle;

// [self titleColorForState:UIControlStateNormal]
@property (nonatomic, strong) UIColor* normalTitleColor;

// [self titleColorForState:UIControlStateHighlighted]
@property (nonatomic, strong) UIColor* highLightTitleColor;

// [self titleColorForState:UIControlStateDisabled]
@property (nonatomic, strong) UIColor* disableTitleColor;

// self.titleLabel.font
@property (nonatomic, strong) UIFont* titleFont;

// 点击范围的扩大;默认:UIEdge(-20,-20,-20,-20)
@property (nonatomic, assign) UIEdgeInsets touchEdges;

@end

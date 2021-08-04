//
//  JFImageBrowserCell.h
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/24.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFZoomImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFImageBrowserCell : UICollectionViewCell
@property (nonatomic, strong) JFZoomImageView* imageView;
@end

NS_ASSUME_NONNULL_END

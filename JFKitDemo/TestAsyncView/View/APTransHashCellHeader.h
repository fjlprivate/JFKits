//
//  APTransHashCellHeader.h
//  AntPocket
//
//  Created by 严美 on 2019/10/9.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFKit.h"
#import "APTransHashHeaderLayouts.h"

NS_ASSUME_NONNULL_BEGIN

@interface APTransHashCellHeader : UITableViewCell
@property (nonatomic, strong) APTransHashHeaderLayouts* layouts;
@property (nonatomic, strong) JFAsyncView* asyncView;
@end

NS_ASSUME_NONNULL_END

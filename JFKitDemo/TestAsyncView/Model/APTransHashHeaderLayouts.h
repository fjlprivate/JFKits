//
//  APTransHashHeaderLayouts.h
//  AntPocket
//
//  Created by 严美 on 2019/10/9.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import "JFAsyncViewLayouts.h"

NS_ASSUME_NONNULL_BEGIN

@interface APTransHashHeaderLayouts : JFAsyncViewLayouts
- (instancetype) initWithModel:(NSDictionary*)model;
@property (nonatomic, assign) CGRect sectionFrame;
@property (nonatomic, assign) CGRect lineFrame;

- (instancetype) initQuanwenLayouts;
@end

NS_ASSUME_NONNULL_END

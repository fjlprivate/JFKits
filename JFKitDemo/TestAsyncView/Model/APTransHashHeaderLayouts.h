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

- (instancetype) initQuanwenLayouts;
- (instancetype) initImageTextLayouts;
- (instancetype) initWithJsonNode;
// 展开全文
- (void) spreadUp;
@end

NS_ASSUME_NONNULL_END

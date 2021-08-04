//
//  TestFAMoveInputView.h
//  JFTools
//
//  Created by fjl on 2021/6/11.
//

#import "JFPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestFAMoveInputView : JFPresenter

// 回调:确定
@property (nonatomic, copy) void (^ sureBlock) (NSIndexPath* fromId, NSIndexPath* toId);
// 回调:取消
@property (nonatomic, copy) void (^ cancelBlock) (void);


@end

NS_ASSUME_NONNULL_END

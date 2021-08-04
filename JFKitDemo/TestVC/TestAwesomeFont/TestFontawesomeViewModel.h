//
//  TestFontawesomeViewModel.h
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/11.
//

#import <Foundation/Foundation.h>
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestFontawesomeViewModel : NSObject

- (NSInteger) numberOfSections;
- (NSInteger) numberOfItemsInSection:(NSInteger)section;

- (NSString*) titleForSection:(NSInteger)section;
- (NSString*) nameForItemAtIndexPath:(NSIndexPath*)indexPath;
- (FAIcon) valueForItemAtIndexPath:(NSIndexPath*)indexPath;

// 移动item
- (void) moveItemFromIndexPath:(NSIndexPath*)fromId toIndexPath:(NSIndexPath*)toId;
// 取消移动的item;归位
- (void) cancelMoving;
// 完成移动;
- (void) endMoving;

// 保存数据到本地;
- (void) saving;


@end

NS_ASSUME_NONNULL_END

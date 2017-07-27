//
//  VTMFeedCell.h
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTMFeedCell;

@protocol VTMFeedCellDelegate <NSObject>


/**
 文本点击事件

 @param cell 点击事件所在的cell;
 @param textData 点击的文本数据;
 */
- (void) feedCell:(VTMFeedCell*)cell didClickedTextData:(id)textData;

@end


@class MFeedLayout;
@interface VTMFeedCell : UITableViewCell
@property (nonatomic, strong) MFeedLayout* layout;
@property (nonatomic, weak) id<VTMFeedCellDelegate> delegate;
@end

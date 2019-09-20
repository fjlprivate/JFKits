//
//  JFPhotoPickerBrowserViewController.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/1.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFPhotoPickerBrowserViewController : UIViewController



/**
 初始化;
 @param models 多媒体数据源
 @param startIndex 开始浏览的序号
 @return JFPhotoPickerBrowserViewController*
 */
- (instancetype) initWithModels:(NSArray*)models atStartIndex:(NSInteger)startIndex;


@end

NS_ASSUME_NONNULL_END

//
//  JFVideoSlider.h
//  QiangQiang
//
//  Created by longerFeng on 2019/4/24.
//  Copyright © 2019 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/************* 视频搓擦条 *************/
@interface JFVideoSlider : UIView

// 总时长
@property (nonatomic, assign) NSTimeInterval duration;
// 当前播放时间
@property (nonatomic, assign) NSTimeInterval curTime;
// 预加载时间
@property (nonatomic, assign) NSTimeInterval preLoadedTime;

// 回调:更新了进度;只有拖动事件才会引发此回调;
@property (nonatomic, copy) void (^ willUpdateSlider) (JFVideoSlider* slider);
@property (nonatomic, copy) void (^ didUpdateSlider) (JFVideoSlider* slider);
@property (nonatomic, copy) void (^ didEndUpdateSlider) (JFVideoSlider* slider);

@end

NS_ASSUME_NONNULL_END

//
//  JFZoomImageView.h
//  QiangQiang
//
//  Created by LiChong on 2018/6/11.
//  Copyright © 2018年 ShenZhenZhongShanXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFZoomImageView : UIScrollView <UIScrollViewDelegate>


/**
 设置图片;
 @param image 可以是如下格式:
                UIImage:直接加载
                NSString:网页图片;SDWebImage异步加载;
                NSURL->fileURL:静态图片;直接加载;
                NSURL->URL:网页图片;SDWebImage异步加载;
 */
- (void) setImage:(id)image;

@property (nonatomic, strong) UIImageView* imageView;
// 点击事件,参数:numberOfTouches(点击几次)
@property (nonatomic, copy) void (^ tapGesEvent) (NSInteger numberOfTouches);
// 长按事件
@property (nonatomic, copy) void (^ longpressEvent) (void);

@end

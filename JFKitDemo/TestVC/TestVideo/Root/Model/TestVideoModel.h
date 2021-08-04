//
//  TestVideoModel.h
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/7/6.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TestVideoModelType) {
    TestVideoModelTypeVideo,
    TestVideoModelTypeImage
};

@interface TestVideoModel : NSObject

@property (nonatomic, assign) TestVideoModelType type;

// 当 type == TestVideoModelTypeVideo
@property (nonatomic, strong) NSURL* videoUrl;
@property (nonatomic, strong) UIImage* thumbnail;

// 当 type == TestVideoModelTypeImage
@property (nonatomic, strong) UIImage* image;


@end

NS_ASSUME_NONNULL_END

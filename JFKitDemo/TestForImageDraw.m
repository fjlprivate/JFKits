//
//  TestForImageDraw.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/19.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestForImageDraw.h"
#import "JFKit.h"

@interface TestImageView : UIView
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) JFImageStorage* imageStorage;
@end



@interface TestForImageDraw ()

@end

@implementation TestForImageDraw

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIView* backview = [UIView new];
    backview.backgroundColor = JFHexColor(0xe0e0e0, 1);
    backview.centerX = JFSCREEN_WIDTH * 0.5;
    backview.centerY = JFSCREEN_HEIGHT * 0.5;
    backview.width = JFSCREEN_WIDTH;
    backview.height = JFSCREEN_WIDTH * 0.5 * 2;
//    [self.view addSubview:backview];
    
    TestImageView* imageView = [[TestImageView alloc] init];
//    imageView.top = 64 + 20;
//    imageView.left = 20;
//    imageView.right = JFSCREEN_WIDTH - 20;
//    imageView.bottom = JFSCREEN_HEIGHT * 0.618;
    imageView.centerX = JFSCREEN_WIDTH * 0.5;
    imageView.centerY = JFSCREEN_HEIGHT * 0.5;
    imageView.width = JFSCREEN_WIDTH * 0.8;
    imageView.height = backview.height;
    [self.view addSubview:imageView];
    
    
    
    
    
}

@end



@implementation TestImageView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0618"]];
        // UIViewContentModeScaleToFill: 完全填充，不考虑宽高比
        // UIViewContentModeScaleAspectFit: 按宽高比：图片比视图胖，则按image.width填充；图片比视图瘦，则按image.height填充;
        // UIViewContentModeScaleAspectFill: 首先，图片是按原始比例填充；其次，图片会按自己的比例占满视图的最小边长
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 绘制背景
    CGContextSetFillColorWithColor(context, JFHexColor(0xe0e0e0, 1).CGColor);
    CGContextFillRect(context, rect);
    
    
    
    
    // 裁剪一个圆形
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frame = CGRectMake((rect.size.width - 200)/2,
                              (rect.size.height - 200)/2,
                              200, 200);
    CGPathAddRoundedRect(path, NULL, frame, 100, 100);
    CGContextAddPath(context, path);
//    CGContextClip(context);
    // 转换坐标系
//    CGContextTranslateCTM(context, 0, rect.size.height);
//    CGContextScaleCTM(context, 1, -1);
//    // 将图片填充到这个裁剪后的圆形区域
//    CGContextDrawImage(context, frame, _imageView.image.CGImage);
//    [_imageView.image drawInRect:frame];
    
//    [_imageView.image drawInRect:frame];
    [self.imageStorage drawInContext:context isCanceled:^BOOL{
        return NO;
    }];
    
}


- (JFImageStorage *)imageStorage {
    if (!_imageStorage) {
        _imageStorage = [JFImageStorage jf_imageStroageWithContents:[UIImage imageNamed:@"selectedBlue"] frame:CGRectMake(10, 10, 24, 24)];
    }
    return _imageStorage;
}


@end

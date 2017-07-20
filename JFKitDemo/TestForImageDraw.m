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
    imageView.centerX = JFSCREEN_WIDTH * 0.5;
    imageView.centerY = JFSCREEN_HEIGHT * 0.5;
//    imageView.width = JFSCREEN_WIDTH * 0.5;
//    imageView.height = imageView.width;
    imageView.width = backview.height * 0.5;
    imageView.height = backview.height;
    [self.view addSubview:imageView];
    
    
    
    
    
}

@end



@implementation TestImageView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UIImage* originImage = [UIImage imageNamed:@"noData"];
//        UIImage* image = [self circleImage:originImage withParam:0];
////            CGSize imageCutSize = CGSizeMake(originImage.size.width * 0.8, originImage.size.height * 0.8);
//////            UIImage* image = [originImage imageCutedWithContentMode:UIViewContentModeCenter
//////                                                            newSize:imageCutSize
//////                                                       cornerRadius:CGSizeMake(10, 10)
//////                                                        borderWidth:2
//////                                                        borderColor:[UIColor orangeColor]
//////                                                    backgroundColor:JFHexColor(0x27384b, 1)];
////        UIImage* image = [originImage imageCutedWithCornerRadius:CGSizeMake(10, 10) borderWidth:2 borderColor:JFHexColor(0x27384b, 1) backgroundColor:[UIColor orangeColor]];
//        _imageView = [[UIImageView alloc] initWithImage:image];
//        // UIViewContentModeScaleToFill: 完全填充，不考虑宽高比
//        // UIViewContentModeScaleAspectFit: 按宽高比：图片比视图胖，则按image.width填充；图片比视图瘦，则按image.height填充;
//        // UIViewContentModeScaleAspectFill: 首先，图片是按原始比例填充；其次，图片会按自己的比例占满视图的最小边长
////        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:_imageView];
        
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.imageView.frame = self.bounds;
//    self.imageView.image = [self circleImage:[UIImage imageNamed:@"noData"] withParam:0] ;
}

- (void)drawRect:(CGRect)rect {
    UIImage* originImage = [UIImage imageNamed:@"noData"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, JFHexColor(0x00a1dc, 1).CGColor);
    CGContextFillRect(context, rect);
    // 绘制上边框
    CGRect upFrame = CGRectMake(0, 0, rect.size.width, rect.size.height * 0.5);
    CGContextSetStrokeColorWithColor(context, JFHexColor(0x27384b, 1).CGColor);
    CGContextStrokeRect(context, upFrame);
    // 绘制下边框
    CGRect downFrame = CGRectMake(0, upFrame.size.height, upFrame.size.width, upFrame.size.height);
    CGContextSetStrokeColorWithColor(context, JFHexColor(0x27384b, 1).CGColor);
    CGContextStrokeRect(context, downFrame);

    
    // 原图绘制到上部
    [originImage drawInRect:upFrame];
    
    
    
    // 裁剪图绘制到下部
    CGSize imageSize = originImage.size;
    CGSize imageCutSize = CGSizeMake(imageSize.width * 0.8, imageSize.height * 0.8);
//    UIImage* image = [_imageView.image imageCutedWithNewSize:CGSizeMake(imageSize.width * 1, imageSize.height * 0.5)];
//    UIImage* image = [self.imageView.image imageCutedWithNewSize:imageCutSize contentMode:UIViewContentModeRight];
    UIImage* image = [originImage imageCutedWithContentMode:UIViewContentModeCenter
                                                             newSize:imageCutSize
                                                        cornerRadius:CGSizeMake(20, 20)
                                                         borderWidth:4
                                                         borderColor:[UIColor orangeColor]
                                                     backgroundColor:JFHexColor(0x00a1dc, 1)];
    
    CGFloat drawWidth = downFrame.size.width * (imageCutSize.width / imageSize.width);
    CGFloat drawHeight = downFrame.size.height * (imageCutSize.height / imageSize.height);
    CGRect drawRect = CGRectMake((downFrame.size.width - drawWidth)/2,
                                 (downFrame.size.height - drawHeight)/2 + downFrame.origin.y,
                                 drawWidth, drawHeight);
    
//    CGContextAddEllipseInRect(context, drawRect);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRoundedRect(path, NULL, drawRect, 10, 10);
//    CGContextAddPath(context, path);
//    CGContextClip(context);
    
    [image drawInRect:drawRect];
//    CGContextDrawImage(context, drawRect, image.CGImage);
    
    
    
    
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


- (JFImageStorage *)imageStorage {
    if (!_imageStorage) {
        _imageStorage = [JFImageStorage jf_imageStroageWithContents:[UIImage imageNamed:@"selectedBlue"] frame:CGRectMake(10, 10, 24, 24)];
    }
    return _imageStorage;
}


@end

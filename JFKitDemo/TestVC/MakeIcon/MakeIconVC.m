//
//  MakeIconVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/7/14.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "MakeIconVC.h"
#import <Photos/Photos.h>


@interface MakeIconVC ()
@property (nonatomic, strong) UILabel* labContent;
@end

@implementation MakeIconVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JFRGBAColor(0xf0f0f0, 1);
    CGFloat scale = 1;
    CGFloat width = 1024 * scale;
//    CGFloat cornerRadius = 160 * scale;
    CGFloat fontSize = width * 0.75;
    self.labContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10, width, width)];
    self.labContent.textColor = JFRGBAColor(JFColorQingDai, 1);
    self.labContent.text = [NSString fontAwesomeIconStringForEnum:FAGlobe];
    self.labContent.font = [UIFont fontAwesomeFontOfSize:fontSize];
    self.labContent.textAlignment = NSTextAlignmentCenter;
    self.labContent.backgroundColor = UIColor.whiteColor;
//    self.labContent.layer.masksToBounds = YES;
//    self.labContent.layer.cornerRadius = cornerRadius;
    [self.view addSubview:self.labContent];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"生成icon" style:UIBarButtonItemStylePlain target:self action:@selector(makeIcon)];
    
}


- (void) makeIcon {
    UIGraphicsBeginImageContextWithOptions(self.labContent.bounds.size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.labContent.layer renderInContext:context];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest* request = [PHAssetChangeRequest creationRequestForAssetFromImage:tImage];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
}


@end

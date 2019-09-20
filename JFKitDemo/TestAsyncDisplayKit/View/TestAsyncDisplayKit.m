//
//  TestAsyncDisplayKit.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/12.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "TestAsyncDisplayKit.h"
#import "AsyncLabel1.h"
#import "JFKit.h"

@interface TestAsyncDisplayKit ()

@end

@implementation TestAsyncDisplayKit

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AsyncLabel1* label1 = [AsyncLabel1 new];
    [self.view addSubview:label1];
    AsyncLabel1* label2 = [AsyncLabel1 new];
    [self.view addSubview:label2];

    
    UIFont* textFont = JFFontWithName(@"Heiti SC", 16);
    // 图片附件
    JFTextAttachmentImage* image = [JFTextAttachmentImage new];
    image.index = 5;
    image.kern = 3;
    image.image = [UIImage imageNamed:@"icon_robot_orange"];
    image.imageSize = CGSizeMake(JFTextSizeInFont(nil, textFont).height, JFTextSizeInFont(nil, textFont).height);
    image.imageSize = CGSizeMake(20, 20);
    // 创建并设置富文本
    NSString* text = @"深圳市宝安区西乡街道固戍前进2路航城工业区16号华丰SOHO创意世界B座五楼521";
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString jf_addImage:image];
    [attributedString jf_setFont:textFont];
    [attributedString jf_setTextColor:JFRGBAColor(0x27384b, 1)];
    [attributedString jf_setKern:3 atRange:NSMakeRange(image.index - 1, 1)];
    // 创建布局对象
    JFTextLayout* layout = [JFTextLayout textLayoutWithFrame:CGRectMake(10, 100.5, JFSCREEN_WIDTH - 20, 100000) text:attributedString insets:UIEdgeInsetsZero backgroundColor:JFRGBAColor(0xffffff, 1)];
    label1.textLayout = layout;
    
    // 创建并设置富文本
    NSMutableAttributedString* attributedString2 = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString2 jf_addImage:image];
    [attributedString2 jf_setFont:textFont];
    [attributedString2 jf_setTextColor:JFRGBAColor(0x27384b, 1)];
    [attributedString2 jf_setKern:3 atRange:NSMakeRange(image.index - 1, 1)];
    // 创建布局对象
    NSString* text2 = @"深圳市宝安区";
    JFTextStorage* text2Storage = [JFTextStorage storageWithText:text2];
    text2Storage.font = textFont;
    text2Storage.textColor = JFRGBAColor(0x27384b, 1);
    JFTextLayout* layout2 = [JFTextLayout textLayoutWithText:text2Storage];
    layout2.left = layout.left;
    layout2.top = layout.bottom + 20;
    layout2.width = layout.width;
    layout2.height = 2000;
    layout2.backgroundColor = JFRGBAColor(0xf0f0f0, 1);
    layout2.insets = UIEdgeInsetsMake(4, 10, 4, 10);
    label2.textLayout = layout2;

    
    // 创建布局对象
//    JFTextStorage* text3Storage = [JFTextStorage storageWithText:text];
//    [attriText2 jf_addImage:image];
//    [attriText2 jf_setFont:textFont];
//    [attriText2 jf_setTextColor:JFRGBAColor(0x27384b, 1)];
//    [attriText2 jf_setKern:3 atRange:NSMakeRange(image.index - 1, 1)];
//    [attriText2 jf_setLineSpacing:6];
//    [attriText2 jf_setTextColor:JFRGBAColor(0xef454b, 1) atRange:[attriText2.string rangeOfString:@"华丰"]];
//    JFTextLayout* layout3 = [JFTextLayout new];
//    layout3.insets = UIEdgeInsetsMake(10, 10, 10, 10);
//    layout3.lelf = layout2.lelf;
//    layout3.top = layout2.bottom + 20;
//    layout3.width = layout.width;
//    layout3.height = 2000;
//    layout3.text = attriText2;
//    layout3.backgroundColor = JFRGBAColor(0xf0f0f0, 1);
//    layout3.numberOfLines = 2;
//    JFLabel* label3 = [JFLabel new];
//    [self.view addSubview:label3];
//    label3.textLayout = layout3;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

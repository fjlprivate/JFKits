//
//  TestTextKit.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/9.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "TestTextKit.h"
#import "JFKit.h"

@interface TestTextKit ()

@end

@implementation TestTextKit

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(10, 100, JFSCREEN_WIDTH - 20, 200);
    
    // -- text container
    NSTextContainer* textContainer = [[NSTextContainer alloc] initWithSize:frame.size];
    textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    textContainer.maximumNumberOfLines = 4;
    
    // -- text layout
    NSLayoutManager* layout = [NSLayoutManager new];
    [layout addTextContainer:textContainer];
    
    // -- text storage
    NSString* text = @"MyTableViewCellInset被定义为一个常量，所以我们可以将它用在table view的delegate的高度计算中。最简单、准确计算高度的方法是将字符串转换成带属性的字符串，然后计算出带属性字符串的高度。";
    NSRange allRange = NSMakeRange(0, text.length);
    NSTextStorage* textStorage = [[NSTextStorage alloc] initWithString:text];
    // 字体
    [textStorage addAttribute:NSFontAttributeName value:JFFontWithName(@"Heiti SC", 17) range:allRange];
    // 字颜色
    [textStorage addAttribute:NSForegroundColorAttributeName value:JFRGBAColor(0x27384b, 1) range:allRange];
    // 字背景色
    // 段落
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.lineSpacing = 2;
    para.firstLineHeadIndent = 20;
    [textStorage addAttribute:NSParagraphStyleAttributeName value:para range:allRange];
    // 添加layout
    [textStorage addLayoutManager:layout];
    
    CGRect newFrame = [layout usedRectForTextContainer:textContainer];
    
    UITextView* textView = [[UITextView alloc] initWithFrame:frame textContainer:textContainer];
    textView.backgroundColor = JFRGBAColor(0, 0.2);
    frame.size.height = CGRectGetMaxY(newFrame);
    textView.frame = frame;
    [self.view addSubview:textView];
    
    /// 测试 UIView的布局支持
    UIView* view1 = [UIView new];
    view1.backgroundColor = [UIColor orangeColor];
    view1.top = textView.bottom + 20;
    view1.left = textView.left;
    view1.width = textView.width * 0.5;
    view1.height = 54;
    [self.view addSubview:view1];
    
    UIView* view2 = [UIView new];
    view2.backgroundColor = JFRGBAColor(0xef454b, 1);
    view2.height = view1.height * 0.618;
    view2.centerY = view1.centerY;
    view2.left = view1.right + 20;
    view2.right = JFSCREEN_WIDTH - 20;
    [self.view addSubview:view2];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//
//  TestAsyncDisplayLayer.m
//  JFKit
//
//  Created by warmjar on 2017/7/10.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestAsyncDisplayLayer.h"
#import "JFKit.h"
#import "AsyncDView.h"
#import "AsyncGView.h"
#import "Gallop.h"
#import "JFTextAttachment.h"


@interface TestAsyncDisplayLayer ()
@property (nonatomic, strong) AsyncDView* asyncDView;
@property (nonatomic, strong) AsyncGView* asyncGView;
@property (nonatomic, strong) JFButton* displayBtn;
@end

@implementation TestAsyncDisplayLayer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.displayBtn.centerX = self.view.centerX;
    self.displayBtn.centerY = JFSCREEN_HEIGHT * 0.5;
    self.displayBtn.width = 140;
    self.displayBtn.height = 44;
    [self.view addSubview:self.displayBtn];
    
    self.asyncDView.width = JFSCREEN_WIDTH * 0.618;
    self.asyncDView.height = self.asyncDView.width;
    self.asyncDView.centerX = self.view.centerX;
    self.asyncDView.centerY = self.displayBtn.bottom + 15 + self.asyncDView.height * 0.5;
    [self.view addSubview:self.asyncDView];
    
    [self.asyncDView.layer setNeedsDisplay];
    
    
    self.asyncGView.width = JFSCREEN_WIDTH * 0.618;
    self.asyncGView.height = self.asyncGView.width;
    self.asyncGView.centerX = self.view.centerX;
    self.asyncGView.centerY = self.displayBtn.top - 15 - self.asyncGView.height * 0.5;
    [self.view addSubview:self.asyncGView];
    
    [self.asyncGView.layer setNeedsDisplay];
    
    
    
    LWLayout* layout = [LWLayout new];
    NSMutableAttributedString* attri = [[NSMutableAttributedString alloc] initWithString:@"文本3和文本4"];
    [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, 7)];
    [attri addAttribute:NSForegroundColorAttributeName value:JFHexColor(0x00a1dc, 1) range:NSMakeRange(0, 7)];
    
    JFTextAttachment* attachment = [JFTextAttachment new];
    attachment.range = NSMakeRange(0, 1);
    attachment.contents = [[UIImage imageNamed:@"selectedBlue"] copy];
    attachment.contentSize = CGSizeMake(20, 20);
    attachment.frame = CGRectMake(0, 0, 20, 20);
    [attri addAttribute:JFTextAttachmentName value:attachment range:NSMakeRange(0, 1)];
    
    LWTextStorage* tstorage = [LWTextStorage lw_textStorageWithText:attri frame:CGRectMake(10, 10, 100, 40)];
    [layout addStorage:tstorage];
    
    LWAsyncDisplayView* aaaav = [[LWAsyncDisplayView alloc] init];
    aaaav.left = 15;
    aaaav.right = JFSCREEN_WIDTH - 15;
    aaaav.top = self.asyncDView.bottom + 5;
    aaaav.bottom = aaaav.top + 40;
    aaaav.layout = layout;
    [self.view addSubview:aaaav];
    
    
    
    
    NSMutableArray* testArray = [NSMutableArray array];
    [testArray addObject:attachment];
    
    
    
    
}


# pragma mask 4

- (AsyncDView *)asyncDView {
    if (!_asyncDView) {
        _asyncDView = [[AsyncDView alloc] init];
        _asyncDView.backgroundColor = JFHexColor(0x00a1dc, 1);
    }
    return _asyncDView;
}

- (AsyncGView *)asyncGView {
    if (!_asyncGView) {
        _asyncGView = [[AsyncGView alloc] init];
    }
    return _asyncGView;
}

- (JFButton *)displayBtn {
    if (!_displayBtn) {
        _displayBtn = [[JFButton alloc] init];
        _displayBtn.backgroundColor = JFHexColor(0x27384b, 1);
        [_displayBtn setTitle:@"加载异步显示视图图层" forState:UIControlStateNormal];
        [_displayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_displayBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        
    }
    return _displayBtn;
}


@end

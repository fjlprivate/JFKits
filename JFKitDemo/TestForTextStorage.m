//
//  TestForTextStorage.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/14.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "TestForTextStorage.h"
#import "JFKit.h"
#import <CoreText/CoreText.h>
#import "JFTextLayout.h"


@interface ViewForTestStorage : UIView <JFAsyncDisplayDelegate>
@property (nonatomic, strong) JFTextStorage* textStorage;
@end

@implementation ViewForTestStorage


- (instancetype)init {
    self = [super init];
    if (self) {
        NSString* text = @"轻轻的我走了，正如我轻轻地来。我招一招手，作别西天的云彩。";
        _textStorage = [JFTextStorage jf_textStorageWithText:text frame:CGRectMake(10, 10, 100, MAXFLOAT)];
        _textStorage.textFont = [UIFont systemFontOfSize:14];
        _textStorage.textColor = JFHexColor(0x27384b, 1);
        [_textStorage setBackgroundColor:JFHexColor(0x00a1dc, 1) atRange:[text rangeOfString:@"我招一招手"]];

    }
    return self;
}

+ (Class)layerClass {
    return [JFAsyncDisplayLayer class];
}

- (JFAsyncDisplayCallBacks*) asyncDisplayCallBacks {
    JFAsyncDisplayCallBacks* callBack = [JFAsyncDisplayCallBacks new];
    __weak typeof(self) wself = self;
    callBack.willDisplay = ^(JFAsyncDisplayLayer *layer) {
        layer.backgroundColor = JFHexColor(0xe0e0e0, 1).CGColor;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.displayedAsyncchronous = YES;
    };
    
    callBack.display = ^(CGContextRef context, CGSize size, IsCanceled isCanceled) {
        __strong typeof(wself) sself = wself;
        [sself.textStorage drawInContext:context isCanceled:isCanceled];
    };
    
    callBack.didDisplayed = ^(JFAsyncDisplayLayer *layer, BOOL finished) {
        
    };
    
    return callBack;
}

# pragma mask 4 getter 


@end





@interface TestForTextStorage ()

@end

@implementation TestForTextStorage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    ViewForTestStorage* testV1 = [ViewForTestStorage new];
    testV1.left = 30;
    testV1.right = JFSCREEN_WIDTH - 30;
    testV1.top = 64 + 15;
    testV1.bottom = testV1.top + 140;
    [self.view addSubview:testV1];
    
    [testV1.layer setNeedsDisplay];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

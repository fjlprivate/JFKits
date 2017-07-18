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
@property (nonatomic, strong) JFTextStorage* tStorage2;
@property (nonatomic, strong) JFTextStorage* tStorage3;
@end

@implementation ViewForTestStorage


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = JFHexColor(0, 0.05);
        NSString* text = @"轻轻的我走了，正如我轻轻地来。我招一招手，作别西天的云彩。";
        _textStorage = [JFTextStorage jf_textStorageWithText:text frame:CGRectMake(10, 10, 120, 1000) insets:CGSizeMake(4, 4)];
        _textStorage.textFont = [UIFont systemFontOfSize:16];
        _textStorage.textColor = JFHexColor(0x27384b, 1);
        _textStorage.backgroundColor = JFHexColor(0xe0e0e0, 1);
        _textStorage.lineSpace = 3;
        [_textStorage setAttribute:NSKernAttributeName withValue:@(1.5) atRange:NSMakeRange(0, text.length)];
        _textStorage.debugMode = YES;
        [_textStorage setBackgroundColor:JFHexColor(0x00a1dc, 1) atRange:[text rangeOfString:@"我招一招手"]];
        [_textStorage setImage:[UIImage imageNamed:@"selectedBlue"] imageSize:CGSizeMake(30, 30) atPosition:7];
        
        NSString* tttt = @"jsdxcojljsdfukljdfndjfajdslfsadfasdjmnas;lkdjfahsdfkajbd";
        _tStorage2 = [JFTextStorage jf_textStorageWithText:tttt frame:CGRectMake(120 + 20, 10, 120, 1000) insets:CGSizeMake(10, 10)];
        _tStorage2.textFont = [UIFont boldSystemFontOfSize:18];
        _tStorage2.textColor = JFHexColor(0x00a1dc, 1);
        _tStorage2.numberOfLines = 2;
        _tStorage2.lineSpace = 5;
        _tStorage2.kernSpace = 5;
        _tStorage2.backgroundColor = JFHexColor(0xe0e0e0, 1);
        _tStorage2.debugMode = YES;
        [_tStorage2 setBackgroundColor:JFHexColor(0xef454b, 1) atRange:[tttt rangeOfString:@"jljsdf"]];
        [_tStorage2 setBackgroundColor:JFHexColor(0x999999, 1) atRange:[tttt rangeOfString:@"jdslfsadfasdj"]];

        NSString* t3 = @"aaaaaa";
        _tStorage3 = [JFTextStorage jf_textStorageWithText:t3 frame:CGRectMake(_textStorage.left, _textStorage.bottom + 10, 160, 100) insets:CGSizeZero];
        _tStorage3.textFont = [UIFont systemFontOfSize:18];
        _tStorage3.textColor = JFHexColor(0x00a1dc, 1);
        _tStorage3.backgroundColor = JFHexColor(0, 0.1);
        _tStorage3.numberOfLines = 2;
        _tStorage3.debugMode = YES;

        
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
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.displayedAsyncchronous = YES;
    };
    
    callBack.display = ^(CGContextRef context, CGSize size, IsCanceled isCanceled) {
        __strong typeof(wself) sself = wself;
        [sself.textStorage drawInContext:context isCanceled:isCanceled];
        [sself.tStorage2 drawInContext:context isCanceled:isCanceled];
        [sself.tStorage3 drawInContext:context isCanceled:isCanceled];
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
    testV1.bottom = JFSCREEN_HEIGHT - 64 - 40;
    [self.view addSubview:testV1];
    
    [testV1.layer setNeedsDisplay];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//
//  SystemLabel.m
//  JFKitDemo
//
//  Created by LiChong on 2018/1/9.
//  Copyright © 2018年 JohnnyFeng. All rights reserved.
//

#import "SystemLabel.h"

@implementation SystemLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect subFrame = frame;
        subFrame.origin.y = 0;
        subFrame.size.height = 32;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:subFrame];
        titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        NSString* text = @"标题1:也可以长一点";
//        titleLabel.text = @"标题1:也可以长一点";
        NSMutableAttributedString* attriText = [[NSMutableAttributedString alloc] initWithString:text];
        [attriText addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, 5)];
//        [attriText addAttribute:NSStrokeWidthAttributeName value:@(2) range:NSMakeRange(0, 5)];
        titleLabel.attributedText = attriText;
        [self addSubview:titleLabel];
        subFrame.origin.y += subFrame.size.height;
        UILabel * titleLabel2 = [[UILabel alloc] initWithFrame:subFrame];
        titleLabel2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        titleLabel2.text = @"标题2:短了不好看";
        [self addSubview:titleLabel2];
        subFrame.origin.y += subFrame.size.height;
        UILabel * contentLabel = [[UILabel alloc] initWithFrame:subFrame];
        contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        contentLabel.text = @"正文：写多一点字";
        [self addSubview:contentLabel];
        subFrame.origin.y += subFrame.size.height;
        UILabel * footLabel = [[UILabel alloc] initWithFrame:subFrame];
        footLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        footLabel.text = @"副本：一点点啦";
        [self addSubview:footLabel];
        [self logAllSystemFonts];
    }
    return self;
}

- (void) logAllSystemFonts {
    NSArray* familyNames = [UIFont familyNames];
    NSMutableString* log = [NSMutableString new];
    [log appendString:@"\n"];
    for (NSString* familyName in familyNames) {
        [log appendFormat:@"\n--familyName[%@]--\n", familyName];
        NSArray* fonts = [UIFont fontNamesForFamilyName:familyName];
        for (NSString* fontName in fonts) {
            [log appendFormat:@"  :fontName[%@]\n", fontName];
        }
    }
    NSLog(@"%@", log.copy);
}

@end

//
//  APTransHashHeaderLayouts.m
//  AntPocket
//
//  Created by 严美 on 2019/10/9.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import "APTransHashHeaderLayouts.h"
#import "JFKit.h"

@implementation APTransHashHeaderLayouts



- (instancetype) initQuanwenLayouts {
    if (self = [super init]) {
        JFTextStorage* storage = [JFTextStorage storageWithText:@"我们现在有一种很怪异的实现方式，就是不管是中文，英文还是jhiy中英文混合的，在字体大小确定的情况下，设定每一行的高度为一个固定值，这样子在绘制的时候一行一行的去CTLineDraw绘制，绘制之前再微调Y值，反正每一行的行高都是确定的，绘制起来也方便，只是感觉这种方式怪怪的，非主流。"];
        storage.font = JFSystemFont(14);
        storage.textColor = JFRGBAColor(0x333333, 1);
        storage.lineSpacing = 3;
        
        
        // icon_robot_orange
        JFTextAttachmentImage* img1 = [JFTextAttachmentImage new];
        img1.image = [UIImage imageNamed:@"icon_robot_orange"];
        img1.imageSize = CGSizeMake(JFScaleWidth6(14), JFScaleWidth6(14));
        img1.index = 4;
        img1.kern = 1;
//        img1.backgroundColor = JFRGBAColor(0x333333, 1);
        [storage addImage:img1];
        // icon_tool
        JFTextAttachmentImage* img2 = [JFTextAttachmentImage new];
        img2.image = [UIImage imageNamed:@"icon_tool"];
        img2.imageSize = CGSizeMake(JFScaleWidth6(13), JFScaleWidth6(13));
        img2.index = 33;
        img2.kern = 1;
        [storage addImage:img2];
        // personal_icon_attention
        JFTextAttachmentImage* img3 = [JFTextAttachmentImage new];
        img3.image = [UIImage imageNamed:@"personal_icon_attention"];
        img3.imageSize = CGSizeMake(JFScaleWidth6(13), JFScaleWidth6(13));
        img3.index = 50;
        img3.kern = 1;
        [storage addImage:img3];
        // detail_icon_collection_selected
        JFTextAttachmentImage* img4 = [JFTextAttachmentImage new];
        img4.image = [UIImage imageNamed:@"detail_icon_collection_selected"];
        img4.imageSize = CGSizeMake(JFScaleWidth6(30), JFScaleWidth6(30));
        img4.index = 100;
        [storage addImage:img4];

        
        JFTextAttachmentHighlight* highlight = [JFTextAttachmentHighlight new];
        NSRange range = [storage.text.string rangeOfString:@"就是不管是中文"];
        highlight.range = range;
        highlight.normalTextColor = JFColorWhite;
        highlight.highlightTextColor = JFColorWhite;
        highlight.normalBackgroundColor = JFColorOrange;
        highlight.highlightBackgroundColor = JFRGBAColor(0x666666, 1);
        [storage addHighlight:highlight];

        
//        storage.kern = 0.2;
        JFTextLayout* layout = [JFTextLayout textLayoutWithText:storage];
        layout.numberOfLines = 4;
        layout.showMoreActColor = JFColorOrange.copy;
        layout.top = JFScaleWidth6(15);
        layout.left = JFScaleWidth6(15);
        layout.width = JFSCREEN_WIDTH - JFScaleWidth6(15 * 2);
        layout.height = 1000;
        layout.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
        [self addLayout:layout];
        
        self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, layout.bottom + JFScaleWidth6(13));
        
        
    }
    return self;
}
// 展开全文
- (void) spreadUp {
    for (JFTextLayout* textLayout in self.layouts) {
        textLayout.shouldShowMoreAct = NO;
        textLayout.numberOfLines = 0;
        textLayout.height = 1000;
        self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, textLayout.bottom + JFScaleWidth6(13));
    }
}


@end
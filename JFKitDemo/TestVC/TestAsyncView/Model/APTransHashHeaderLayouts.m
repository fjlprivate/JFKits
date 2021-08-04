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

- (instancetype) initImageTextLayouts {
    if (self = [super init]) {
        CGFloat bottom = 0;
        
        JFTextStorage* storage = [JFTextStorage storageWithText:@"我们"];
        storage.font = JFSystemFont(14);
        storage.textColor = JFRGBAColor(0x333333, 1);
        storage.lineSpacing = 3;
        JFTextLayout* telayout = [JFTextLayout textLayoutWithText:storage];
        telayout.top = bottom + JFScaleWidth6(15);
        telayout.left = JFScaleWidth6(15);
        telayout.width = JFSCREEN_WIDTH;
        telayout.height = 100;
        [self addLayout:telayout];
        bottom = telayout.bottom;


        JFImageLayout* image3 = [JFImageLayout new];
        image3.image = JFImageNamed(@"icon_robot_orange");
        image3.width = image3.height = JFScaleWidth6(16);
        image3.left = telayout.right + JFScaleWidth6(5);
        image3.centerY = telayout.centerY;
//        image3.top = JFScaleWidth6(8);
//        image3.tag = 3;
        [self addLayout:image3];
        if (bottom < image3.bottom) {
            bottom = image3.bottom;
        }
        
        JFTextStorage* storage1 = [JFTextStorage storageWithText:@"奥士大夫"];
        storage1.font = JFSystemFont(14);
        storage1.textColor = JFRGBAColor(0x333333, 1);
        storage1.lineSpacing = 3;
        JFTextLayout* telayout1 = [JFTextLayout textLayoutWithText:storage1];
//        telayout1.top = bottom + JFScaleWidth6(15);
        telayout1.left = image3.right + JFScaleWidth6(5);
        telayout1.width = JFSCREEN_WIDTH;
        telayout1.height = 100;
        telayout1.centerY = telayout.centerY;
        [self addLayout:telayout1];
        bottom = telayout1.bottom;

        self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, bottom + JFScaleWidth6(15));

    }
    return self;
}

- (instancetype) initQuanwenLayouts {
    if (self = [super init]) {
        CGFloat bottom = 0;
        
        JFImageLayout* image3 = [JFImageLayout new];
        image3.image = JFImageNamed(@"icon_tool");
        image3.width = image3.height = JFScaleWidth6(20);
        image3.left = JFScaleWidth6(15);
        image3.top = JFScaleWidth6(8);
        image3.tag = 3;
        [self addLayout:image3];
        if (bottom < image3.bottom) {
            bottom = image3.bottom;
        }

        
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

        //
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
        layout.top = bottom + JFScaleWidth6(15);
        layout.left = JFScaleWidth6(15);
        layout.width = JFSCREEN_WIDTH - JFScaleWidth6(15 * 2);
        layout.height = 1000;
        layout.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
        [self addLayout:layout];
        bottom = layout.bottom;
        
        
        JFImageLayout* image1 = [JFImageLayout new];
        image1.image = JFImageNamed(@"personal_icon_attention");
        image1.width = image1.height = JFScaleWidth6(20);
        image1.left = JFScaleWidth6(15);
        image1.top = layout.bottom + JFScaleWidth6(8);
        image1.tag = 1;
        [self addLayout:image1];
        if (bottom < image1.bottom) {
            bottom = image1.bottom;
        }
        
        JFImageLayout* image2 = [JFImageLayout new];
        image2.image = JFImageNamed(@"detail_icon_collection_selected");
        image2.width = image2.height = JFScaleWidth6(20);
        image2.left = JFScaleWidth6(15 + 20 + 15);
        image2.top = layout.bottom + JFScaleWidth6(8 + 4);
        image2.tag = 2;
        [self addLayout:image2];
        if (bottom < image2.bottom) {
            bottom = image2.bottom;
        }

        
        self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, bottom + JFScaleWidth6(13));
        
        
    }
    return self;
}
// 展开全文
- (void) spreadUp {
    CGFloat bottom = 0;
    for (JFTextLayout* textLayout in self.layouts) {
        if ([textLayout isKindOfClass:[JFTextLayout class]]) {
//            textLayout.shouldShowMoreAct = YES;
            textLayout.numberOfLines = 0;
            textLayout.height = 1000;
            bottom = textLayout.bottom;
        }
    }
    for (JFImageLayout* image in self.layouts) {
        if ([image isKindOfClass:[JFImageLayout class]] && image.tag < 3) {
            image.top = bottom + JFScaleWidth6(8 * image.tag * 2);
        }
    }
    
    self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, bottom + JFScaleWidth6(20 + 8 + 4) + JFScaleWidth6(13));
}

// 收起
- (void) spreadDown {
    CGFloat bottom = 0;
    for (JFTextLayout* textLayout in self.layouts) {
        if ([textLayout isKindOfClass:[JFTextLayout class]]) {
//            textLayout.shouldShowMoreAct = NO;
            textLayout.numberOfLines = 4;
            textLayout.height = 1000;
            bottom = textLayout.bottom;
        }
    }
    for (JFImageLayout* image in self.layouts) {
        if ([image isKindOfClass:[JFImageLayout class]] && image.tag < 3) {
            image.top = bottom + JFScaleWidth6(8 * image.tag * 2);
        }
    }
    
    self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, bottom + JFScaleWidth6(20 + 8 + 4) + JFScaleWidth6(13));
}


- (instancetype) initWithJsonNode {
    if (self = [super init]) {
        NSDictionary* model = [self modelJson];
        CGFloat bottom = 0;
        // 交易hash : trx_id
        JFTextStorage* s_trxIdT = [JFTextStorage storageWithText:@"交易hash"];
        s_trxIdT.font = JFSystemFont(14);
        s_trxIdT.textColor = JFRGBAColor(0xB3B3B3, 1);
        s_trxIdT.backgroundColor = JFColorWhite;
        JFTextLayout* t_trxIdT = [JFTextLayout textLayoutWithText:s_trxIdT];
        t_trxIdT.top = JFScaleWidth6(35);
        t_trxIdT.left = JFScaleWidth6(15);
        t_trxIdT.width = 200;
        t_trxIdT.height = 50;
        [self addLayout:t_trxIdT];
        bottom = t_trxIdT.bottom;
        // 交易hash : trx_id
        NSString* trx_id = [NSString stringWithFormat:@"%@", model[@"trx_id"]];
        if (!IsNon(trx_id)) {
            JFTextStorage* s_trxId = [JFTextStorage storageWithText:trx_id];
            s_trxId.font = JFSystemFont(JFScaleWidth6(14));
            s_trxId.textColor = JFRGBAColor(0x333333, 1);
            s_trxId.backgroundColor = JFColorWhite;
            s_trxId.textAlignment = NSTextAlignmentRight;
            JFTextLayout* t_trxId = [JFTextLayout textLayoutWithText:s_trxId];
            t_trxId.insets = UIEdgeInsetsMake(JFScaleWidth6(0), JFScaleWidth6(0), JFScaleWidth6(0), JFScaleWidth6(2));
            t_trxId.width = JFScaleWidth6(231);
            t_trxId.height = 200;
            t_trxId.top = t_trxIdT.top;
            t_trxId.left = JFSCREEN_WIDTH - t_trxId.width - JFScaleWidth6(15);
            t_trxId.numberOfLines = 0;
            [self addLayout:t_trxId];
            if (bottom < t_trxId.bottom) {
                bottom = t_trxId.bottom;
            }
        }
        // 区块时间 : createdAt
        JFTextStorage* s_createdAtT = [JFTextStorage storageWithText:NSLocalizedString(@"区块时间", nil)];
        s_createdAtT.font = JFSystemFont(JFScaleWidth6(14));
        s_createdAtT.textColor = JFRGBAColor(0xB3B3B3, 1);
        s_createdAtT.backgroundColor = JFColorWhite;
        JFTextLayout* t_createdAtT = [JFTextLayout textLayoutWithText:s_createdAtT];
        t_createdAtT.top = bottom + JFScaleWidth6(15);
        t_createdAtT.left = JFScaleWidth6(15);
        t_createdAtT.width = 200;
        t_createdAtT.height = 50;
        [self addLayout:t_createdAtT];
        if (bottom < t_createdAtT.bottom) {
            bottom = t_createdAtT.bottom;
        }
        // 区块时间 : createdAt
        NSString* createdAt = [NSString stringWithFormat:@"%@", model[@"createdAt"]];
        if (!IsNon(createdAt)) {
            createdAt = [[NSDate dateWithTimeIntervalSince1970:createdAt.doubleValue / 1000.f] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            JFTextStorage* s_createdAt = [JFTextStorage storageWithText:createdAt];
            s_createdAt.font = JFSystemFont(JFScaleWidth6(14));
            s_createdAt.textColor = JFRGBAColor(0x333333, 1);
            s_createdAt.backgroundColor = JFColorWhite;
            JFTextLayout* t_createdAt = [JFTextLayout textLayoutWithText:s_createdAt];
            t_createdAt.width = JFSCREEN_WIDTH;
            t_createdAt.height = 200;
            t_createdAt.centerY = t_createdAtT.centerY;
            t_createdAt.left = JFSCREEN_WIDTH - t_createdAt.width - JFScaleWidth6(15);
            t_createdAt.numberOfLines = 0;
            [self addLayout:t_createdAt];
            if (bottom < t_createdAt.bottom) {
                bottom = t_createdAt.bottom;
            }
        }
        // 过期时间 : expiration
        JFTextStorage* s_expirationT = [JFTextStorage storageWithText:NSLocalizedString(@"过期时间", nil)];
        s_expirationT.font = JFSystemFont(JFScaleWidth6(14));
        s_expirationT.textColor = JFRGBAColor(0xB3B3B3, 1);
        s_expirationT.backgroundColor = JFColorWhite;
        JFTextLayout* t_expirationT = [JFTextLayout textLayoutWithText:s_expirationT];
        t_expirationT.top = bottom + JFScaleWidth6(15);
        t_expirationT.left = JFScaleWidth6(15);
        t_expirationT.width = 200;
        t_expirationT.height = 50;
        [self addLayout:t_expirationT];
        if (bottom < t_expirationT.bottom) {
            bottom = t_expirationT.bottom;
        }
        // 过期时间 : expiration
        NSString* expiration = [NSString stringWithFormat:@"%@", model[@"expiration"]];
        if (!IsNon(expiration)) {
            JFTextStorage* s_expiration = [JFTextStorage storageWithText:expiration];
            s_expiration.font = JFSystemFont(JFScaleWidth6(14));
            s_expiration.textColor = JFRGBAColor(0x333333, 1);
            s_expiration.backgroundColor = JFColorWhite;
            JFTextLayout* t_expiration = [JFTextLayout textLayoutWithText:s_expiration];
            t_expiration.width = JFSCREEN_WIDTH;
            t_expiration.height = 200;
            t_expiration.centerY = t_expirationT.centerY;
            t_expiration.left = JFSCREEN_WIDTH - t_expiration.width - JFScaleWidth6(15);
            t_expiration.numberOfLines = 0;
            [self addLayout:t_expiration];
            if (bottom < t_expiration.bottom) {
                bottom = t_expiration.bottom;
            }
        }
        // 状态
        JFTextStorage* s_stateT = [JFTextStorage storageWithText:NSLocalizedString(@"状态", nil)];
        s_stateT.font = JFSystemFont(JFScaleWidth6(14));
        s_stateT.textColor = JFRGBAColor(0xB3B3B3, 1);
        s_stateT.backgroundColor = JFColorWhite;
        JFTextLayout* t_stateT = [JFTextLayout textLayoutWithText:s_stateT];
        t_stateT.top = bottom + JFScaleWidth6(15);
        t_stateT.left = JFScaleWidth6(15);
        t_stateT.width = 200;
        t_stateT.height = 50;
        [self addLayout:t_stateT];
        if (bottom < t_stateT.bottom) {
            bottom = t_stateT.bottom;
        }
        
        JFTextStorage* s_state1 = [JFTextStorage storageWithText:NSLocalizedString(@"不可逆", nil)];
        s_state1.font = JFSystemFont(JFScaleWidth6(12));
        s_state1.textColor = JFColorWhite;
        JFTextLayout* t_state1 = [JFTextLayout textLayoutWithText:s_state1];
        t_state1.borderColor = s_state1.backgroundColor;
        t_state1.backgroundColor = JFRGBAColor(0x0AA3D1, 1);
        t_state1.insets = UIEdgeInsetsMake(JFScaleWidth6(2), JFScaleWidth6(10), JFScaleWidth6(3), JFScaleWidth6(10));
        t_state1.width = 200;
        t_state1.height = 50;
        t_state1.centerY = t_stateT.centerY;
        t_state1.left = JFSCREEN_WIDTH - JFScaleWidth6(15) - t_state1.width;
        t_state1.cornerRadius = CGSizeMake(t_state1.height * 0.5, t_state1.height * 0.5);
        [self addLayout:t_state1];

        JFTextStorage* s_state2 = [JFTextStorage storageWithText:NSLocalizedString(@"已执行", nil)];
        s_state2.font = JFSystemFont(JFScaleWidth6(12));
        s_state2.textColor = JFColorWhite;
        JFTextLayout* t_state2 = [JFTextLayout textLayoutWithText:s_state2];
        t_state2.borderColor = s_state2.backgroundColor;
        t_state2.backgroundColor = JFRGBAColor(0x13BD68, 1);
        t_state2.insets = UIEdgeInsetsMake(JFScaleWidth6(2), JFScaleWidth6(10), JFScaleWidth6(3), JFScaleWidth6(10));
        t_state2.width = 200;
        t_state2.height = 50;
        t_state2.centerY = t_stateT.centerY;
        t_state2.left = t_state1.left - JFScaleWidth6(13) - t_state2.width;
        t_state2.cornerRadius = CGSizeMake(t_state2.height * 0.5, t_state2.height * 0.5);
        [self addLayout:t_state2];

        // 所在区块 : block_num
        JFTextStorage* s_block_numT = [JFTextStorage storageWithText:NSLocalizedString(@"所在区块", nil)];
        s_block_numT.font = JFSystemFont(JFScaleWidth6(14));
        s_block_numT.textColor = JFRGBAColor(0xB3B3B3, 1);
        s_block_numT.backgroundColor = JFColorWhite;
        JFTextLayout* t_block_numT = [JFTextLayout textLayoutWithText:s_block_numT];
        t_block_numT.top = bottom + JFScaleWidth6(15);
        t_block_numT.left = JFScaleWidth6(15);
        t_block_numT.width = 200;
        t_block_numT.height = 50;
        [self addLayout:t_block_numT];
        if (bottom < t_block_numT.bottom) {
            bottom = t_block_numT.bottom;
        }
        // 所在区块 : block_num
        NSString* block_num = [NSString stringWithFormat:@"%@", model[@"block_num"]];
        if (!IsNon(block_num)) {
            JFTextStorage* s_block_num = [JFTextStorage storageWithText:block_num];
            s_block_num.font = JFSystemFont(JFScaleWidth6(14));
            s_block_num.textColor = JFRGBAColor(0x333333, 1);
            s_block_num.backgroundColor = JFColorWhite;
            JFTextLayout* t_block_num = [JFTextLayout textLayoutWithText:s_block_num];
            t_block_num.width = JFSCREEN_WIDTH;
            t_block_num.height = 200;
            t_block_num.centerY = t_block_numT.centerY;
            t_block_num.left = JFSCREEN_WIDTH - t_block_num.width - JFScaleWidth6(15);
            [self addLayout:t_block_num];
            if (bottom < t_block_num.bottom) {
                bottom = t_block_num.bottom;
            }
        }

        // 区块hash : block_id
        JFTextStorage* s_block_idT = [JFTextStorage storageWithText:NSLocalizedString(@"区块Hash", nil)];
        s_block_idT.font = JFSystemFont(JFScaleWidth6(14));
        s_block_idT.textColor = JFRGBAColor(0xB3B3B3, 1);
        s_block_idT.backgroundColor = JFColorWhite;
        JFTextLayout* t_block_idT = [JFTextLayout textLayoutWithText:s_block_idT];
        t_block_idT.top = bottom + JFScaleWidth6(15);
        t_block_idT.left = JFScaleWidth6(15);
        t_block_idT.width = 200;
        t_block_idT.height = 50;
        [self addLayout:t_block_idT];
        bottom = t_block_idT.bottom;
        // 区块hash : block_id
        NSString* block_id = [NSString stringWithFormat:@"%@", model[@"block_id"]];
        if (!IsNon(block_id)) {
            JFTextStorage* s_block_id = [JFTextStorage storageWithText:block_id];
            s_block_id.font = JFSystemFont(JFScaleWidth6(14));
            s_block_id.textColor = JFRGBAColor(0x333333, 1);
            s_block_id.backgroundColor = JFColorWhite;
            s_block_id.textAlignment = NSTextAlignmentRight;
            JFTextLayout* t_block_id = [JFTextLayout textLayoutWithText:s_block_id];
            t_block_id.insets = UIEdgeInsetsMake(JFScaleWidth6(0), JFScaleWidth6(0), JFScaleWidth6(0), JFScaleWidth6(2));
            t_block_id.width = JFScaleWidth6(231);
            t_block_id.height = 200;
            t_block_id.top = t_block_idT.top;
            t_block_id.left = JFSCREEN_WIDTH - t_block_id.width - JFScaleWidth6(15);
            t_block_id.numberOfLines = 0;
            [self addLayout:t_block_id];
            if (bottom < t_block_id.bottom) {
                bottom = t_block_id.bottom;
            }
        }
        
        bottom += JFScaleWidth6(35);
//        self.sectionFrame = CGRectMake(0, bottom, JFSCREEN_WIDTH, JFScaleWidth6(10));
        bottom += JFScaleWidth6(10);
        
        /**********分割线**********/
        
        // actions
        JFTextStorage* s_actionsT = [JFTextStorage storageWithText:NSLocalizedString(@"Actions", nil)];
        s_actionsT.font = JFSystemFont(JFScaleWidth6(16));
        s_actionsT.textColor = JFRGBAColor(0x333333, 1);
        s_actionsT.backgroundColor = JFColorWhite;
        JFTextLayout* t_actionsT = [JFTextLayout textLayoutWithText:s_actionsT];
        t_actionsT.top = bottom + JFScaleWidth6(15);
        t_actionsT.left = JFScaleWidth6(15);
        t_actionsT.width = 200;
        t_actionsT.height = 50;
        [self addLayout:t_actionsT];
        if (bottom < t_actionsT.bottom) {
            bottom = t_actionsT.bottom;
        }

//        self.lineFrame = CGRectMake(0, bottom + JFScaleWidth6(15), JFSCREEN_WIDTH, 0.5);
        bottom += JFScaleWidth6(15);
        
        NSDictionary* node = model[@"actions"][0][@"data"];
        if (node) {
            // from -> to   data[actions][0][data]   .from  .to  .quantity
            NSString* from = node[@"from"];
            if (IsNon(from)) {
                from = @"from";
            }
            JFTextStorage* sFrom = [JFTextStorage storageWithText:from];
            sFrom.font = JFSystemFont(JFScaleWidth6(16));
            sFrom.textColor = JFRGBAColor(0x0AA3D1, 1);
            sFrom.backgroundColor = JFColorWhite;
            JFTextLayout* tFrom = [JFTextLayout textLayoutWithText:sFrom];
            tFrom.top = bottom + JFScaleWidth6(23);
            tFrom.left = JFScaleWidth6(15);
            tFrom.width = 200;
            tFrom.height = 50;
            [self addLayout:tFrom];
            if (bottom < tFrom.bottom) {
                bottom = tFrom.bottom;
            }
            
            JFImageLayout* imgTo = [JFImageLayout new];
            imgTo.image = JFImageNamed(@"icon_robot_orange");
            imgTo.width = imgTo.height = JFScaleWidth6(10);
            imgTo.left = tFrom.right + JFScaleWidth6(10);
            imgTo.centerY = tFrom.centerY;
            imgTo.tag = 1;
            imgTo.backgroundColor = JFRGBAColor(0xcccccc, 1);
            [self addLayout:imgTo];

            NSString* to = node[@"to"];
            if (IsNon(to)) {
                to = @"to";
            }
            JFTextStorage* sTo = [JFTextStorage storageWithText:to];
            sTo.font = JFSystemFont(JFScaleWidth6(16));
            sTo.textColor = JFRGBAColor(0x0AA3D1, 1);
            sTo.backgroundColor = JFColorWhite;
            JFTextLayout* tTo = [JFTextLayout textLayoutWithText:sTo];
            tTo.width = 200;
            tTo.height = 50;
            tTo.left = imgTo.right + JFScaleWidth6(10);
            tTo.centerY = imgTo.centerY;
            [self addLayout:tTo];
            if (bottom < tTo.bottom) {
                bottom = tTo.bottom;
            }
            
            // quantity   data[actions][0][quantity]
            NSString* quantity = node[@"quantity"] ? [NSString stringWithFormat:@"%@", node[@"quantity"]] : nil;
            if (!IsNon(quantity)) {
                JFTextStorage* sQuantity = [JFTextStorage storageWithText:quantity];
                sQuantity.font = JFSystemFont(JFScaleWidth6(16));
                sQuantity.textColor = JFRGBAColor(0x333333, 1);
                sQuantity.backgroundColor = JFColorWhite;
                JFTextLayout* tQuantity = [JFTextLayout textLayoutWithText:sQuantity];
                tQuantity.width = 200;
                tQuantity.height = 50;
                tQuantity.left = JFScaleWidth6(15);
                tQuantity.top = bottom + JFScaleWidth6(8);
                [self addLayout:tQuantity];
                if (bottom < tQuantity.bottom) {
                    bottom = tQuantity.bottom;
                }
                
                // account : data[actions][0][account]
                NSString* account = model[@"actions"][0][@"account"] ? [NSString stringWithFormat:@"%@", model[@"actions"][0][@"account"]] : nil;
                if (!IsNon(account)) {
                    account = [@":" stringByAppendingString:account];
                    JFTextStorage* sAccount = [JFTextStorage storageWithText:account];
                    sAccount.font = JFSystemFont(JFScaleWidth6(11));
                    sAccount.textColor = JFRGBAColor(0xB3B3B3, 1);
                    sAccount.backgroundColor = JFColorWhite;
                    JFTextLayout* tAccount = [JFTextLayout textLayoutWithText:sAccount];
                    tAccount.width = 200;
                    tAccount.height = 50;
                    tAccount.left = tQuantity.right + JFScaleWidth6(2);
//                    tAccount.top = tQuantity.bottom - JFScaleWidth6(2) - tAccount.height;
                    tAccount.bottom = tQuantity.bottom - 1;
                    [self addLayout:tAccount];
                    if (bottom < tAccount.bottom) {
                        bottom = tAccount.bottom;
                    }
                }
            }

            // MEMO : data[actions][0][data]  .memo
            JFTextStorage* sMemoT = [JFTextStorage storageWithText:@"MEMO"];
            sMemoT.font = JFSystemFont(JFScaleWidth6(11));
            sMemoT.textColor = JFRGBAColor(0xB3B3B3, 1);
            JFTextLayout* tMemoT = [JFTextLayout textLayoutWithText:sMemoT];
            tMemoT.insets = UIEdgeInsetsMake(JFScaleWidth6(2), JFScaleWidth6(4), JFScaleWidth6(2), JFScaleWidth6(4));
            tMemoT.cornerRadius = CGSizeMake(JFScaleWidth6(2), JFScaleWidth6(2));
            tMemoT.backgroundColor = JFRGBAColor(0xF5F5F5, 1);
            tMemoT.top = bottom + JFScaleWidth6(15);
            tMemoT.left = JFScaleWidth6(15);
            tMemoT.width = 200;
            tMemoT.height = 50;
            [self addLayout:tMemoT];
            if (bottom < tMemoT.bottom) {
                bottom = tMemoT.bottom;
            }
            // MEMO : data[actions][0][data]  .memo
            NSString* memo = [NSString stringWithFormat:@"%@", node[@"memo"]];
            if (!IsNon(memo)) {
                JFTextStorage* sMemo = [JFTextStorage storageWithText:memo];
                sMemo.font = JFSystemFont(JFScaleWidth6(11));
                sMemo.textColor = JFRGBAColor(0x0AA3D1, 1);
                sMemo.backgroundColor = JFColorWhite;
                JFTextLayout* tMemo = [JFTextLayout textLayoutWithText:sMemo];
                tMemo.borderColor = JFRGBAColor(0x0AA3D1, 0.5);
                tMemo.borderWidth = 1;
                tMemo.cornerRadius = CGSizeMake(JFScaleWidth6(2), JFScaleWidth6(2));
                tMemo.insets = UIEdgeInsetsMake(JFScaleWidth6(2), JFScaleWidth6(4), JFScaleWidth6(2), JFScaleWidth6(4));
                tMemo.width = 200;
                tMemo.height = 200;
                tMemo.centerY = tMemoT.centerY;
                tMemo.left = tMemoT.right + JFScaleWidth6(5);
                [self addLayout:tMemo];
                if (bottom < tMemo.bottom) {
                    bottom = tMemo.bottom;
                }
            }

            
            // data[actions][0][data] 的信息
            JFTextStorage* sDatas = [JFTextStorage storageWithText:@"{\n"];
            sDatas.font = JFSystemFont(JFScaleWidth6(14));
            sDatas.textColor = JFRGBAColor(0xb3b3b3, 1);
            sDatas.backgroundColor = JFColorWhite;
            
            NSMutableAttributedString* attriDou = [[NSMutableAttributedString alloc] initWithString:@",\n" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xb3b3b3, 1)}];

            NSString* valueFrom = node[@"from"];
            if (!IsNon(valueFrom)) {
                NSMutableAttributedString* attriFromT = [[NSMutableAttributedString alloc] initWithString:@"  \"from\":" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xF04D4D, 1)}];
                NSMutableAttributedString* attriFromV = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", valueFrom] attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0x13BD68, 1)}];
                [sDatas.text appendAttributedString:attriFromT];
                [sDatas.text appendAttributedString:attriFromV];
                [sDatas.text appendAttributedString:attriDou];
            }
            NSString* valueTo = node[@"to"];
            if (!IsNon(valueTo)) {
                NSMutableAttributedString* attriToT = [[NSMutableAttributedString alloc] initWithString:@"  \"to\":" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xF04D4D, 1)}];
                NSMutableAttributedString* attriToV = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", valueTo] attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0x13BD68, 1)}];
                [sDatas.text appendAttributedString:attriToT];
                [sDatas.text appendAttributedString:attriToV];
                [sDatas.text appendAttributedString:attriDou];
            }
            
            if (!IsNon(quantity)) {
                NSMutableAttributedString* attriQuantityT = [[NSMutableAttributedString alloc] initWithString:@"  \"quantity\":" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xF04D4D, 1)}];
                NSMutableAttributedString* attriQuantityV = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", quantity] attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0x13BD68, 1)}];
                [sDatas.text appendAttributedString:attriQuantityT];
                [sDatas.text appendAttributedString:attriQuantityV];
                [sDatas.text appendAttributedString:attriDou];
            }
            
            NSString* quantityfee = node[@"quantityfee"] ? [NSString stringWithFormat:@"%@", node[@"quantityfee"]] : nil;
            if (!IsNon(quantityfee)) {
                NSMutableAttributedString* attriQuantityfeeT = [[NSMutableAttributedString alloc] initWithString:@"  \"quantityfee\":" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xF04D4D, 1)}];
                NSMutableAttributedString* attriQuantityfeeV = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", quantityfee] attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0x13BD68, 1)}];
                [sDatas.text appendAttributedString:attriQuantityfeeT];
                [sDatas.text appendAttributedString:attriQuantityfeeV];
                [sDatas.text appendAttributedString:attriDou];
            }

            if (!IsNon(memo)) {
                NSMutableAttributedString* attriMemoT = [[NSMutableAttributedString alloc] initWithString:@"  \"memo\":" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xF04D4D, 1)}];
                NSMutableAttributedString* attriMemoV = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", memo] attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0x13BD68, 1)}];
                [sDatas.text appendAttributedString:attriMemoT];
                [sDatas.text appendAttributedString:attriMemoV];
                [sDatas.text appendAttributedString:attriDou];
            }

            NSMutableAttributedString* attriWei = [[NSMutableAttributedString alloc] initWithString:@"}" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xb3b3b3, 1)}];
            [sDatas.text appendAttributedString:attriWei];
            JFTextLayout* tDatas = [JFTextLayout textLayoutWithText:sDatas];
            tDatas.numberOfLines = 0;
            tDatas.left = tMemoT.left;
            tDatas.top = bottom + JFScaleWidth6(8);
            tDatas.width = JFSCREEN_WIDTH;
            tDatas.height = JFSCREEN_WIDTH;
            [self addLayout:tDatas];
            if (bottom < tDatas.bottom) {
                bottom = tDatas.bottom;
            }
        }
        
        self.viewFrame = CGRectMake(0, 0, JFSCREEN_WIDTH, bottom + JFScaleWidth6(35));
        
    }
    return self;
}

- (NSDictionary*) modelJson {
    return @{
        @"_id" :     @{
            @"counter" : @11086435,
            @"date" : @1574759304000,
            @"machineIdentifier" : @15200843,
            @"processIdentifier" : @"-3787",
            @"time" : @1574759304000,
            @"timeSecond" : @1574759304,
            @"timestamp" : @1574759304,
        },
        @"accepted": @1,
        @"accountfee": @"<null>",
        @"actions":     @[
                    @{
                        @"account":  @"token.ike",
                        @"authorization":             @[
                                    @{
                                        @"actor": @"feng3",
                                        @"permission":@"active"
                    }
                ],
                        @"data" :             @{
                                @"from": @"feng3",
                                @"memo": @"",
                                @"quantity":  @"1.0000 IKEC",
                                @"to": @"zfff"
                },
                        @"hex_data": @"0000000080c1a65a0000000000b0d6fa102700000000000004494b454300000000",
                        @"name" : @"transfer"
            }
        ],
        @"blockTime":  @"2019-11-26 17:08:25",
        @"block_id" : @"01bbd5e129eacff75f28227a66cb669502b7018bfbd44e07cba87ccaf77a6e17",
        @"block_num" : @29087201,
        @"context_free_actions" :   @[],
        @"context_free_data" :@[],
        @"createdAt" : @1574759305010,
        @"delay_sec" : @0,
        @"expiration" : @"2019-11-26 17:08:54",
        @"implicit" : @0,
        @"irreversible" : @1,
        @"max_cpu_usage_ms" : @0,
        @"max_net_usage_words" : @0,
        @"quantityfee" : @0,
        @"ref_block_num" : @54751,
        @"ref_block_prefix" : @2873605315,
        @"scheduled" : @0,
        @"signatures" :     @[
        @"SIG_K1_KYnCHES93cyJEgo7yLo7F3dm592r2bHXwMrp1vaUtRAivgKy5KUcARNZvz5k2uuDGG6EDeFJ8Vo1ZvPw6L46RhEL4Vrh8G"
         ] ,
        @"signing_keys" :     @{
            @"0" : @"EOS7yH6mhApuHrX4qRSgF5e3MM3oK8SY1h2BcKhPVkmAZh2kG5ziA"
        },
        @"tradeCode":  @10012,
        @"transaction_extensions" :     @[],
        @"trx_id" :@"79bec808790f58e8f213e5f8ba098196c60ab0fedc3c20d51ed5c201811845c6",
        @"updatedAt" : @1574759329507
    };
}

@end

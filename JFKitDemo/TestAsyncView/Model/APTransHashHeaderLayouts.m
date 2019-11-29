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
- (instancetype) initWithModel:(NSDictionary*)model {
    if (self = [super init]) {
        CGFloat corner = 0;
        CGFloat bottom = 0;
        // 交易hash : trx_id
        JFTextStorage* s_trxIdT = [JFTextStorage storageWithText:NSLocalizedString(@"交易Hash", nil)];
        s_trxIdT.font = JFSystemFont(JFScaleWidth6(14));
        s_trxIdT.textColor = JFRGBAColor(0xB3B3B3, 1);
        JFTextLayout* t_trxIdT = [JFTextLayout textLayoutWithText:s_trxIdT];
//        t_trxIdT.backgroundColor = JFColorOrange;
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

            s_trxId.textAlignment = NSTextAlignmentRight;
            JFTextLayout* t_trxId = [JFTextLayout textLayoutWithText:s_trxId];
            t_trxId.backgroundColor = s_trxId.backgroundColor;
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
        JFTextLayout* t_createdAtT = [JFTextLayout textLayoutWithText:s_createdAtT];
        t_createdAtT.backgroundColor = s_createdAtT.backgroundColor;
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

            JFTextLayout* t_createdAt = [JFTextLayout textLayoutWithText:s_createdAt];
            t_createdAt.backgroundColor = s_createdAt.backgroundColor;
            t_createdAt.width = JFSCREEN_WIDTH;
            t_createdAt.height = 200;
            // center有问题
            t_createdAt.centerY = t_createdAtT.centerY;
            t_createdAt.right = JFSCREEN_WIDTH - JFScaleWidth6(15);
//            t_createdAt.debug = YES;
            CGFloat corner = t_createdAt.height * 0.5;
            t_createdAt.cornerRadius = CGSizeMake(corner, corner);

            [self addLayout:t_createdAt];
            if (bottom < t_createdAt.bottom) {
                bottom = t_createdAt.bottom;
            }
        }
         //过期时间 : expiration
        JFTextStorage* s_expirationT = [JFTextStorage storageWithText:NSLocalizedString(@"过期时间", nil)];
        s_expirationT.font = JFSystemFont(JFScaleWidth6(14));
        s_expirationT.textColor = JFRGBAColor(0xB3B3B3, 1);
//        s_expirationT.backgroundColor = JFColorOrange;
        JFTextLayout* t_expirationT = [JFTextLayout textLayoutWithText:s_expirationT];
//        t_expirationT.backgroundColor = JFColorOrange;
//        t_expirationT.insets = UIEdgeInsetsMake(3, 6, 3, 6);
//        t_expirationT.borderColor = JFColorOrange;
//        t_expirationT.borderWidth = 1;
//        t_expirationT.cornerRadius = CGSizeMake(2, 2);
        t_expirationT.top = bottom + JFScaleWidth6(15);
        t_expirationT.left = JFScaleWidth6(15);
        t_expirationT.width = 200;
        t_expirationT.height = 50;
//        CGFloat corner = t_expirationT.height * 0.5;
//        t_expirationT.cornerRadius = CGSizeMake(corner, corner);
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
            t_expiration.borderColor = JFColorOrange;
            t_expiration.borderWidth = 1;
//            t_expiration.cornerRadius = CGSizeMake(2, 2);
            t_expiration.width = JFSCREEN_WIDTH;
            t_expiration.height = 200;
            t_expiration.centerY = t_expirationT.centerY;
//            t_expiration.left = JFSCREEN_WIDTH - t_expiration.width - JFScaleWidth6(15);
            t_expiration.right = JFSCREEN_WIDTH - JFScaleWidth6(15);
            t_expiration.numberOfLines = 0;
//            t_expiration.debug = YES;
//            corner = t_expiration.height * 0.5;
//            t_expiration.cornerRadius = CGSizeMake(corner, corner);
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
        
        JFTextStorage* s_state2 = [JFTextStorage storageWithText:NSLocalizedString(@"已执行", nil)];
        s_state2.font = JFSystemFont(JFScaleWidth6(14));
        s_state2.textColor = JFColorWhite;
        JFTextLayout* t_state2 = [JFTextLayout textLayoutWithText:s_state2];
        t_state2.backgroundColor = JFRGBAColor(0x13BD68, 1);
        t_state2.insets = UIEdgeInsetsMake(JFScaleWidth6(3.35), JFScaleWidth6(10), JFScaleWidth6(3.35), JFScaleWidth6(10));
        t_state2.width = 200;
        t_state2.height = 50;
        t_state2.centerY = t_stateT.centerY;
        t_state2.right = JFSCREEN_WIDTH - JFScaleWidth6(15);
        NSLog(@"================t_state2.height[%.02lf]", t_state2.height);
        corner = t_state2.height * 0.5;
        t_state2.cornerRadius = CGSizeMake(corner, corner);
        [self addLayout:t_state2];


        JFTextStorage* s_state1 = [JFTextStorage storageWithText:NSLocalizedString(@"ffffffffff", nil)];
        s_state1.font = JFSystemFont(JFScaleWidth6(14));
        s_state1.textColor = JFColorWhite;
        JFTextLayout* t_state1 = [JFTextLayout textLayoutWithText:s_state1];
        t_state1.backgroundColor = JFRGBAColor(0x0AA3D1, 1);
//        t_state1.backgroundColor = JFColorOrange;
        t_state1.insets = UIEdgeInsetsMake(JFScaleWidth6(2), JFScaleWidth6(10), JFScaleWidth6(2), JFScaleWidth6(10));
//        t_state1.borderColor =
        t_state1.width = 200;
        t_state1.height = 50;
        t_state1.centerY = t_stateT.centerY;
        t_state1.right = t_state2.left - JFScaleWidth6(15);
        corner = t_state1.height * 0.5;
        t_state1.cornerRadius = CGSizeMake(corner, corner);
        [self addLayout:t_state1];


        // 所在区块 : block_num
        JFTextStorage* s_block_numT = [JFTextStorage storageWithText:NSLocalizedString(@"所在区块", nil)];
        s_block_numT.font = JFSystemFont(JFScaleWidth6(14));
        s_block_numT.textColor = JFRGBAColor(0xB3B3B3, 1);
//        s_block_numT.backgroundColor = JFColorOrange;
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
//            s_block_num.backgroundColor = JFColorOrange;
            JFTextLayout* t_block_num = [JFTextLayout textLayoutWithText:s_block_num];
            t_block_num.width = JFSCREEN_WIDTH;
            t_block_num.height = 200;
            t_block_num.centerY = t_block_numT.centerY;
            t_block_num.right = JFSCREEN_WIDTH - JFScaleWidth6(15);
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
        self.sectionFrame = CGRectMake(0, bottom, JFSCREEN_WIDTH, JFScaleWidth6(10));
        bottom += JFScaleWidth6(10);

        /**********分割线**********/

        // actions
        JFTextStorage* s_actionsT = [JFTextStorage storageWithText:NSLocalizedString(@"Actiyons", nil)];
        s_actionsT.font = JFSystemFont(JFScaleWidth6(16));
        s_actionsT.textColor = JFRGBAColor(0x333333, 1);
        // 添加高亮属性
        JFTextAttachmentHighlight* highlight = [JFTextAttachmentHighlight new];
        highlight.range = NSMakeRange(2, 3);
        highlight.normalTextColor = JFColorOrange;
        highlight.highlightTextColor = JFColorWhite;
        highlight.normalBackgroundColor = JFRGBAColor(0xeeeeee, 1);
        highlight.highlightBackgroundColor = JFColorOrange;
        highlight.linkData = @"www.baidu.com3";
        [s_actionsT addHighlight:highlight];
        JFTextLayout* t_actionsT = [JFTextLayout textLayoutWithText:s_actionsT];
//        t_actionsT.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
//        t_actionsT.debug = YES;
//        t_actionsT.backgroundColor = JFRGBAColor(0x13BD68, 1);

        t_actionsT.top = bottom + JFScaleWidth6(15);
        t_actionsT.left = JFScaleWidth6(15);
        t_actionsT.width = 200;
        t_actionsT.height = 50;
//        t_actionsT.debug = YES;
        [self addLayout:t_actionsT];
        if (bottom < t_actionsT.bottom) {
            bottom = t_actionsT.bottom;
        }

        self.lineFrame = CGRectMake(0, bottom + JFScaleWidth6(15), JFSCREEN_WIDTH, 0.5);
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
//            tFrom.debug = YES;
            tFrom.top = bottom + JFScaleWidth6(23);
            tFrom.left = JFScaleWidth6(15);
            tFrom.width = 200;
            tFrom.height = 50;
            tFrom.debug = YES;
            [self addLayout:tFrom];
            if (bottom < tFrom.bottom) {
                bottom = tFrom.bottom;
            }


            NSString* to = node[@"to"];
            if (IsNon(to)) {
                to = @"to";
            }
            JFTextStorage* sTo = [JFTextStorage storageWithText:to];
            sTo.font = JFSystemFont(JFScaleWidth6(16));
            sTo.textColor = JFRGBAColor(0x0AA3D1, 1);
            sTo.backgroundColor = JFColorWhite;
            JFTextLayout* tTo = [JFTextLayout textLayoutWithText:sTo];
            tTo.debug = YES;
//            tTo.borderWidth = 1;
//            tTo.borderColor = JFColorOrange;
            tTo.width = 200;
            tTo.height = 50;
            tTo.left = tFrom.right + JFScaleWidth6(10);
            tTo.centerY = tFrom.centerY;
//            corner = tTo.height * 0.5;
//            tTo.cornerRadius = CGSizeMake(corner, corner);
//            tTo.backgroundColor =JFColorWhite;
//            tTo.insets = UIEdgeInsetsZero;
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
                tQuantity.top = bottom + JFScaleWidth6(20);
                tQuantity.debug = YES;
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
//                    tAccount.debug = YES;
                    tAccount.width = 200;
                    tAccount.height = 50;
                    tAccount.left = tQuantity.right + JFScaleWidth6(2);
//                    tAccount.top = tQuantity.bottom - JFScaleWidth6(2) - tAccount.height;
                    tAccount.bottom = tQuantity.bottom;
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
            sMemoT.backgroundColor = JFRGBAColor(0xF5F5F5, 1);
            JFTextLayout* tMemoT = [JFTextLayout textLayoutWithText:sMemoT];
            tMemoT.insets = UIEdgeInsetsMake(JFScaleWidth6(2), JFScaleWidth6(4), JFScaleWidth6(2), JFScaleWidth6(4));
            tMemoT.cornerRadius = CGSizeMake(JFScaleWidth6(2), JFScaleWidth6(2));
            tMemoT.backgroundColor = JFColorWhite;
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
                tMemo.cornerRadius = CGSizeMake(4, 4);
                tMemo.insets = UIEdgeInsetsMake(JFScaleWidth6(5), JFScaleWidth6(10), JFScaleWidth6(5), JFScaleWidth6(10));
                tMemo.width = 200;
                tMemo.height = 200;
                tMemo.left = tMemoT.right + JFScaleWidth6(5);
                // 这时 tMemoT 的suggestSize还是viewSize，还没有更新
                tMemo.centerY = tMemoT.centerY;
                tMemo.borderColor = JFRGBAColor(0x0AA3D1, 0.5);
                tMemo.borderWidth = 1;

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


            NSMutableAttributedString* attriWei = [[NSMutableAttributedString alloc] initWithString:@"}" attributes:@{NSFontAttributeName:JFSystemFont(JFScaleWidth6(14)), NSForegroundColorAttributeName:JFRGBAColor(0xb3b3b3, 1)}];
            [sDatas.text appendAttributedString:attriWei];
            JFTextLayout* tDatas = [JFTextLayout textLayoutWithText:sDatas];
            tDatas.numberOfLines = 0;
            tDatas.left = JFScaleWidth6(15);
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



- (instancetype) initQuanwenLayouts {
    if (self = [super init]) {
        JFTextStorage* storage = [JFTextStorage storageWithText:@"我们现在有一种很怪异的实现方式，就是不管是中文，英文还是中英文混合的CTLine，在字体大小确定的情况下，设定每一行的高度为一个固定值，这样子在绘制的时候一行一行的去CTLineDraw绘制，绘制之前再微调Y值，反正每一行的行高都是确定的，绘制起来也方便，只是感觉这种方式怪怪的，非主流。不过这样子调整的话，因为CoreText本身就是英文字符比中文字符高，排版看起来不大美观，估计要美观的话只好指定每一行的确切高度了。我们现在在处理时如果调整的字体大小，那么指定的行高需要重新再设置，感觉有点麻烦，不知你有没其他好方案？"];
        storage.font = JFSystemFont(14);
        storage.textColor = JFRGBAColor(0x333333, 1);
        storage.lineSpacing = 0.5;
//        storage.kern = 0.2;
        JFTextLayout* layout = [JFTextLayout textLayoutWithText:storage];
        layout.numberOfLines = 4;
        layout.showMoreActColor = JFColorOrange.copy;
        layout.top = JFScaleWidth6(15);
        layout.left = JFScaleWidth6(15);
        layout.width = JFSCREEN_WIDTH - JFScaleWidth6(15 * 2);
        layout.height = 1000;
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

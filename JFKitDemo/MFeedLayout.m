//
//  MFeedLayout.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/26.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "MFeedLayout.h"
#import "TMFeedNode.h"



#define MFeedLayoutFontSizeName 15
#define MFeedLayoutFontSizeContent 14
#define MFeedLayoutFontSizeComment 13



@interface MFeedLayout()
@property (nonatomic, strong) NSArray* imageNameList;
@end

@implementation MFeedLayout

- (instancetype)initWithFeedNode:(TMFeedNode *)node {
    self = [super init];
    if (self) {
        _commentFrame = CGRectZero;
        _webBackColor = JFHexColor(0xefefef, 1);
        _commentBackColor = JFHexColor(0xefefef, 1);
        _seperateLineColor = JFHexColor(0xcdcdcd, 1);
        _seperateLineWidth = 0.3;
        [self processWithFeedNode:node];
    }
    return self;
}


/**
 解析并生成图文缓存，添加到当前layout;
 ----------
 头像 名字
 正文
 图片 or 图片+描述
 日期时间               发表评论
 回复信息:绘制底色边框
 点赞图片 回复人。。
 谁回复谁:回复了什么信息
 ----------

 @param node 数据节点
 */
- (void) processWithFeedNode:(TMFeedNode*)node {
    CGFloat hInset = 10;
    CGFloat vInset = 15;
    CGRect frame = CGRectMake(hInset, vInset, 44, 44);
    CGFloat avalibleWidth = JFSCREEN_WIDTH - hInset - 44 - hInset - vInset;
    CGFloat startX = hInset + 44 + hInset;
    
    // 头像
    JFImageStorage* avatarImg = [JFImageStorage jf_imageStroageWithContents:[NSURL URLWithString:node.avatar] frame:frame];
    [self addStorage:avatarImg];
    
    frame.origin.x = startX;
    frame.size.width = frame.size.height = 1000;
    
    // 名字
    JFTextStorage* nameTxt = [JFTextStorage jf_textStorageWithText:node.name frame:frame insets:UIEdgeInsetsZero];
    nameTxt.textFont = [UIFont boldSystemFontOfSize:MFeedLayoutFontSizeName];
    nameTxt.textColor = JFHexColor(0x6b7ca5, 1);
    [nameTxt addLinkWithData:@"href://nameUrl" textSelectedColor:JFHexColor(0x6b7ca5, 1) backSelectedColor:JFHexColor(0x999999, 1) atRange:NSMakeRange(0, node.name.length)];
    [self addStorage:nameTxt];
    
    frame.origin.y += nameTxt.height + 5;
    frame.size.width = avalibleWidth;
    
    // 正文
    if (node.content && node.content.length > 0) {
        JFTextStorage* contentTxt = [JFTextStorage jf_textStorageWithText:node.content frame:frame insets:UIEdgeInsetsZero];
        // 替换表情符号
        [self replaceEmojPicWithTextStorage:contentTxt];
        
        contentTxt.numberOfLines = 5;
        contentTxt.lineSpace = 1.4;
        contentTxt.debugMode = NO;
        contentTxt.textColor = JFHexColor(0x27384b, 1);
        contentTxt.textFont = [UIFont systemFontOfSize:MFeedLayoutFontSizeContent];
        [self addStorage:contentTxt];
        
        frame.size.height = contentTxt.height;
        frame.origin.y += frame.size.height + hInset;
    }
    
    // 图片组模块
    if ([node.type isEqualToString:@"image"]) {
        NSInteger imgCount = node.imgs.count;
        if (imgCount > 0) {
            CGFloat imgY = frame.origin.y;
            CGFloat offsetY = imgY;
            
            CGFloat imgWidth = 0;
            NSInteger cellCountPerLine = 3;
            
            if (imgCount == 1) {
                imgWidth = avalibleWidth * 0.618;
            }
            else if (imgCount < 5) {
                imgWidth = (avalibleWidth - 5)/2;
                cellCountPerLine = 2;
            }
            else {
                imgWidth = (avalibleWidth - 10)/3;
            }
            
            for (int i = 0; i < imgCount; i++) { // 最多9张图片
                if (i >= 9) break;
                frame.origin.x = startX + (i % cellCountPerLine) * (imgWidth + 5);
                frame.origin.y = imgY + (i / cellCountPerLine) * (imgWidth + 5);
                frame.size.width = frame.size.height = imgWidth;
                JFImageStorage* thumbImg = [JFImageStorage jf_imageStroageWithContents:[NSURL URLWithString:[node.imgs objectAtIndex:i]] frame:frame];
                [self addStorage:thumbImg];
                
                offsetY = frame.origin.y + frame.size.height + hInset;
            }
            
            frame.origin.x = startX;
            frame.origin.y = offsetY;
        }
    }
    // 网页模块
    else if ([node.type isEqualToString:@"website"]) {
        NSString* webImgUrl = [node.imgs firstObject];
        
        CGRect webBackFrame = CGRectMake(frame.origin.x, frame.origin.y, JFSCREEN_WIDTH - frame.origin.x - vInset, 0);
        CGFloat imgWidth = (webImgUrl && webImgUrl.length > 0) ? 60 : 0;
        CGRect imageFrame = CGRectMake(frame.origin.x + 5, frame.origin.y + 5, imgWidth, imgWidth);
        CGRect webTxtFrame = CGRectMake(imageFrame.origin.x + (imgWidth > 0 ? imgWidth + 5 : 0),
                                        imageFrame.origin.y,
                                        webBackFrame.size.width - (imgWidth > 0 ? imgWidth + 10 : 0) - 5,
                                        1000);
        // 网页图片
        if (webImgUrl && webImgUrl.length > 0) {
            JFImageStorage* webImg = [JFImageStorage jf_imageStroageWithContents:[NSURL URLWithString:webImgUrl] frame:imageFrame];
            [self addStorage:webImg];
        }
        // 网页标题
        if (node.detail && node.detail.length > 0) {
            JFTextStorage* webContentTxt = [JFTextStorage jf_textStorageWithText:node.detail frame:webTxtFrame insets:UIEdgeInsetsZero];
            webContentTxt.textFont = [UIFont systemFontOfSize:MFeedLayoutFontSizeComment];
            webContentTxt.textColor = JFHexColor(0x27384b, 1);
            webContentTxt.lineSpace = 1;
            [webContentTxt addLinkWithData:@"href://webContent" textSelectedColor:JFHexColor(0x27384b, 1) backSelectedColor:JFHexColor(0, 0.1) atRange:NSMakeRange(0, node.detail.length)];
            [self addStorage:webContentTxt];
            
            webBackFrame.size.height = MAX(imgWidth + 10, webContentTxt.height + 10);
        }
        _webFrame = webBackFrame;
        
        frame.origin.y = webBackFrame.origin.y + webBackFrame.size.height + hInset;
    }
    
    
    
    // 日期时间
    if (node.date && node.date.length > 0) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[node.date doubleValue]];
        NSString* dateString = JFTimeStringWithFormat(date, @"yyyy-MM-dd");
        JFTextStorage* dateTxt = [JFTextStorage jf_textStorageWithText:dateString frame:frame insets:UIEdgeInsetsZero];
        dateTxt.textColor = JFHexColor(0x999999, 1);
        dateTxt.textFont = [UIFont systemFontOfSize:MFeedLayoutFontSizeComment];
        [self addStorage:dateTxt];
        
    }
    
    // 发表评论
    frame.size.width = 20;
    frame.size.height = 20;
    frame.origin.x = JFSCREEN_WIDTH - vInset - frame.size.width;
    JFImageStorage* menuImg = [JFImageStorage jf_imageStroageWithContents:[UIImage imageNamed:@"[menu]"] frame:frame];
    menuImg.backgroundColor = [UIColor whiteColor];
    [self addStorage:menuImg];
    
    frame.origin.x = startX;
    frame.origin.y += frame.size.height + 5;
    
    // 回复信息
    CGRect commentBackFrame = CGRectMake(frame.origin.x, frame.origin.y, avalibleWidth, 0);
    frame.origin.x += 5;
    frame.origin.y += ChatBubbleTriHeight + 5;
    frame.size.width = avalibleWidth - 10;
    CGFloat commentBackHeight = ChatBubbleTriHeight;
    
    // 点赞 + 点赞用户名列表
    if (node.likeList && node.likeList.count > 0) {
        CGRect likeListFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1000);
        
        NSMutableString* nameList = [NSMutableString stringWithFormat:@" "];
        // @[@"权志龙",@"伊布拉希莫维奇",@"权志龙",@"郜林",@"扎克伯格"]
        for (int i = 0; i < node.likeList.count; i++) {
            NSString* name = [node.likeList objectAtIndex:i];
            if (i > 0) [nameList appendString:@","];
            [nameList appendString:name];
        }
        JFTextStorage* likeListTxt = [JFTextStorage jf_textStorageWithText:nameList frame:likeListFrame insets:UIEdgeInsetsZero];
        [likeListTxt setImage:[UIImage imageNamed:@"Like"] imageSize:CGSizeMake(15, 15) atPosition:0];
        likeListTxt.textColor = JFHexColor(0x27384b, 1);
        likeListTxt.textFont = [UIFont boldSystemFontOfSize:MFeedLayoutFontSizeComment];
        likeListTxt.lineSpace = 2.f;
        likeListTxt.debugMode = NO;
        for (NSString* name in node.likeList) {
            NSRange nameRange = [nameList rangeOfString:name];
            nameRange.location += 1;
            [likeListTxt setTextColor:JFHexColor(0x6b7ca5, 1) atRange:nameRange];
            NSString* nameData = [NSString stringWithFormat:@"href://%@", name];
            [likeListTxt addLinkWithData:nameData textSelectedColor:JFHexColor(0x6c7ba5, 1) backSelectedColor:JFHexColor(0, 0.1) atRange:nameRange];
        }
        [self addStorage:likeListTxt];
        
        frame.origin.y += likeListTxt.height + 5;
        // 计算分割线位置+长度
        if (node.commentList && node.commentList.count > 0) {
            _seperateLineStartP = CGPointMake(commentBackFrame.origin.x, frame.origin.y);
            _seperateLineEndP = CGPointMake(commentBackFrame.origin.x + avalibleWidth, frame.origin.y);
            frame.origin.y += 5;
        }
        commentBackHeight += 5 + likeListTxt.height + 5;
    }
    // 回复内容
    if (node.commentList && node.commentList.count > 0) {
        for (TMFeedCommentNode* commentNode in node.commentList) {
            commentBackHeight += 5;
            NSMutableString* commentText = [NSMutableString string];
            if (commentNode.to && commentNode.to.length > 0) {
                [commentText appendFormat:@"%@回复", commentNode.to];
            }
            [commentText appendFormat:@"%@:%@", commentNode.from, commentNode.content];
            
            frame.size.height = 1000;
            JFTextStorage* commentTxt = [JFTextStorage jf_textStorageWithText:commentText frame:frame insets:UIEdgeInsetsZero];
            commentTxt.textFont = [UIFont systemFontOfSize:MFeedLayoutFontSizeComment];
            commentTxt.textColor = JFHexColor(0x27384b, 1);
            
            if (commentNode.to && commentNode.to.length > 0) {
                NSRange toRange = [commentText rangeOfString:commentNode.to];
                [commentTxt setTextFont:[UIFont boldSystemFontOfSize:MFeedLayoutFontSizeComment] atRange:toRange];
                [commentTxt setTextColor:JFHexColor(0x6b7ca5, 1) atRange:toRange];
                NSString* toData = [NSString stringWithFormat:@"href://%@", commentNode.to];
                [commentTxt addLinkWithData:toData textSelectedColor:JFHexColor(0x6b7ca5, 1) backSelectedColor:JFHexColor(0, 0.1) atRange:toRange];
            }
            NSRange fromRange = [commentText rangeOfString:commentNode.from];
            [commentTxt setTextFont:[UIFont boldSystemFontOfSize:MFeedLayoutFontSizeComment] atRange:fromRange];
            [commentTxt setTextColor:JFHexColor(0x6b7ca5, 1) atRange:fromRange];
            NSString* fromData = [NSString stringWithFormat:@"href://%@", commentNode.from];
            [commentTxt addLinkWithData:fromData textSelectedColor:JFHexColor(0x6b7ca5, 1) backSelectedColor:JFHexColor(0, 0.1) atRange:fromRange];
            commentTxt.lineSpace = 1;
            [self addStorage:commentTxt];
            
            frame.origin.y += commentTxt.height + 5;
            
            commentBackHeight += commentTxt.height;
        }
        commentBackHeight += 5;
    }
    commentBackFrame.size.height = commentBackHeight;
    
    _commentFrame = commentBackFrame;
    _cellHeight = self.bottom + 5 + 15;
}

- (void) replaceEmojPicWithTextStorage:(JFTextStorage*)textStorage {
    while (YES) {
        BOOL finded = NO;
        for (NSString* imageName in self.imageNameList) {
            NSString* text = textStorage.attributedString.string;
            NSRange range = [text rangeOfString:imageName options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.length)];
            if (range.length > 0) {
                finded = YES;
                [textStorage replaceTextAtRange:range withImage:[UIImage imageNamed:imageName] imageSize:CGSizeMake(16, 16)];
            }
        }
        if (!finded) {
            break;
        }
    }
    
}


# pragma mask 4 getter

- (NSArray *)imageNameList {
    if (!_imageNameList) {
        _imageNameList = @[@"[心]",
                           @"[face]"];
    }
    return _imageNameList;
}

@end

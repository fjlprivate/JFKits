//
//  VTMFeedCell.m
//  JFKitDemo
//
//  Created by warmjar on 2017/7/25.
//  Copyright © 2017年 warmjar. All rights reserved.
//

#import "VTMFeedCell.h"
#import "JFKit.h"

@interface VTMFeedCell()
@property (nonatomic, strong) JFAsyncDisplayView* asyncView;
@end

@implementation VTMFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _asyncView = [JFAsyncDisplayView new];
        [self.contentView addSubview:_asyncView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncView.frame = self.contentView.frame;
}

- (void)setLayout:(JFLayout *)layout {
    _layout = layout;
    self.asyncView.layout = layout;
}

@end

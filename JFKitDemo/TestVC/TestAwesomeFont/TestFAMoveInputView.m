//
//  TestFAMoveInputView.m
//  JFTools
//
//  Created by fjl on 2021/6/11.
//

#import "TestFAMoveInputView.h"
#import "JFToast.h"

@interface TestFAMoveInputContentView : UIView
@property (nonatomic, strong) UILabel* labTFrom;
@property (nonatomic, strong) UITextField* txtFromSection;
@property (nonatomic, strong) UIView* vFromSectionLine;
@property (nonatomic, strong) UITextField* txtFromRow;
@property (nonatomic, strong) UIView* vFromRowLine;

@property (nonatomic, strong) UILabel* labTTo;
@property (nonatomic, strong) UITextField* txtToSection;
@property (nonatomic, strong) UIView* vToSectionLine;
@property (nonatomic, strong) UITextField* txtToRow;
@property (nonatomic, strong) UIView* vToRowLine;

@property (nonatomic, strong) UILabel* labSwitch;
@property (nonatomic, strong) UISwitch* vSwitch;

@property (nonatomic, strong) UIButton* btnCancel;
@property (nonatomic, strong) UIButton* btnSure;

@end



@interface TestFAMoveInputView()

@end
@implementation TestFAMoveInputView

- (instancetype)initWithAnimateStyle:(JFPresenterAnimateStyle)animateStyle {
    if (self = [super initWithAnimateStyle:animateStyle]) {
        TestFAMoveInputContentView* contentView = [[TestFAMoveInputContentView alloc] initWithFrame:CGRectZero];
        [contentView.btnCancel addTarget:self action:@selector(clickedCancel:) forControlEvents:UIControlEventTouchUpInside];
        [contentView.btnSure addTarget:self action:@selector(clickedSure:) forControlEvents:UIControlEventTouchUpInside];
        self.vContent = contentView;
        [self addSubview:self.vContent];
        [self.vContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width * 0.8);
            make.height.mas_equalTo(180);
        }];
    }
    return self;
}

- (IBAction) clickedCancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hide];
}
- (IBAction) clickedSure:(id)sender {
    TestFAMoveInputContentView* inputContentV = (TestFAMoveInputContentView*)self.vContent;
    if (!inputContentV.txtFromSection.text || inputContentV.txtFromSection.text.length == 0) {
        [JFToast toastWithText:@"请输入fromSection"];
        return;
    }
    if (!inputContentV.txtFromRow.text || inputContentV.txtFromRow.text.length == 0) {
        [JFToast toastWithText:@"请输入fromRow"];
        return;
    }
    if (!inputContentV.txtToSection.text || inputContentV.txtToSection.text.length == 0) {
        [JFToast toastWithText:@"请输入toSection"];
        return;
    }
    if (!inputContentV.txtToRow.text || inputContentV.txtToRow.text.length == 0) {
        [JFToast toastWithText:@"请输入toRow"];
        return;
    }
    if (self.sureBlock) {
        NSIndexPath* fromId = [NSIndexPath indexPathForRow:inputContentV.txtFromRow.text.integerValue - 1 inSection:inputContentV.txtFromSection.text.integerValue];
        NSIndexPath* toId = [NSIndexPath indexPathForRow:inputContentV.txtToRow.text.integerValue - 1 inSection:inputContentV.txtToSection.text.integerValue];
        self.sureBlock(fromId, toId);
    }

    [self hide];
}




@end





@implementation TestFAMoveInputContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self addSubview:self.labTFrom];
        [self addSubview:self.txtFromSection];
        [self addSubview:self.txtFromRow];
        [self addSubview:self.labTTo];
        [self addSubview:self.txtToSection];
        [self addSubview:self.txtToRow];
        [self addSubview:self.btnCancel];
        [self addSubview:self.btnSure];
        [self addSubview:self.vFromSectionLine];
        [self addSubview:self.vFromRowLine];
        [self addSubview:self.vToSectionLine];
        [self addSubview:self.vToRowLine];
        [self addSubview:self.labSwitch];
        [self addSubview:self.vSwitch];


        [self.labTFrom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(20);
        }];
        [self.txtFromSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labTFrom.mas_right).offset(10);
            make.centerY.equalTo(self.labTFrom);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
        [self.txtFromRow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.txtFromSection.mas_right).offset(10);
            make.centerY.equalTo(self.labTFrom);
            make.height.width.equalTo(self.txtFromSection);
        }];
        
        
        [self.labTTo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labTFrom);
            make.top.equalTo(self.labTFrom.mas_bottom).offset(15);
        }];
        [self.txtToSection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labTTo.mas_right).offset(10);
            make.centerY.equalTo(self.labTTo);
            make.height.width.equalTo(self.txtFromSection);
        }];
        [self.txtToRow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.txtToSection.mas_right).offset(10);
            make.centerY.equalTo(self.labTTo);
            make.height.width.equalTo(self.txtFromSection);
        }];

        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(20);
            make.right.equalTo(self.mas_centerX).offset(-10);
            make.height.mas_equalTo(40);
        }];
        [self.btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.btnCancel);
            make.left.equalTo(self.mas_centerX).offset(10);
            make.right.mas_equalTo(-20);
        }];
        
        [self.vFromSectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.txtFromSection);
            make.height.mas_equalTo(1);
        }];
        [self.vFromRowLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.txtFromRow);
            make.height.mas_equalTo(1);
        }];
        [self.vToSectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.txtToSection);
            make.height.mas_equalTo(1);
        }];
        [self.vToRowLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.txtToRow);
            make.height.mas_equalTo(1);
        }];

        [self.labSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labTFrom);
            make.top.equalTo(self.labTTo.mas_bottom).offset(15);
        }];
        [self.vSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labSwitch.mas_right).offset(10);
            make.centerY.equalTo(self.labSwitch);
        }];
    }
    return self;
}



# pragma mark - getter
- (UILabel *)labTFrom {
    if (!_labTFrom) {
        _labTFrom = [UILabel new];
        _labTFrom.text = @"起始位置:";
        _labTFrom.textColor = UIColor.blackColor;
        _labTFrom.font = [UIFont boldSystemFontOfSize:20];
    }
    return _labTFrom;
}
- (UILabel *)labTTo {
    if (!_labTTo) {
        _labTTo = [UILabel new];
        _labTTo.text = @"终点位置:";
        _labTTo.textColor = UIColor.blackColor;
        _labTTo.font = [UIFont boldSystemFontOfSize:20];
    }
    return _labTTo;
}
- (UILabel *)labSwitch {
    if (!_labSwitch) {
        _labSwitch = [UILabel new];
        _labSwitch.text = @"是否对调:";
        _labSwitch.textColor = UIColor.blackColor;
        _labSwitch.font = [UIFont boldSystemFontOfSize:20];
    }
    return _labSwitch;
}
- (UISwitch *)vSwitch {
    if (!_vSwitch) {
        _vSwitch = [UISwitch new];
    }
    return _vSwitch;
}

- (UITextField *)txtFromSection {
    if (!_txtFromSection) {
        _txtFromSection = [UITextField new];
        _txtFromSection.textColor = UIColor.blackColor;
        _txtFromSection.font = [UIFont boldSystemFontOfSize:15];
        _txtFromSection.keyboardType = UIKeyboardTypeNumberPad;
        _txtFromSection.placeholder = @"section";
        _txtFromSection.textAlignment = NSTextAlignmentCenter;
    }
    return _txtFromSection;
}

- (UITextField *)txtFromRow {
    if (!_txtFromRow) {
        _txtFromRow = [UITextField new];
        _txtFromRow.textColor = UIColor.blackColor;
        _txtFromRow.font = [UIFont boldSystemFontOfSize:15];
        _txtFromRow.keyboardType = UIKeyboardTypeNumberPad;
        _txtFromRow.placeholder = @"row";
        _txtFromRow.textAlignment = NSTextAlignmentCenter;
    }
    return _txtFromRow;
}
- (UITextField *)txtToSection {
    if (!_txtToSection) {
        _txtToSection = [UITextField new];
        _txtToSection.textColor = UIColor.blackColor;
        _txtToSection.font = [UIFont boldSystemFontOfSize:15];
        _txtToSection.keyboardType = UIKeyboardTypeNumberPad;
        _txtToSection.placeholder = @"section";
        _txtToSection.textAlignment = NSTextAlignmentCenter;
    }
    return _txtToSection;
}
- (UITextField *)txtToRow {
    if (!_txtToRow) {
        _txtToRow = [UITextField new];
        _txtToRow.textColor = UIColor.blackColor;
        _txtToRow.font = [UIFont boldSystemFontOfSize:15];
        _txtToRow.keyboardType = UIKeyboardTypeNumberPad;
        _txtToRow.placeholder = @"row";
        _txtToRow.textAlignment = NSTextAlignmentCenter;
    }
    return _txtToRow;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [UIButton new];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _btnCancel;
}
- (UIButton *)btnSure {
    if (!_btnSure) {
        _btnSure = [UIButton new];
        [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSure setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    }
    return _btnSure;
}

- (UIView *)vFromSectionLine {
    if (!_vFromSectionLine) {
        _vFromSectionLine = [UIView new];
        _vFromSectionLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _vFromSectionLine;
}
- (UIView *)vFromRowLine {
    if (!_vFromRowLine) {
        _vFromRowLine = [UIView new];
        _vFromRowLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _vFromRowLine;
}
- (UIView *)vToSectionLine {
    if (!_vToSectionLine) {
        _vToSectionLine = [UIView new];
        _vToSectionLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _vToSectionLine;
}
- (UIView *)vToRowLine {
    if (!_vToRowLine) {
        _vToRowLine = [UIView new];
        _vToRowLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _vToRowLine;
}

@end

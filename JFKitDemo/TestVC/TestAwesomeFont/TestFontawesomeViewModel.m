//
//  TestFontawesomeViewModel.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/11.
//

#import "TestFontawesomeViewModel.h"


@interface TestFontawesomeViewModel()
// 跟文件保持一致的数据源
@property (nonatomic, strong) NSDictionary<NSString*,NSArray*>* originFonts;
// 显示、编辑的数据源
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSMutableArray*>* editingFonts;
// 显示的标题组
@property (nonatomic, strong) NSArray* titles;
// 全量字体值和名称字典
@property (nonatomic, strong) NSDictionary<NSNumber*,NSString*>* fontsDic;
@end

@implementation TestFontawesomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        NSData* data = [NSData dataWithContentsOfFile:[self filePathForWriting:NO]];
        NSAssert(data, @"文件数据不存在");
        NSError* error;
        self.originFonts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSAssert(self.originFonts, @"解析文件数据失败");
        [self reloadFromOriginFonts];
    }
    return self;
}

- (NSInteger) numberOfSections {
    return self.titles.count;
}
- (NSInteger) numberOfItemsInSection:(NSInteger)section {
    NSString* title = self.titles[section];
    NSArray* items = self.editingFonts[title];
    return items.count;
}

- (NSString*) titleForSection:(NSInteger)section {
    return self.titles[section];
}
- (NSString*) nameForItemAtIndexPath:(NSIndexPath*)indexPath {
    FAIcon value = [self valueForItemAtIndexPath:indexPath];
    return self.fontsDic[@(value)];
}
- (FAIcon) valueForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSString* title = self.titles[indexPath.section];
    NSArray* items = self.editingFonts[title];
    return [[items objectAtIndex:indexPath.row] integerValue];
}

// 移动item
- (void) moveItemFromIndexPath:(NSIndexPath*)fromId toIndexPath:(NSIndexPath*)toId {
    NSString* fromTitle = self.titles[fromId.section];
    NSString* toTitle = self.titles[toId.section];
    
    NSMutableArray* fromList = self.editingFonts[fromTitle];
    NSMutableArray* toList = self.editingFonts[toTitle];
    NSNumber* item = fromList[fromId.row];
    [fromList removeObjectAtIndex:fromId.row];
    [toList insertObject:item atIndex:toId.row];
}


// 取消移动的item;归位
- (void) cancelMoving {
    [self reloadFromOriginFonts];
}
// 完成移动;
- (void) endMoving {
    [self savingCurFontsToOrigin];
}
// 保存数据到本地;
- (void) saving {
    // 将结果写入文件
    NSData* data = [NSJSONSerialization dataWithJSONObject:self.originFonts options:0 error:NULL];
    if (data) {
        [data writeToFile:[self filePathForWriting:YES] atomically:YES];
    }
}


# pragma mark - private

// origin -> editingFonts
- (void) reloadFromOriginFonts {
    NSMutableDictionary* mulDic = @{}.mutableCopy;
    for (NSString* key in self.originFonts.allKeys) {
        NSMutableArray* list = [self.originFonts[key] mutableCopy];
        mulDic[key] = list;
    }
    self.editingFonts = mulDic;
}
// editingFonts -> origin
- (void) savingCurFontsToOrigin {
    self.originFonts = self.editingFonts.copy;
}


/// 文件目录；调用时机: 第一次加载时，和每次保存时
/// @param forWriting  YES:写  NO:读
- (NSString*) filePathForWriting:(BOOL)forWriting {
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* fileDir = [NSString stringWithFormat:@"%@/FontAwesome", documentPath];
    // 没有目录则创建目录
    NSFileManager* fileMan = [NSFileManager defaultManager];
    NSError* error;
    if (![fileMan fileExistsAtPath:fileDir]) {
        BOOL suc = [fileMan createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"---------FontAwesome目录不存在，创建目录，创建结果[%@]:[%@]",suc?@"YES":@"NO", error);
    }
    // 如果是写，则生成新的文件，并返回
    if (forWriting) {
        NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"MMddHHmmss";
        NSString* timeString = [dateformatter stringFromDate:[NSDate date]];
        NSString* newFileName = [fileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FontAwesome_%@.json", timeString]];
        [fileMan createFileAtPath:newFileName contents:nil attributes:nil];
        NSLog(@"---------写入文件::%@", newFileName);
        return newFileName;
    }
    
    // 那后面就是读取文件了
    NSArray* fileList = [fileMan contentsOfDirectoryAtPath:fileDir error:&error];
    // 目录有文件，取最新的返回
    if (fileList && fileList.count > 0) {
        NSLog(@"---------FontAwesome目录下的文件列表::%@", fileList);
        fileList = [fileList sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
            // 倒序
            return [obj2 compare:obj1];
        }];
        NSLog(@"---------返回的FontAwesome目录下的最新文件::%@", fileList.firstObject);
        return [fileDir stringByAppendingPathComponent:fileList.firstObject];
    }
    // 目录无文件，则将bundle中的文件拷贝到目录
    else {
        NSLog(@"---------FontAwesome目录下无文件,error[%@]", error);
        NSString* newFileName = [fileDir stringByAppendingPathComponent:@"FontAwesome.json"];
        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"FontAwesome" ofType:@"json"];
        [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:newFileName error:&error];
        if (error) {
            NSLog(@"---------FontAwesome目录下无文件,拷贝失败:[%@]", error);
        }
        return newFileName;
    }
    return nil;
}

# pragma mark - getter


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
            @"图表",
            @"转圈",
            @"文本编辑",
            @"文件类型",
            @"表单",
            @"多媒体",
            @"指示方向",
            @"性别",
            @"运输",
            @"手势",
            @"医疗",
            @"货币",
            @"支付",
            @"辅助功能",
            @"标志",
            @"拟物",
            @"商标",
        ];
    }
    return _titles;
}

- (NSDictionary<NSNumber *,NSString *> *)fontsDic {
    if (!_fontsDic) {
        _fontsDic = @{
            @(FAGlass):@"FAGlass",
            @(FAMusic):@"FAMusic",
            @(FASearch):@"FASearch",
            @(FAEnvelopeO):@"FAEnvelopeO",
            @(FAHeart):@"FAHeart",
            @(FAStar):@"FAStar",
            @(FAStarO):@"FAStarO",
            @(FAUser):@"FAUser",
            @(FAFilm):@"FAFilm",
            @(FAThLarge):@"FAThLarge",
            @(FATh):@"FATh",
            @(FAThList):@"FAThList",
            @(FACheck):@"FACheck",
            @(FATimes):@"FATimes",
            @(FASearchPlus):@"FASearchPlus",
            @(FASearchMinus):@"FASearchMinus",
            @(FAPowerOff):@"FAPowerOff",
            @(FASignal):@"FASignal",
            @(FACog):@"FACog",
            @(FATrashO):@"FATrashO",
            @(FAHome):@"FAHome",
            @(FAFileO):@"FAFileO",
            @(FAClockO):@"FAClockO",
            @(FARoad):@"FARoad",
            @(FADownload):@"FADownload",
            @(FAArrowCircleODown):@"FAArrowCircleODown",
            @(FAArrowCircleOUp):@"FAArrowCircleOUp",
            @(FAInbox):@"FAInbox",
            @(FAPlayCircleO):@"FAPlayCircleO",
            @(FARepeat):@"FARepeat",
            @(FARefresh):@"FARefresh",
            @(FAListAlt):@"FAListAlt",
            @(FALock):@"FALock",
            @(FAFlag):@"FAFlag",
            @(FAHeadphones):@"FAHeadphones",
            @(FAVolumeOff):@"FAVolumeOff",
            @(FAVolumeDown):@"FAVolumeDown",
            @(FAVolumeUp):@"FAVolumeUp",
            @(FAQrcode):@"FAQrcode",
            @(FABarcode):@"FABarcode",
            @(FATag):@"FATag",
            @(FATags):@"FATags",
            @(FABook):@"FABook",
            @(FABookmark):@"FABookmark",
            @(FAPrint):@"FAPrint",
            @(FACamera):@"FACamera",
            @(FAFont):@"FAFont",
            @(FABold):@"FABold",
            @(FAItalic):@"FAItalic",
            @(FATextHeight):@"FATextHeight",
            @(FATextWidth):@"FATextWidth",
            @(FAAlignLeft):@"FAAlignLeft",
            @(FAAlignCenter):@"FAAlignCenter",
            @(FAAlignRight):@"FAAlignRight",
            @(FAAlignJustify):@"FAAlignJustify",
            @(FAList):@"FAList",
            @(FAOutdent):@"FAOutdent",
            @(FAIndent):@"FAIndent",
            @(FAVideoCamera):@"FAVideoCamera",
            @(FAPictureO):@"FAPictureO",
            @(FAPencil):@"FAPencil",
            @(FAMapMarker):@"FAMapMarker",
            @(FAAdjust):@"FAAdjust",
            @(FATint):@"FATint",
            @(FAPencilSquareO):@"FAPencilSquareO",
            @(FAShareSquareO):@"FAShareSquareO",
            @(FACheckSquareO):@"FACheckSquareO",
            @(FAArrows):@"FAArrows",
            @(FAStepBackward):@"FAStepBackward",
            @(FAFastBackward):@"FAFastBackward",
            @(FABackward):@"FABackward",
            @(FAPlay):@"FAPlay",
            @(FAPause):@"FAPause",
            @(FAStop):@"FAStop",
            @(FAForward):@"FAForward",
            @(FAFastForward):@"FAFastForward",
            @(FAStepForward):@"FAStepForward",
            @(FAEject):@"FAEject",
            @(FAChevronLeft):@"FAChevronLeft",
            @(FAChevronRight):@"FAChevronRight",
            @(FAPlusCircle):@"FAPlusCircle",
            @(FAMinusCircle):@"FAMinusCircle",
            @(FATimesCircle):@"FATimesCircle",
            @(FACheckCircle):@"FACheckCircle",
            @(FAQuestionCircle):@"FAQuestionCircle",
            @(FAInfoCircle):@"FAInfoCircle",
            @(FACrosshairs):@"FACrosshairs",
            @(FATimesCircleO):@"FATimesCircleO",
            @(FACheckCircleO):@"FACheckCircleO",
            @(FABan):@"FABan",
            @(FAArrowLeft):@"FAArrowLeft",
            @(FAArrowRight):@"FAArrowRight",
            @(FAArrowUp):@"FAArrowUp",
            @(FAArrowDown):@"FAArrowDown",
            @(FAShare):@"FAShare",
            @(FAExpand):@"FAExpand",
            @(FACompress):@"FACompress",
            @(FAPlus):@"FAPlus",
            @(FAMinus):@"FAMinus",
            @(FAAsterisk):@"FAAsterisk",
            @(FAExclamationCircle):@"FAExclamationCircle",
            @(FAGift):@"FAGift",
            @(FALeaf):@"FALeaf",
            @(FAFire):@"FAFire",
            @(FAEye):@"FAEye",
            @(FAEyeSlash):@"FAEyeSlash",
            @(FAExclamationTriangle):@"FAExclamationTriangle",
            @(FAPlane):@"FAPlane",
            @(FACalendar):@"FACalendar",
            @(FARandom):@"FARandom",
            @(FAComment):@"FAComment",
            @(FAMagnet):@"FAMagnet",
            @(FAChevronUp):@"FAChevronUp",
            @(FAChevronDown):@"FAChevronDown",
            @(FARetweet):@"FARetweet",
            @(FAShoppingCart):@"FAShoppingCart",
            @(FAFolder):@"FAFolder",
            @(FAFolderOpen):@"FAFolderOpen",
            @(FAArrowsV):@"FAArrowsV",
            @(FAArrowsH):@"FAArrowsH",
            @(FABarChartO):@"FABarChartO",
            @(FATwitterSquare):@"FATwitterSquare",
            @(FAFacebookSquare):@"FAFacebookSquare",
            @(FACameraRetro):@"FACameraRetro",
            @(FAKey):@"FAKey",
            @(FACogs):@"FACogs",
            @(FAComments):@"FAComments",
            @(FAThumbsOUp):@"FAThumbsOUp",
            @(FAThumbsODown):@"FAThumbsODown",
            @(FAStarHalf):@"FAStarHalf",
            @(FAHeartO):@"FAHeartO",
            @(FASignOut):@"FASignOut",
            @(FALinkedinSquare):@"FALinkedinSquare",
            @(FAThumbTack):@"FAThumbTack",
            @(FAExternalLink):@"FAExternalLink",
            @(FASignIn):@"FASignIn",
            @(FATrophy):@"FATrophy",
            @(FAGithubSquare):@"FAGithubSquare",
            @(FAUpload):@"FAUpload",
            @(FALemonO):@"FALemonO",
            @(FAPhone):@"FAPhone",
            @(FASquareO):@"FASquareO",
            @(FABookmarkO):@"FABookmarkO",
            @(FAPhoneSquare):@"FAPhoneSquare",
            @(FATwitter):@"FATwitter",
            @(FAFacebook):@"FAFacebook",
            @(FAGithub):@"FAGithub",
            @(FAUnlock):@"FAUnlock",
            @(FACreditCard):@"FACreditCard",
            @(FARss):@"FARss",
            @(FAHddO):@"FAHddO",
            @(FABullhorn):@"FABullhorn",
            @(FABell):@"FABell",
            @(FACertificate):@"FACertificate",
            @(FAHandORight):@"FAHandORight",
            @(FAHandOLeft):@"FAHandOLeft",
            @(FAHandOUp):@"FAHandOUp",
            @(FAHandODown):@"FAHandODown",
            @(FAArrowCircleLeft):@"FAArrowCircleLeft",
            @(FAArrowCircleRight):@"FAArrowCircleRight",
            @(FAArrowCircleUp):@"FAArrowCircleUp",
            @(FAArrowCircleDown):@"FAArrowCircleDown",
            @(FAGlobe):@"FAGlobe",
            @(FAWrench):@"FAWrench",
            @(FATasks):@"FATasks",
            @(FAFilter):@"FAFilter",
            @(FABriefcase):@"FABriefcase",
            @(FAArrowsAlt):@"FAArrowsAlt",
            @(FAUsers):@"FAUsers",
            @(FALink):@"FALink",
            @(FACloud):@"FACloud",
            @(FAFlask):@"FAFlask",
            @(FAScissors):@"FAScissors",
            @(FAFilesO):@"FAFilesO",
            @(FAPaperclip):@"FAPaperclip",
            @(FAFloppyO):@"FAFloppyO",
            @(FASquare):@"FASquare",
            @(FABars):@"FABars",
            @(FAListUl):@"FAListUl",
            @(FAListOl):@"FAListOl",
            @(FAStrikethrough):@"FAStrikethrough",
            @(FAUnderline):@"FAUnderline",
            @(FATable):@"FATable",
            @(FAMagic):@"FAMagic",
            @(FATruck):@"FATruck",
            @(FAPinterest):@"FAPinterest",
            @(FAPinterestSquare):@"FAPinterestSquare",
            @(FAGooglePlusSquare):@"FAGooglePlusSquare",
            @(FAGooglePlus):@"FAGooglePlus",
            @(FAMoney):@"FAMoney",
            @(FACaretDown):@"FACaretDown",
            @(FACaretUp):@"FACaretUp",
            @(FACaretLeft):@"FACaretLeft",
            @(FACaretRight):@"FACaretRight",
            @(FAColumns):@"FAColumns",
            @(FASort):@"FASort",
            @(FASortAsc):@"FASortAsc",
            @(FASortDesc):@"FASortDesc",
            @(FAEnvelope):@"FAEnvelope",
            @(FALinkedin):@"FALinkedin",
            @(FAUndo):@"FAUndo",
            @(FAGavel):@"FAGavel",
            @(FATachometer):@"FATachometer",
            @(FACommentO):@"FACommentO",
            @(FACommentsO):@"FACommentsO",
            @(FABolt):@"FABolt",
            @(FASitemap):@"FASitemap",
            @(FAUmbrella):@"FAUmbrella",
            @(FAClipboard):@"FAClipboard",
            @(FALightbulbO):@"FALightbulbO",
            @(FAExchange):@"FAExchange",
            @(FACloudDownload):@"FACloudDownload",
            @(FACloudUpload):@"FACloudUpload",
            @(FAUserMd):@"FAUserMd",
            @(FAStethoscope):@"FAStethoscope",
            @(FASuitcase):@"FASuitcase",
            @(FABellO):@"FABellO",
            @(FACoffee):@"FACoffee",
            @(FACutlery):@"FACutlery",
            @(FAFileTextO):@"FAFileTextO",
            @(FABuildingO):@"FABuildingO",
            @(FAHospitalO):@"FAHospitalO",
            @(FAAmbulance):@"FAAmbulance",
            @(FAMedkit):@"FAMedkit",
            @(FAFighterJet):@"FAFighterJet",
            @(FABeer):@"FABeer",
            @(FAHSquare):@"FAHSquare",
            @(FAPlusSquare):@"FAPlusSquare",
            @(FAAngleDoubleLeft):@"FAAngleDoubleLeft",
            @(FAAngleDoubleRight):@"FAAngleDoubleRight",
            @(FAAngleDoubleUp):@"FAAngleDoubleUp",
            @(FAAngleDoubleDown):@"FAAngleDoubleDown",
            @(FAAngleLeft):@"FAAngleLeft",
            @(FAAngleRight):@"FAAngleRight",
            @(FAAngleUp):@"FAAngleUp",
            @(FAAngleDown):@"FAAngleDown",
            @(FADesktop):@"FADesktop",
            @(FALaptop):@"FALaptop",
            @(FATablet):@"FATablet",
            @(FAMobile):@"FAMobile",
            @(FACircleO):@"FACircleO",
            @(FAQuoteLeft):@"FAQuoteLeft",
            @(FAQuoteRight):@"FAQuoteRight",
            @(FASpinner):@"FASpinner",
            @(FACircle):@"FACircle",
            @(FAReply):@"FAReply",
            @(FAGithubAlt):@"FAGithubAlt",
            @(FAFolderO):@"FAFolderO",
            @(FAFolderOpenO):@"FAFolderOpenO",
            @(FASmileO):@"FASmileO",
            @(FAFrownO):@"FAFrownO",
            @(FAMehO):@"FAMehO",
            @(FAGamepad):@"FAGamepad",
            @(FAKeyboardO):@"FAKeyboardO",
            @(FAFlagO):@"FAFlagO",
            @(FAFlagCheckered):@"FAFlagCheckered",
            @(FATerminal):@"FATerminal",
            @(FACode):@"FACode",
            @(FAReplyAll):@"FAReplyAll",
            @(FAMailReplyAll):@"FAMailReplyAll",
            @(FAStarHalfO):@"FAStarHalfO",
            @(FALocationArrow):@"FALocationArrow",
            @(FACrop):@"FACrop",
            @(FACodeFork):@"FACodeFork",
            @(FAChainBroken):@"FAChainBroken",
            @(FAQuestion):@"FAQuestion",
            @(FAInfo):@"FAInfo",
            @(FAExclamation):@"FAExclamation",
            @(FASuperscript):@"FASuperscript",
            @(FASubscript):@"FASubscript",
            @(FAEraser):@"FAEraser",
            @(FAPuzzlePiece):@"FAPuzzlePiece",
            @(FAMicrophone):@"FAMicrophone",
            @(FAMicrophoneSlash):@"FAMicrophoneSlash",
            @(FAShield):@"FAShield",
            @(FACalendarO):@"FACalendarO",
            @(FAFireExtinguisher):@"FAFireExtinguisher",
            @(FARocket):@"FARocket",
            @(FAMaxcdn):@"FAMaxcdn",
            @(FAChevronCircleLeft):@"FAChevronCircleLeft",
            @(FAChevronCircleRight):@"FAChevronCircleRight",
            @(FAChevronCircleUp):@"FAChevronCircleUp",
            @(FAChevronCircleDown):@"FAChevronCircleDown",
            @(FAHtml5):@"FAHtml5",
            @(FACss3):@"FACss3",
            @(FAAnchor):@"FAAnchor",
            @(FAUnlockAlt):@"FAUnlockAlt",
            @(FABullseye):@"FABullseye",
            @(FAEllipsisH):@"FAEllipsisH",
            @(FAEllipsisV):@"FAEllipsisV",
            @(FARssSquare):@"FARssSquare",
            @(FAPlayCircle):@"FAPlayCircle",
            @(FATicket):@"FATicket",
            @(FAMinusSquare):@"FAMinusSquare",
            @(FAMinusSquareO):@"FAMinusSquareO",
            @(FALevelUp):@"FALevelUp",
            @(FALevelDown):@"FALevelDown",
            @(FACheckSquare):@"FACheckSquare",
            @(FAPencilSquare):@"FAPencilSquare",
            @(FAExternalLinkSquare):@"FAExternalLinkSquare",
            @(FAShareSquare):@"FAShareSquare",
            @(FACompass):@"FACompass",
            @(FACaretSquareODown):@"FACaretSquareODown",
            @(FACaretSquareOUp):@"FACaretSquareOUp",
            @(FACaretSquareORight):@"FACaretSquareORight",
            @(FAEur):@"FAEur",
            @(FAGbp):@"FAGbp",
            @(FAUsd):@"FAUsd",
            @(FAInr):@"FAInr",
            @(FAJpy):@"FAJpy",
            @(FARub):@"FARub",
            @(FAKrw):@"FAKrw",
            @(FABtc):@"FABtc",
            @(FAFile):@"FAFile",
            @(FAFileText):@"FAFileText",
            @(FASortAlphaAsc):@"FASortAlphaAsc",
            @(FASortAlphaDesc):@"FASortAlphaDesc",
            @(FASortAmountAsc):@"FASortAmountAsc",
            @(FASortAmountDesc):@"FASortAmountDesc",
            @(FASortNumericAsc):@"FASortNumericAsc",
            @(FASortNumericDesc):@"FASortNumericDesc",
            @(FAThumbsUp):@"FAThumbsUp",
            @(FAThumbsDown):@"FAThumbsDown",
            @(FAYoutubeSquare):@"FAYoutubeSquare",
            @(FAYoutube):@"FAYoutube",
            @(FAXing):@"FAXing",
            @(FAXingSquare):@"FAXingSquare",
            @(FAYoutubePlay):@"FAYoutubePlay",
            @(FADropbox):@"FADropbox",
            @(FAStackOverflow):@"FAStackOverflow",
            @(FAInstagram):@"FAInstagram",
            @(FAFlickr):@"FAFlickr",
            @(FAAdn):@"FAAdn",
            @(FABitbucket):@"FABitbucket",
            @(FABitbucketSquare):@"FABitbucketSquare",
            @(FATumblr):@"FATumblr",
            @(FATumblrSquare):@"FATumblrSquare",
            @(FALongArrowDown):@"FALongArrowDown",
            @(FALongArrowUp):@"FALongArrowUp",
            @(FALongArrowLeft):@"FALongArrowLeft",
            @(FALongArrowRight):@"FALongArrowRight",
            @(FAApple):@"FAApple",
            @(FAWindows):@"FAWindows",
            @(FAAndroid):@"FAAndroid",
            @(FALinux):@"FALinux",
            @(FADribbble):@"FADribbble",
            @(FASkype):@"FASkype",
            @(FAFoursquare):@"FAFoursquare",
            @(FATrello):@"FATrello",
            @(FAFemale):@"FAFemale",
            @(FAMale):@"FAMale",
            @(FAGittip):@"FAGittip",
            @(FASunO):@"FASunO",
            @(FAMoonO):@"FAMoonO",
            @(FAArchive):@"FAArchive",
            @(FABug):@"FABug",
            @(FAVk):@"FAVk",
            @(FAWeibo):@"FAWeibo",
            @(FARenren):@"FARenren",
            @(FAPagelines):@"FAPagelines",
            @(FAStackExchange):@"FAStackExchange",
            @(FAArrowCircleORight):@"FAArrowCircleORight",
            @(FAArrowCircleOLeft):@"FAArrowCircleOLeft",
            @(FACaretSquareOLeft):@"FACaretSquareOLeft",
            @(FADotCircleO):@"FADotCircleO",
            @(FAWheelchair):@"FAWheelchair",
            @(FAVimeoSquare):@"FAVimeoSquare",
            @(FATry):@"FATry",
            @(FAPlusSquareO):@"FAPlusSquareO",
            @(FAautomobile):@"FAautomobile",
            @(FAbank):@"FAbank",
            @(FAbehance):@"FAbehance",
            @(FAbehanceSquare):@"FAbehanceSquare",
            @(FAbomb):@"FAbomb",
            @(FAbuilding):@"FAbuilding",
            @(FAcab):@"FAcab",
            @(FAcar):@"FAcar",
            @(FAchild):@"FAchild",
            @(FAcircleONotch):@"FAcircleONotch",
            @(FAcircleThin):@"FAcircleThin",
            @(FAcodepen):@"FAcodepen",
            @(FAcube):@"FAcube",
            @(FAcubes):@"FAcubes",
            @(FAdatabase):@"FAdatabase",
            @(FAdelicious):@"FAdelicious",
            @(FAdeviantart):@"FAdeviantart",
            @(FAdigg):@"FAdigg",
            @(FAdrupal):@"FAdrupal",
            @(FAempire):@"FAempire",
            @(FAenvelopeSquare):@"FAenvelopeSquare",
            @(FAfax):@"FAfax",
            @(FAfileArchiveO):@"FAfileArchiveO",
            @(FAfileAudioO):@"FAfileAudioO",
            @(FAfileCodeO):@"FAfileCodeO",
            @(FAfileExcelO):@"FAfileExcelO",
            @(FAfileImageO):@"FAfileImageO",
            @(FAfileMovieO):@"FAfileMovieO",
            @(FAfilePdfO):@"FAfilePdfO",
            @(FAfilePhotoO):@"FAfilePhotoO",
            @(FAfilePictureO):@"FAfilePictureO",
            @(FAfilePowerpointO):@"FAfilePowerpointO",
            @(FAfileSoundO):@"FAfileSoundO",
            @(FAfileVideoO):@"FAfileVideoO",
            @(FAfileWordO):@"FAfileWordO",
            @(FAfileZipO):@"FAfileZipO",
            @(FAge):@"FAge",
            @(FAgit):@"FAgit",
            @(FAgitSquare):@"FAgitSquare",
            @(FAgoogle):@"FAgoogle",
            @(FAgraduationCap):@"FAgraduationCap",
            @(FAhackerNews):@"FAhackerNews",
            @(FAheader):@"FAheader",
            @(FAhistory):@"FAhistory",
            @(FAinstitution):@"FAinstitution",
            @(FAjoomla):@"FAjoomla",
            @(FAjsfiddle):@"FAjsfiddle",
            @(FAlanguage):@"FAlanguage",
            @(FAlifeBouy):@"FAlifeBouy",
            @(FAlifeRing):@"FAlifeRing",
            @(FAlifeSaver):@"FAlifeSaver",
            @(FAmortarBoard):@"FAmortarBoard",
            @(FAopenid):@"FAopenid",
            @(FApaperPlane):@"FApaperPlane",
            @(FApaperPlaneO):@"FApaperPlaneO",
            @(FAparagraph):@"FAparagraph",
            @(FApaw):@"FApaw",
            @(FApiedPiper):@"FApiedPiper",
            @(FApiedPiperalt):@"FApiedPiperalt",
            @(FApiedPipersquare):@"FApiedPipersquare",
            @(FAqq):@"FAqq",
            @(FAra):@"FAra",
            @(FArebel):@"FArebel",
            @(FArecycle):@"FArecycle",
            @(FAreddit):@"FAreddit",
            @(FAredditSquare):@"FAredditSquare",
            @(FAsend):@"FAsend",
            @(FAsendO):@"FAsendO",
            @(FAshareAlt):@"FAshareAlt",
            @(FAshareAltSquare):@"FAshareAltSquare",
            @(FAslack):@"FAslack",
            @(FAsliders):@"FAsliders",
            @(FAsoundcloud):@"FAsoundcloud",
            @(FAspaceShuttle):@"FAspaceShuttle",
            @(FAspoon):@"FAspoon",
            @(FAspotify):@"FAspotify",
            @(FAsteam):@"FAsteam",
            @(FAsteamSquare):@"FAsteamSquare",
            @(FAstumbleupon):@"FAstumbleupon",
            @(FAstumbleuponCircle):@"FAstumbleuponCircle",
            @(FAsupport):@"FAsupport",
            @(FAtaxi):@"FAtaxi",
            @(FAtencentWeibo):@"FAtencentWeibo",
            @(FAtree):@"FAtree",
            @(FAuniversity):@"FAuniversity",
            @(FAvine):@"FAvine",
            @(FAwechat):@"FAwechat",
            @(FAweixin):@"FAweixin",
            @(FAwordpress):@"FAwordpress",
            @(FAyahoo):@"FAyahoo",
            @(FAangellist):@"FAangellist",
            @(FAareaChart):@"FAareaChart",
            @(FAat):@"FAat",
            @(FAbellSlash):@"FAbellSlash",
            @(FAbellSlashO):@"FAbellSlashO",
            @(FAbicycle):@"FAbicycle",
            @(FAbinoculars):@"FAbinoculars",
            @(FAbirthdayCake):@"FAbirthdayCake",
            @(FAbus):@"FAbus",
            @(FAcalculator):@"FAcalculator",
            @(FAcc):@"FAcc",
            @(FAccAmex):@"FAccAmex",
            @(FAccDiscover):@"FAccDiscover",
            @(FAccMastercard):@"FAccMastercard",
            @(FAccPaypal):@"FAccPaypal",
            @(FAccStripe):@"FAccStripe",
            @(FAccVisa):@"FAccVisa",
            @(FAcopyright):@"FAcopyright",
            @(FAeyedropper):@"FAeyedropper",
            @(FAfutbolO):@"FAfutbolO",
            @(FAgoogleWallet):@"FAgoogleWallet",
            @(FAils):@"FAils",
            @(FAioxhost):@"FAioxhost",
            @(FAlastfm):@"FAlastfm",
            @(FAlastfmSquare):@"FAlastfmSquare",
            @(FAlineChart):@"FAlineChart",
            @(FAmeanpath):@"FAmeanpath",
            @(FAnewspaperO):@"FAnewspaperO",
            @(FApaintBrush):@"FApaintBrush",
            @(FApaypal):@"FApaypal",
            @(FApieChart):@"FApieChart",
            @(FAplug):@"FAplug",
            @(FAshekel):@"FAshekel",
            @(FAsheqel):@"FAsheqel",
            @(FAslideshare):@"FAslideshare",
            @(FAsoccerBallO):@"FAsoccerBallO",
            @(FAtoggleOff):@"FAtoggleOff",
            @(FAtoggleOn):@"FAtoggleOn",
            @(FAtrash):@"FAtrash",
            @(FAtty):@"FAtty",
            @(FAtwitch):@"FAtwitch",
            @(FAwifi):@"FAwifi",
            @(FAyelp):@"FAyelp",
            @(FAbed):@"FAbed",
            @(FAbuysellads):@"FAbuysellads",
            @(FAcartArrowDown):@"FAcartArrowDown",
            @(FAcartPlus):@"FAcartPlus",
            @(FAconnectdevelop):@"FAconnectdevelop",
            @(FAdashcube):@"FAdashcube",
            @(FAdiamond):@"FAdiamond",
            @(FAfacebookOfficial):@"FAfacebookOfficial",
            @(FAforumbee):@"FAforumbee",
            @(FAheartbeat):@"FAheartbeat",
            @(FAhotel):@"FAhotel",
            @(FAleanpub):@"FAleanpub",
            @(FAmars):@"FAmars",
            @(FAmarsDouble):@"FAmarsDouble",
            @(FAmarsStroke):@"FAmarsStroke",
            @(FAmarsStrokeH):@"FAmarsStrokeH",
            @(FAmarsStrokeV):@"FAmarsStrokeV",
            @(FAmedium):@"FAmedium",
            @(FAmercury):@"FAmercury",
            @(FAmotorcycle):@"FAmotorcycle",
            @(FAneuter):@"FAneuter",
            @(FApinterestP):@"FApinterestP",
            @(FAsellsy):@"FAsellsy",
            @(FAserver):@"FAserver",
            @(FAship):@"FAship",
            @(FAshirtsinbulk):@"FAshirtsinbulk",
            @(FAsimplybuilt):@"FAsimplybuilt",
            @(FAskyatlas):@"FAskyatlas",
            @(FAstreetView):@"FAstreetView",
            @(FAsubway):@"FAsubway",
            @(FAtrain):@"FAtrain",
            @(FAtransgender):@"FAtransgender",
            @(FAtransgenderAlt):@"FAtransgenderAlt",
            @(FAuserPlus):@"FAuserPlus",
            @(FAuserSecret):@"FAuserSecret",
            @(FAuserTimes):@"FAuserTimes",
            @(FAvenus):@"FAvenus",
            @(FAvenusDouble):@"FAvenusDouble",
            @(FAvenusMars):@"FAvenusMars",
            @(FAviacoin):@"FAviacoin",
            @(FA500px):@"FA500px",
            @(FAamazon):@"FAamazon",
            @(FAbalanceScale):@"FAbalanceScale",
            @(FAbatteryEmpty):@"FAbatteryEmpty",
            @(FAbatteryFull):@"FAbatteryFull",
            @(FAbatteryHalf):@"FAbatteryHalf",
            @(FAbatteryQuarter):@"FAbatteryQuarter",
            @(FAbatteryThreeQuarters):@"FAbatteryThreeQuarters",
            @(FAblackTie):@"FAblackTie",
            @(FAcalendarCheckO):@"FAcalendarCheckO",
            @(FAcalendarMinusO):@"FAcalendarMinusO",
            @(FAcalendarPlusO):@"FAcalendarPlusO",
            @(FAcalendarTimesO):@"FAcalendarTimesO",
            @(FAccDinersClub):@"FAccDinersClub",
            @(FAccJcb):@"FAccJcb",
            @(FAchrome):@"FAchrome",
            @(FAclone):@"FAclone",
            @(FAcommenting):@"FAcommenting",
            @(FAcommentingO):@"FAcommentingO",
            @(FAcontao):@"FAcontao",
            @(FAcreativeCommons):@"FAcreativeCommons",
            @(FAexpeditedssl):@"FAexpeditedssl",
            @(FAfirefox):@"FAfirefox",
            @(FAfonticons):@"FAfonticons",
            @(FAgenderless):@"FAgenderless",
            @(FAgetPocket):@"FAgetPocket",
            @(FAgg):@"FAgg",
            @(FAggCircle):@"FAggCircle",
            @(FAhandLizardO):@"FAhandLizardO",
            @(FAhandPaperO):@"FAhandPaperO",
            @(FAhandPeaceO):@"FAhandPeaceO",
            @(FAhandPointerO):@"FAhandPointerO",
            @(FAhandRockO):@"FAhandRockO",
            @(FAhandScissorsO):@"FAhandScissorsO",
            @(FAhandSpockO):@"FAhandSpockO",
            @(FAhourglass):@"FAhourglass",
            @(FAhourglassEnd):@"FAhourglassEnd",
            @(FAhourglassHalf):@"FAhourglassHalf",
            @(FAhourglassO):@"FAhourglassO",
            @(FAhourglassStart):@"FAhourglassStart",
            @(FAhouzz):@"FAhouzz",
            @(FAiCursor):@"FAiCursor",
            @(FAindustry):@"FAindustry",
            @(FAinternetExplorer):@"FAinternetExplorer",
            @(FAmap):@"FAmap",
            @(FAmapO):@"FAmapO",
            @(FAmapPin):@"FAmapPin",
            @(FAmapSigns):@"FAmapSigns",
            @(FAmousePointer):@"FAmousePointer",
            @(FAobjectGroup):@"FAobjectGroup",
            @(FAobjectUngroup):@"FAobjectUngroup",
            @(FAodnoklassniki):@"FAodnoklassniki",
            @(FAodnoklassnikiSquare):@"FAodnoklassnikiSquare",
            @(FAopencart):@"FAopencart",
            @(FAopera):@"FAopera",
            @(FAoptinMonster):@"FAoptinMonster",
            @(FAregistered):@"FAregistered",
            @(FAsafari):@"FAsafari",
            @(FAstickyNote):@"FAstickyNote",
            @(FAstickyNoteO):@"FAstickyNoteO",
            @(FAtelevision):@"FAtelevision",
            @(FAtrademark):@"FAtrademark",
            @(FAtripadvisor):@"FAtripadvisor",
            @(FAvimeo):@"FAvimeo",
            @(FAwikipediaW):@"FAwikipediaW",
            @(FAyCombinator):@"FAyCombinator",
            @(FAredditAlien):@"FAredditAlien",
            @(FAedge):@"FAedge",
            @(FAcreditCardAlt):@"FAcreditCardAlt",
            @(FAcodiepie):@"FAcodiepie",
            @(FAmodx):@"FAmodx",
            @(FAfortAwesome):@"FAfortAwesome",
            @(FAusb):@"FAusb",
            @(FAproductHunt):@"FAproductHunt",
            @(FAmixcloud):@"FAmixcloud",
            @(FAscribd):@"FAscribd",
            @(FApauseCircle):@"FApauseCircle",
            @(FApauseCircleO):@"FApauseCircleO",
            @(FAstopCircle):@"FAstopCircle",
            @(FAstopCircleO):@"FAstopCircleO",
            @(FAshoppingBag):@"FAshoppingBag",
            @(FAshoppingBasket):@"FAshoppingBasket",
            @(FAhashtag):@"FAhashtag",
            @(FAbluetooth):@"FAbluetooth",
            @(FAbluetoothB):@"FAbluetoothB",
            @(FApercent):@"FApercent",
            @(FAgitlab):@"FAgitlab",
            @(FAwpbeginner):@"FAwpbeginner",
            @(FAwpforms):@"FAwpforms",
            @(FAenvira):@"FAenvira",
            @(FAuniversalAccess):@"FAuniversalAccess",
            @(FAwheelchairAlt):@"FAwheelchairAlt",
            @(FAquestionCircleO):@"FAquestionCircleO",
            @(FAblind):@"FAblind",
            @(FAaudioDescription):@"FAaudioDescription",
            @(FAvolumeControlPhone):@"FAvolumeControlPhone",
            @(FAbraille):@"FAbraille",
            @(FAassistiveListeningSystems):@"FAassistiveListeningSystems",
            @(FAaslInterpreting):@"FAaslInterpreting",
            @(FAdeaf):@"FAdeaf",
            @(FAglide):@"FAglide",
            @(FAglideG):@"FAglideG",
            @(FAsigning):@"FAsigning",
            @(FAlowVision):@"FAlowVision",
            @(FAviadeo):@"FAviadeo",
            @(FAviadeoSquare):@"FAviadeoSquare",
            @(FAsnapchat):@"FAsnapchat",
            @(FAsnapchatGhost):@"FAsnapchatGhost",
            @(FAfirstOrder):@"FAfirstOrder",
            @(FAyoast):@"FAyoast",
            @(FAthemeisle):@"FAthemeisle",
            @(FAgooglePlusOfficial):@"FAgooglePlusOfficial",
            @(FAfontAwesome):@"FAfontAwesome",
            @(FAhandshakeO):@"FAhandshakeO",
            @(FAenvelopeOpen):@"FAenvelopeOpen",
            @(FAenvelopeOpenO):@"FAenvelopeOpenO",
            @(FAlinode):@"FAlinode",
            @(FAaddressBook):@"FAaddressBook",
            @(FAaddressBookO):@"FAaddressBookO",
            @(FAvcard):@"FAvcard",
            @(FAvcardO):@"FAvcardO",
            @(FAuserCircle):@"FAuserCircle",
            @(FAuserCircleO):@"FAuserCircleO",
            @(FAuserO):@"FAuserO",
            @(FAidBadge):@"FAidBadge",
            @(FAidCard):@"FAidCard",
            @(FAidCardO):@"FAidCardO",
            @(FAquora):@"FAquora",
            @(FAfreeCodeCamp):@"FAfreeCodeCamp",
            @(FAtelegram):@"FAtelegram",
            @(FAthermometerFull):@"FAthermometerFull",
            @(FAthermometerThreeQuarters):@"FAthermometerThreeQuarters",
            @(FAthermometerHalf):@"FAthermometerHalf",
            @(FAthermometerQuarter):@"FAthermometerQuarter",
            @(FAthermometerEmpty):@"FAthermometerEmpty",
            @(FAshower):@"FAshower",
            @(FAbath):@"FAbath",
            @(FApodcast):@"FApodcast",
            @(FAwindowMaximize):@"FAwindowMaximize",
            @(FAwindowMinimize):@"FAwindowMinimize",
            @(FAwindowRestore):@"FAwindowRestore",
            @(FAwindowClose):@"FAwindowClose",
            @(FAwindowCloseO):@"FAwindowCloseO",
            @(FAbandcamp):@"FAbandcamp",
            @(FAgrav):@"FAgrav",
            @(FAetsy):@"FAetsy",
            @(FAimdb):@"FAimdb",
            @(FAravelry):@"FAravelry",
            @(FAeercast):@"FAeercast",
            @(FAmicrochip):@"FAmicrochip",
            @(FAsnowflakeO):@"FAsnowflakeO",
            @(FAsuperpowers):@"FAsuperpowers",
            @(FAwpexplorer):@"FAwpexplorer",
            @(FAmeetup):@"FAmeetup",
        };
    }
    return _fontsDic;
}

@end

//
//  DecorationLayout.h
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 要用装饰视图，就得自定义layout
// 记得初始化的时候，要设置itemSize,各种gap等基本布局属性

static NSString* const sDecorationKey = @"sDecorationKey";

@interface DecorationLayout : UICollectionViewLayout

// 最小行间距
@property (nonatomic) CGFloat minimumLineSpacing;
// 最小列间距
@property (nonatomic) CGFloat minimumInteritemSpacing;
// cell的大小
@property (nonatomic) CGSize itemSize;
// 头部size
@property (nonatomic) CGSize headerReferenceSize;
// 尾部size
@property (nonatomic) CGSize footerReferenceSize;
// 分部周围间距
@property (nonatomic) UIEdgeInsets sectionInset;
// 装饰区的周围间距
@property (nonatomic) UIEdgeInsets decorationInset;

@property (nonatomic, strong) Class decorationClass;


@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
@end

NS_ASSUME_NONNULL_END

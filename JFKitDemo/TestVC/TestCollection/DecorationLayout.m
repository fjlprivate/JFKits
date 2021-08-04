//
//  DecorationLayout.m
//  JFTools
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/9.
//

#import "DecorationLayout.h"


// 1. 先计算出所有元素的layoutAttributes,待后续的接口调用
// 2. 返回上一部计算的contentSize值
// 3. 返回可见区域内的所有元素的布局;[cell、Supplementary、Decoration]
// 4. 返回具体索引的cell的布局属性
// 4. 返回具体索引的Supplementary的布局属性
// 4. 返回具体索引的Decoration的布局属性



@interface DecorationLayout()
@property (nonatomic, assign) CGSize contentSize;

/* 所有元素布局对象集
 indexpath:cell布局对象
 Header[section]:Header布局对象
 Footer[section]:Footer布局对象
 Decoration[section]:Decoration布局对象
 */
@property (nonatomic, strong) NSDictionary* allElementsLayoutAttri;

@end

@implementation DecorationLayout

// 1. 先计算出所有的layoutAttributes,待后续的接口调用
- (void)prepareLayout {
    [super prepareLayout];
    [self registerClass:self.decorationClass forDecorationViewOfKind:sDecorationKey];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        [self prepareLayoutOnDirectionV];
    } else {
        [self prepareLayoutOnDirectionH];
    }
}

// 2. 返回上一部计算的contentSize值
- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

// 3. 返回可见区域内的所有元素的布局;[cell、Supplementary、decoration]
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* list = @[].mutableCopy;
    for (UICollectionViewLayoutAttributes* layoutAttri in self.allElementsLayoutAttri.allValues) {
        if (CGRectIntersectsRect(rect, layoutAttri.frame)) {
            [list addObject:layoutAttri];
        }
    }
    return list;
}


// 4. 返回具体索引的cell的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.allElementsLayoutAttri[indexPath];
}

// 4. 返回具体索引的Supplementary的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.allElementsLayoutAttri[[self headerKeyForSection:indexPath.section]];
    } else {
        return self.allElementsLayoutAttri[[self footerKeyForSection:indexPath.section]];
    }
}

// 4. 返回具体索引的Decoration的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.allElementsLayoutAttri[[self decorationKeyForSection:indexPath.section]];
}

# pragma mark - private

// 计算垂直滚动方向的所有布局
- (void) prepareLayoutOnDirectionV {
    NSMutableDictionary* mulDic = @{}.mutableCopy;
    
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    CGFloat collectionHeight = 0;
    NSInteger sections = [self.collectionView numberOfSections];
    
    // 计算一行显示几个cell和真实的item列间距
    CGFloat startCellX = self.sectionInset.left;
    CGFloat availableWidth = collectionWidth - self.sectionInset.left - self.sectionInset.right;
    NSInteger countOfCellPerLine = 0;
    CGFloat tmpWidth = 0;
    while (tmpWidth < availableWidth) {
        tmpWidth += self.itemSize.width;
        if (tmpWidth < availableWidth) {
            countOfCellPerLine ++;
            tmpWidth += self.minimumInteritemSpacing;
        }
    }
    // 真实的item列间距
    CGFloat trueInteritemSpacing = 0;
    if (countOfCellPerLine > 1) {
        trueInteritemSpacing = floor((availableWidth - countOfCellPerLine * self.itemSize.width)/(countOfCellPerLine - 1));
    }
    trueInteritemSpacing = MAX(self.minimumInteritemSpacing, trueInteritemSpacing);
    
    
    
    // 遍历分部
    for (NSInteger section = 0; section < sections; section++) {
        // y定位到当前section起始位置
        collectionHeight += self.sectionInset.top;
        
        CGFloat startDecorationY = collectionHeight;
        
        // > 装载 Header
        CGRect sectionHeaderFrame = CGRectMake(self.sectionInset.left,
                                               collectionHeight,
                                               // headerWidth不能大于collectionWidth
                                               MIN(self.headerReferenceSize.width, availableWidth),
                                               self.headerReferenceSize.height);
        
        // 生成header的layoutAttribute
        UICollectionViewLayoutAttributes* headerLayoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        headerLayoutAttri.frame = sectionHeaderFrame;
        [mulDic setObject:headerLayoutAttri forKey:[self headerKeyForSection:section]];
        
        
        collectionHeight += self.headerReferenceSize.height;
        
        // > 装载 cells
        collectionHeight += self.minimumLineSpacing;
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        NSInteger tmpCount = 0;
        CGFloat tmpX = startCellX;
        for (NSInteger row = 0; row < rows; row++) {
            CGRect cellFrame = CGRectMake(tmpX, collectionHeight, self.itemSize.width, self.itemSize.height);
            UICollectionViewLayoutAttributes* cellLayoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            cellLayoutAttri.frame = cellFrame;
            [mulDic setObject:cellLayoutAttri forKey:[NSIndexPath indexPathForRow:row inSection:section]];
            
            tmpCount++;
            tmpX += self.itemSize.width + trueInteritemSpacing;
            
            if (tmpCount >= countOfCellPerLine) {
                tmpCount = 0;
                tmpX = startCellX;
                collectionHeight += self.itemSize.height;
                collectionHeight += self.minimumLineSpacing;
            }
        }
        // 最后一行cells加载完后，如果未加载满，也要追加height
        if (tmpCount > 0 && tmpCount < countOfCellPerLine) {
            collectionHeight += self.itemSize.height;
            collectionHeight += self.minimumLineSpacing;
        }
        
        // > 装载 footer
        CGRect sectionFooterFrame = CGRectMake(self.sectionInset.left,
                                               collectionHeight,
                                               // headerWidth不能大于collectionWidth
                                               MIN(self.footerReferenceSize.width, availableWidth),
                                               self.footerReferenceSize.height);
        
        // 生成header的layoutAttribute
        UICollectionViewLayoutAttributes* footerLayoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        footerLayoutAttri.frame = sectionFooterFrame;
        [mulDic setObject:footerLayoutAttri forKey:[self footerKeyForSection:section]];

        collectionHeight += self.footerReferenceSize.height;

        
        // > 装载 decoration
        CGFloat decorationHeight = collectionHeight - startDecorationY;
        CGRect decorationFrame = CGRectMake(self.decorationInset.left,
                                            startDecorationY + self.decorationInset.top,
                                            collectionWidth - self.decorationInset.left - self.decorationInset.right,
                                            decorationHeight - self.decorationInset.top - self.decorationInset.bottom);
        UICollectionViewLayoutAttributes* decorationLayoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:sDecorationKey withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        decorationLayoutAttri.frame = decorationFrame;
        decorationLayoutAttri.zIndex = -1;
        [mulDic setObject:decorationLayoutAttri forKey:[self decorationKeyForSection:section]];

        
        // y定位到当前section尾部
        collectionHeight += self.sectionInset.bottom;
    }

    self.contentSize = CGSizeMake(collectionWidth, collectionHeight);
    self.allElementsLayoutAttri = mulDic.copy;
}
// 计算水平滚动方向的所有布局
- (void) prepareLayoutOnDirectionH {
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    CGFloat collectionHeight = self.collectionView.bounds.size.height;
    NSInteger sections = [self.collectionView numberOfSections];
    // 遍历分部
    for (NSInteger section = 0; section < sections; section++) {
        
        // 遍历分部.cells
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        
    }

}


- (NSString*) headerKeyForSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Header%ld", section];
}
- (NSString*) footerKeyForSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Footer%ld", section];
}
- (NSString*) decorationKeyForSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Decoration%ld", section];
}


@end

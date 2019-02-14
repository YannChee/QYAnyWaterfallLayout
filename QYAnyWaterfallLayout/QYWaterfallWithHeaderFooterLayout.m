//
//  QYWaterfallWithHeaderFooterLayout.m
//  QYWaterfall
//
//  Created by YannChee
//  Copyright © 2017年 YannChee. All rights reserved.
//

#import "QYWaterfallWithHeaderFooterLayout.h"


/*      默认值    */
static const CGFloat inset = 0.5;
static const CGFloat colCount = 3;

/** headerFooter 默认的size  */
static const CGSize QYDefaultHeaderFooterSize = {0, 0};




@interface QYWaterfallWithHeaderFooterLayout ()
//
@property (nonatomic, strong) NSMutableDictionary *colunMaxYDic;
@end

@implementation QYWaterfallWithHeaderFooterLayout

- (instancetype)init
{
    if (self=[super init]) {
        self.itemSpacing = inset;
        self.lineSpacing = inset;
        self.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        self.colCount = colCount;
        self.colunMaxYDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionViewContentSize {
    __block NSString * maxCol = @"0";
    // 找出最高的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString* key,NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] > [self.colunMaxYDic[maxCol] floatValue]) {
            maxCol = key;
        }
    }];
     return CGSizeMake(0, [self.colunMaxYDic[maxCol] floatValue]);
}
#pragma mark - 设置item
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
     __block NSString * minCol = @"0";
    // 遍历找出最短的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSNumber *minY, BOOL * _Nonnull stop) {
        if ([minY floatValue] < [self.colunMaxYDic[minCol] floatValue]) {
            minCol = key;
        }
    }];
    //    宽度
    CGFloat width = (self.collectionView.bounds.size.width - 2) / 3.0;
    CGFloat height = 100;
    CGSize itemSize = CGSizeMake(width, height);
    if (self.setupItemSizeAtIndexPath) {
        itemSize = self.setupItemSizeAtIndexPath(indexPath);
    }

    CGFloat x = self.sectionInset.left + (itemSize.width + self.itemSpacing) * [minCol intValue];
    
    CGFloat space = 0.0;
    if (indexPath.item < self.colCount) {
        space = 0.0;
    }else{
        space = self.lineSpacing;
    }
    CGFloat y =[self.colunMaxYDic[minCol] floatValue] + space;
    //    跟新对应列的高度
    self.colunMaxYDic[minCol] = @(y + itemSize.height);
    //    计算位置
    UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
    
    return attri;
}

#pragma mark - 设置headerFooter高度
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    __block NSString * maxCol = @"0";
    //遍历找出最高的列
    [self.colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSNumber *maxY, BOOL * _Nonnull stop) {
        if (maxY.floatValue > [self.colunMaxYDic[maxCol] floatValue]) {
            maxCol = key;
        }
    }];
    
#pragma mark 调用block 更新 headrFooter 的 size
    CGSize headerFooterSize = QYDefaultHeaderFooterSize;
    if (self.setupHeaderFooterSupplementaryElementSizeAtIndexPath) {
        headerFooterSize = self.setupHeaderFooterSupplementaryElementSizeAtIndexPath(elementKind,indexPath);
    }
    
    // header
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        // 1.
        UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        //
        
        CGFloat x = self.sectionInset.left;
        CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue] + self.sectionInset.top;
        //    跟新所有对应列的高度
        for(NSString *key in self.colunMaxYDic.allKeys)
        {
            self.colunMaxYDic[key] = @(y + headerFooterSize.height);
        }
        attri.frame = CGRectMake(x , y,headerFooterSize.width,headerFooterSize.height);
        return attri;
    }
    
    // footer
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    //
    CGFloat x = self.sectionInset.left;
    CGFloat y = [[self.colunMaxYDic objectForKey:maxCol] floatValue];
    // update 所有对应列的高度
    for(NSString *key in self.colunMaxYDic.allKeys)
    {
        self.colunMaxYDic[key] = @(y + headerFooterSize.height + self.sectionInset.bottom);
    }
    //
    attri.frame = CGRectMake(x , y, headerFooterSize.width, headerFooterSize.height);
    return attri;
}

#pragma mark - 返回所有布局数组
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    for(NSInteger i = 0;i < self.colCount; i++)
    {
        NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
        self.colunMaxYDic[col] = @0;
    }
    //
    NSMutableArray * attrsArray = [NSMutableArray array];
    //
    NSInteger section = [self.collectionView numberOfSections];
    for (NSInteger i = 0 ; i < section; i++) {
        
        //获取header的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:headerAttrs];
        
        //获取item的UICollectionViewLayoutAttributes
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [attrsArray addObject:attrs];
        }
        
        //获取footer的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [attrsArray addObject:footerAttrs];
    }
    return  attrsArray;
}
@end

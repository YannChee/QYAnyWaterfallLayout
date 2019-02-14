//
//  QYWaterfallWithHeaderFooterLayout.h
//  QYWaterfall
//
//  Created by YannChee
//  Copyright © 2017年 YannChee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYWaterfallWithHeaderFooterLayout : UICollectionViewLayout

@property(nonatomic, assign)UIEdgeInsets sectionInset; //sectionInset
@property(nonatomic, assign)CGFloat lineSpacing;  //line space
@property(nonatomic, assign)CGFloat itemSpacing; //item space
@property(nonatomic, assign)CGFloat colCount; //column count

//

/** 设置 每一个Item的size 的block */
@property (nonatomic,strong) CGSize (^setupItemSizeAtIndexPath)(NSIndexPath* indexPath);

/** 设置 每一个sectionHeader的size 的block */
@property (nonatomic,strong) CGSize(^setupHeaderFooterSupplementaryElementSizeAtIndexPath)(NSString *elementKind ,NSIndexPath *indexPath);

@end

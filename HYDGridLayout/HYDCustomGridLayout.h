//
//  HYDCustomGridLayout.h
//  HYDGridLayout
//
//  Created by Simon Hall on 21/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYDCustomGridLayoutDelegate;

@interface HYDCustomGridLayout : UICollectionViewLayout

@property (nonatomic, weak) id<HYDCustomGridLayoutDelegate> delegate;

@end

@protocol HYDCustomGridLayoutDelegate <NSObject>

- (CGFloat)gridWidthForCustomGridLayout:(HYDCustomGridLayout *)layout;
- (CGFloat)columnWidthForCustomGridLayout:(HYDCustomGridLayout *)layout;
- (CGFloat)minInterItemSpacingVerticalForCustomGridLayout:(HYDCustomGridLayout *)layout;
- (CGFloat)minInterItemSpacingHorizontalForCustomGridLayout:(HYDCustomGridLayout *)layout;
- (UIEdgeInsets)marginForCustomGridLayout:(HYDCustomGridLayout *)layout;

- (CGSize)customGridLayout:(HYDCustomGridLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath; //Need this??
- (NSUInteger)customGridLayout:(HYDCustomGridLayout *)layout spanXForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)customGridLayout:(HYDCustomGridLayout *)layout spanYForItemAtIndexPath:(NSIndexPath *)indexPath;
- (id)customGridLayout:(HYDCustomGridLayout *)layout gridCellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


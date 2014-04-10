//
//  HYDGrid.h
//  HYDGridLayout
//
//  Created by Simon Hall on 22/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    NSUInteger x;
    NSUInteger y;
} HYDGridRef;

typedef struct {
    CGFloat xSpacing;
    CGFloat ySpacing;
} HYDGridInterItemSpacing;

typedef NSNumber HYDRowNumber;

@interface HYDGrid : NSObject

@property (nonatomic, assign, readonly) CGFloat gridWidth;
@property (nonatomic, assign, readonly) CGFloat columnWidth;
@property (nonatomic, assign, readonly) UIEdgeInsets margins;
@property (nonatomic, assign, readonly) CGFloat cellContentWidth;
@property (nonatomic, assign, readonly) NSUInteger numberOfColumns;
@property (nonatomic, assign, readonly) HYDGridInterItemSpacing spacing;

- (NSUInteger)numberOfRowsInGrid;
- (CGPoint)originForItemAtGridRef:(HYDGridRef)gridRef;
- (CGSize)sizeForItemSpanningX:(NSUInteger)spanX andSpanningY:(NSUInteger)spanY;
- (HYDGridRef)insertItemAtIndexPath:(NSIndexPath *)indexPath withSpanX:(NSUInteger)spanX andSpanY:(NSInteger)spanY;
- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns gridWidth:(CGFloat)width gridMargins:(UIEdgeInsets)margins gridSpacing:(HYDGridInterItemSpacing)spacing;

@end

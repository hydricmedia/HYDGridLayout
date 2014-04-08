//
//  HYDCustomGridLayout.m
//  HYDGridLayout
//
//  Created by Simon Hall on 21/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDCustomGridLayout.h"
#import "HYDGrid.h"

@interface HYDCustomGridLayout ()

@property (nonatomic, strong) HYDGrid *grid;
@property (nonatomic, strong) NSMutableDictionary *layoutInfo;

@end

@implementation HYDCustomGridLayout

#pragma mark - Lifecycle
- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
}

#pragma mark - Accessors

- (NSMutableDictionary *)layoutInfo {
    
    if (!_layoutInfo) {
        _layoutInfo = [NSMutableDictionary new];
    }
    
    return _layoutInfo;
}


- (HYDGrid *)grid {
    if (!_grid) {
        _grid = [[HYDGrid alloc] initWithNumberOfColumns:[self numberOfColumns] andGridWidth:[self gridWidth]];
    }
    
    return _grid;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark - Layout

- (void)prepareLayout
{
    self.grid = nil;

    NSIndexPath *indexPath;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger item = 0; item < itemCount; item++) {
        
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        NSUInteger spanX = [self spanXForItemAtIndexPath:indexPath];
        NSUInteger spanY = [self spanYForItemAtIndexPath:indexPath];

        HYDGridRef gridRef = {0, 0};
        
        while (gridRef.x == 0 && gridRef.y == 0) {
            gridRef = [self.grid insertItemAtIndexPath:indexPath withSpanX:spanX andSpanY:spanY];
        }

        CGPoint origin = [self originForItemWithGridRef:gridRef];
        CGSize size = [self sizeForItemWithSpanX:spanX andSpanY:spanY];
        
        attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        self.layoutInfo[indexPath] = attributes;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray new];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:self.layoutInfo[indexPath]];
        }
    }];
    
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[indexPath];
}

- (CGSize)collectionViewContentSize {
    
    CGFloat height = [self.grid numberOfRowsInGrid] * self.grid.columnWidth;
    return CGSizeMake(self.grid.gridWidth, height);
}

#pragma mark - Helpers

- (CGFloat)gridWidth {
    
    CGFloat gridWidth = CGRectGetWidth(self.collectionView.bounds);
    
    if ([self.delegate respondsToSelector:@selector(gridWidthForCustomGridLayout:)]) {
        gridWidth = [self.delegate gridWidthForCustomGridLayout:self];
    }
    
    return gridWidth;
}

- (NSUInteger)numberOfColumns {
    
    NSUInteger numColumns = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfColumnsForCustomGridLayout:)]) {
        numColumns = [self.delegate numberOfColumnsForCustomGridLayout:self];
    }
    
    return numColumns;
}

- (CGSize)sizeForItemWithSpanX:(NSInteger)spanX andSpanY:(NSInteger)spanY {
    
    CGSize itemSize = CGSizeZero;
    UIEdgeInsets margins = UIEdgeInsetsZero;
    
    if ([self.delegate respondsToSelector:@selector(marginForCustomGridLayout:)]) {
        margins = [self.delegate marginForCustomGridLayout:self];
    }
    
    itemSize.width = self.grid.columnWidth * spanX;
    itemSize.height = self.grid.columnWidth * spanY;

    return itemSize;
}

- (CGPoint)originForItemWithGridRef:(HYDGridRef)gridRef {
    
    CGFloat xPosition = (gridRef.x -1) * self.grid.columnWidth;
    CGFloat yPosition = (gridRef.y -1) * self.grid.columnWidth;

    return CGPointMake(xPosition, yPosition);
}

- (NSUInteger)spanXForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger spanX;
    if ([self.delegate respondsToSelector:@selector(customGridLayout:spanXForItemAtIndexPath:)]) {
        spanX = [self.delegate customGridLayout:self spanXForItemAtIndexPath:indexPath];
    }
    
    return spanX;
}

- (NSUInteger)spanYForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger spanY;
    if ([self.delegate respondsToSelector:@selector(customGridLayout:spanYForItemAtIndexPath:)]) {
        spanY = [self.delegate customGridLayout:self spanYForItemAtIndexPath:indexPath];
    }
    
    return spanY;
}

@end

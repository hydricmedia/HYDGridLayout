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
@property (nonatomic, assign) CGFloat gridWidth; //should be part of grid
@property (nonatomic, assign) CGFloat columnWidth;

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) NSUInteger numberOfColumns;

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
        _grid = [[HYDGrid alloc] initWithNumberOfColumns:self.numberOfColumns];
    }
    
    return _grid;
}

- (NSUInteger)numberOfColumns {
    
    NSUInteger numColumns = 0;
    
    if ([self.delegate respondsToSelector:@selector(columnWidthForCustomGridLayout:)]) {
        self.columnWidth = [self.delegate columnWidthForCustomGridLayout:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(gridWidthForCustomGridLayout:)]) {
        self.gridWidth = [self.delegate gridWidthForCustomGridLayout:self];
    }
    
    numColumns = roundf(self.gridWidth / self.columnWidth); //must consider margin and interItemSpacing
    
    return numColumns;
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
    
    CGFloat width = 0.f;
    
    if ([self.delegate respondsToSelector:@selector(gridWidthForCustomGridLayout:)]) {
        width = [self.delegate gridWidthForCustomGridLayout:self];
    } else {
        width = CGRectGetWidth(self.collectionView.bounds);
    }

    if (self.columnWidth == 0.f) {
        if ([self.delegate respondsToSelector:@selector(columnWidthForCustomGridLayout:)]) {
            self.columnWidth = [self.delegate columnWidthForCustomGridLayout:self];
        }
    }
    
    NSUInteger numberOfRowsInGrid = [self.grid numberOfRowsInGrid];
    CGFloat height = numberOfRowsInGrid * self.columnWidth;
    
    return CGSizeMake(width, height);
}

#pragma mark - Helpers

- (CGSize)sizeForItemWithSpanX:(NSInteger)spanX andSpanY:(NSInteger)spanY {
    
    CGSize itemSize = CGSizeZero;

    if (self.columnWidth == 0.f) {
        if ([self.delegate respondsToSelector:@selector(columnWidthForCustomGridLayout:)]) {
            self.columnWidth = [self.delegate columnWidthForCustomGridLayout:self];
        }
    }

    itemSize.width = self.columnWidth * spanX;
    itemSize.height = self.columnWidth * spanY;

    return itemSize;
}

- (CGPoint)originForItemWithGridRef:(HYDGridRef)gridRef {
    
    if (self.columnWidth == 0.f) {
        if ([self.delegate respondsToSelector:@selector(columnWidthForCustomGridLayout:)]) {
            self.columnWidth = [self.delegate columnWidthForCustomGridLayout:self];
        }
    }
    
    CGFloat xPosition = (gridRef.x -1) * self.columnWidth;
    CGFloat yPosition = (gridRef.y -1) * self.columnWidth;

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

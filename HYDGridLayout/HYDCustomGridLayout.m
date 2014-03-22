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
- (HYDGrid *)grid {
    if (!_grid) {
        _grid = [[HYDGrid alloc] initWithNumberOfColumns:[self numberOfColumns]];
    }
    
    return _grid;
}

#pragma mark - Layout

- (void)prepareLayout
{
    NSIndexPath *indexPath;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger item = 0; item < itemCount; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

        CGSize itemSize = [self sizeForItemAtIndexPath:indexPath];
        CGPoint origin  = [self originForItemAtIndexPath:indexPath];
        
        id identifier;
        if ([self.delegate respondsToSelector:@selector(customGridLayout:gridCellIdentifierForItemAtIndexPath:)]) {
            identifier = [self.delegate customGridLayout:self gridCellIdentifierForItemAtIndexPath:indexPath];
        }
        NSUInteger spanX;
        if ([self.delegate respondsToSelector:@selector(customGridLayout:spanXForItemAtIndexPath:)]) {
            spanX = [self.delegate customGridLayout:self spanXForItemAtIndexPath:indexPath];
        }
        
        HYDGridRef gridRef = [self.grid addItem:identifier withSpanX:spanX andSpanY:1 completion:^(BOOL itemAdded) {
            if (!itemAdded) {
                
            }
        }];
        
        //Work out the origin from the origin grid ref
        
        attributes.frame = CGRectMake(origin.x, origin.y, itemSize.width, itemSize.height);
        
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
    
}

#pragma mark - Helpers

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    CGSize itemSize;
    if ([self.delegate respondsToSelector:@selector(customGridLayout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.delegate customGridLayout:self sizeForItemAtIndexPath:indexPath];
    }
    
    return itemSize;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end

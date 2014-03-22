//
//  HYDCustomGridLayout.m
//  HYDGridLayout
//
//  Created by Simon Hall on 21/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDCustomGridLayout.h"

@interface HYDCustomGridLayout ()

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

#pragma mark - Layout

- (void)prepareLayout
{
    NSIndexPath *indexPath;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger item = 0; item < itemCount; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

        CGSize itemSize = [self sizeForItemAtIndexPath:indexPath];
        CGPoint origin  = [self originForItemAtIndexPath:indexPath];
        
        itemAttributes.frame = CGRectMake(origin.x, origin.y, itemSize.width, itemSize.height);
        
        self.layoutInfo[indexPath] = itemAttributes;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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

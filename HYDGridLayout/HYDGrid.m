//
//  HYDGrid.m
//  HYDGridLayout
//
//  Created by Simon Hall on 22/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDGrid.h"

@interface HYDGrid ()

@property (nonatomic, strong) NSMutableArray *grid;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat columnWidth;

@end

@implementation HYDGrid

- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns andGridWidth:(CGFloat)width {
    
    self = [super init];
    if (self) {
        _grid = [NSMutableArray new];
        _gridWidth = width;
        _numberOfColumns = numberOfColumns;
        _columnWidth = floor(width/numberOfColumns);
    }

    return self;
}

#pragma mark - Public methods

- (id)identifierForGridRef:(HYDGridRef)gridRef {
    
    id identifier;
    NSArray *row = self.grid[gridRef.y];
    if (row) {
        identifier = row[gridRef.x];
    }
    
    return identifier;
}

- (NSUInteger)numberOfRowsInGrid {
    return [self.grid count];
}

- (HYDGridRef)insertItemAtIndexPath:(NSIndexPath *)indexPath withSpanX:(NSUInteger)spanX andSpanY:(NSInteger)spanY
{
    __block BOOL itemAdded = NO;
    __block HYDGridRef filledGridRef = {0, 0};
    
    // Traverse the grid impressing the grid onto the item for each grid position.
    // If the impression (mappedItem) is empty then the mappedItem will fill the grid at that gridRef
    
    [self.grid enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowNumber, BOOL *outerStop) {
        
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger columnNumber, BOOL *innerStop) {
            
            HYDGridRef gridRef = {columnNumber + 1, rowNumber + 1};
            NSArray *mappedItem = [self mapForGridRef:gridRef withSpanX:spanX andSpanY:spanY];
            
            if (mappedItem && [self mappedItemIsEmpty:mappedItem]) {
                [self addMappedItem:mappedItem withIdendifier:indexPath.item toGridRef:gridRef];
                filledGridRef = gridRef;
                *innerStop = itemAdded = YES;
            }
        }];
        
        *outerStop = itemAdded;
    }];
    
    if (!itemAdded) {
        [self addNewRow];
    }
    
    return filledGridRef;
}

#pragma mark - Private methods

- (void)addNewRow {
    
    NSMutableArray *newRow = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
    for (NSUInteger i = 0; i < self.numberOfColumns; i++) {
        [newRow addObject:[NSNull null]];
    }
    
    [self.grid addObject:newRow];
}

- (BOOL)mappedItemIsEmpty:(NSArray *)mappedItem
{
    __block BOOL isFilled = NO;
    
    [mappedItem enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowNumber, BOOL *outerStop) {
        [row enumerateObjectsUsingBlock:^(id identifier, NSUInteger columnNumber, BOOL *innerStop) {
            *innerStop = isFilled = ![identifier isEqual:[NSNull null]];
        }];
        
        *outerStop = isFilled;
    }];
    
    return !isFilled;
}

- (void)addMappedItem:(NSArray *)mappedItem withIdendifier:(NSUInteger)identifier toGridRef:(HYDGridRef)gridRef
{
    NSUInteger lastColIndex = gridRef.x - 1 + [[mappedItem firstObject] count];
    NSUInteger lastRowIndex = gridRef.y - 1 + [mappedItem count];

    for (NSUInteger rowIndex=gridRef.y - 1; rowIndex < lastRowIndex; rowIndex++) {
        for (NSUInteger colIndex=gridRef.x - 1; colIndex <  lastColIndex; colIndex++) {
            NSMutableArray *gridRow = self.grid[rowIndex];
            gridRow[colIndex] = @(identifier);
        }
    }
}

- (NSArray *)mapForGridRef:(HYDGridRef)gridRef withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY
{
    NSUInteger rowIndex = gridRef.y - 1;
    NSUInteger colIndex = gridRef.x - 1;

    if ((colIndex + spanX) > self.numberOfColumns) {
        return nil;
    }

    NSMutableArray *mappedRows = [NSMutableArray arrayWithCapacity:spanY];
    NSMutableArray *mappedItem = [NSMutableArray arrayWithCapacity:spanY];
    
    for (NSUInteger i=rowIndex; i < rowIndex + spanY; i++) {
        
        if (i == [self.grid count]) {
            [self addNewRow];
        }
        
        [mappedRows addObject:self.grid[i]];
    }

    [mappedRows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger idx, BOOL *stop) {
        NSMutableArray *newRow = [NSMutableArray arrayWithCapacity:spanX];
        for (NSUInteger i=colIndex; i < colIndex + spanX; i++) {
            [newRow addObject:row[i]];
        }
        [mappedItem addObject:newRow];
    }];
    
    return mappedItem;
}

@end

//
//  HYDGrid.m
//  HYDGridLayout
//
//  Created by Simon Hall on 22/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDGrid.h"

@interface HYDGrid ()

@property (nonatomic, strong) NSMutableDictionary *grid;
@property (nonatomic, assign) NSUInteger numberOfColumns;

@end

@implementation HYDGrid

- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns {
    
    // Instantiate an empty grid
    
    self = [super init];
    if (self) {
        _grid = [NSMutableDictionary new];
        _numberOfColumns = numberOfColumns;
    }

    return self;
}

- (id)identifierForGridRef:(HYDGridRef)gridRef {
    
    // Get the row, then get the cell within the row using the column reference (x)
    
    id identifier;
    NSArray *row = [self.grid objectForKey:@(gridRef.y)];
    if (row) {
        identifier = row[gridRef.x];
    }
    
    return identifier;
}

#pragma mark - Public methods

- (NSUInteger)numberOfRowsInGrid {
    return [self.grid count];
}

- (HYDGridRef)insertItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSInteger)spanY
{
    __block BOOL itemAdded = NO;
    __block HYDGridRef filledGridRef = {0, 0};
    
    // Traverse the grid impressing the grid onto the item for each grid position.
    // If the impression (mappedItem) is empty then the mappedItem will fill the grid at that gridRef
    
    [self.grid enumerateKeysAndObjectsUsingBlock:^(NSNumber *rowNumber, NSArray *row, BOOL *outerStop) {
        
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger columnNumber, BOOL *innerStop) {
            
            HYDGridRef gridRef = {columnNumber + 1, [rowNumber intValue]};
            NSDictionary *mappedItem = [self mapForGridRef:gridRef withSpanX:spanX andSpanY:spanY];
            
            if (mappedItem && [self mappedItemIsEmpty:mappedItem]) {
                [self addMappedItem:mappedItem withIdendifier:identifier toGridRef:gridRef];
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

- (HYDRowNumber *)addNewRow {
    
    // rowNo is key, array (of 'cells') is value.
    // Each 'cell' will either contain NSNull if it is empty or an identifier representing the item that fills it
    
    NSMutableArray *newRow = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
    for (NSUInteger i = 0; i < self.numberOfColumns; i++) {
        [newRow addObject:[NSNull null]];
    }
    
    HYDRowNumber *nextRowNumber = @([self getNextRowNumber]);
    [self.grid setObject:newRow forKey:nextRowNumber];
    
    return nextRowNumber;
}

- (void)addMappedItem:(NSDictionary *)mappedItem withIdendifier:(id)identifier toGridRef:(HYDGridRef)gridRef
{
    NSUInteger lastRowIndex = gridRef.y-1 + [mappedItem count];
    NSUInteger lastColIndex = gridRef.x-1 + [[[mappedItem allValues] lastObject] count];
    
    for (NSUInteger rowIndex=gridRef.y; rowIndex <= lastRowIndex; rowIndex++) {
        for (NSUInteger columnIndex=gridRef.x - 1; columnIndex <  lastColIndex; columnIndex++) {
            NSMutableArray *gridRow = self.grid[@(rowIndex)];
            gridRow[columnIndex] = identifier;
        }
    }
}

- (BOOL)mappedItemIsEmpty:(NSDictionary *)mappedItem
{
    __block BOOL isFilled = NO;
    
    [mappedItem enumerateKeysAndObjectsUsingBlock:^(NSNumber *rowNumber, NSArray *row, BOOL *outerStop) {
        [row enumerateObjectsUsingBlock:^(id identifier, NSUInteger columnNumber, BOOL *innerStop) {
            *innerStop = isFilled = ![identifier isEqual:[NSNull null]];
        }];
        
        *outerStop = isFilled;
    }];
    
    return !isFilled;
}

- (NSDictionary *)mapForGridRef:(HYDGridRef)gridRef withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY
{
    NSUInteger columnIndex = gridRef.x - 1;
    if ((columnIndex + spanX) > self.numberOfColumns) {
        return nil;
    }
    
    NSMutableDictionary *mappedItem = [NSMutableDictionary dictionaryWithCapacity:spanY];
    NSMutableDictionary *mappedRows = [NSMutableDictionary dictionaryWithCapacity:spanY];
    
    for (NSUInteger i=gridRef.y; i < gridRef.y + spanY; i++) {
        
        if (i == [self getNextRowNumber]) {
            [self addNewRow];
        }
        
         mappedRows[@(i)] = [self.grid objectForKey:(HYDRowNumber *)@(i)];
    }
    
    [mappedRows enumerateKeysAndObjectsUsingBlock:^(NSNumber *rowNumber, NSArray *row, BOOL *stop) {
        NSMutableArray *newRow = [NSMutableArray arrayWithCapacity:spanX];
        for (NSUInteger col=columnIndex; col < columnIndex + spanX; col++) {
            [newRow addObject:row[col]];
        }
        mappedItem[rowNumber] = newRow;
    }];
    
    return mappedItem;
}

- (NSUInteger)getNextRowNumber
{
    NSArray *sortedRows = [[self.grid allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return [[sortedRows lastObject] integerValue] + 1;
}

- (NSArray *)lastRow {
    return [[self.grid allKeys] lastObject];
}

@end

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
    
    // Instantiate a grid with a single row
    
    self = [super init];
    if (self) {
        _grid = [NSMutableDictionary new];
        _numberOfColumns = numberOfColumns;
        [self addNewRow];
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

- (HYDGridRef)addItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY {
    
    NSAssert(spanX > 0, @"The item to be added to the grid must span at least one column.");
    
    // Given the span size of the item, find the next available slot that it can occupy.
    // If the spanX is n, n consecutive cells must be free (assume spanY is 1 -- i.e. item only 1 high)
    // Once a space has been found, fill the rowArray with the identifier of the item.
    // Calculate the gridRef and return it.
    
    __block BOOL itemAdded = NO;
    __block HYDGridRef gridRef = {0, 0};
    
    [self.grid enumerateKeysAndObjectsUsingBlock:^(NSNumber *rowNumber, NSMutableArray *row, BOOL *stop) {
        
        __block NSUInteger consecutiveEmptyCellCount = 0;
        
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *innerStop) {
            
            //Columns start from 1. Increment the emptyCount until a filled cell is found or empty cells are filled.
            
            NSUInteger colNumber = idx + 1;
            consecutiveEmptyCellCount = ([obj isEqual:[NSNull null]]) ? consecutiveEmptyCellCount + 1 : 0;
            
            if (consecutiveEmptyCellCount == spanX) {
                
                NSInteger startingIndex = (idx+1) - spanX;
                NSInteger endingIndex = startingIndex + (spanX-1);
                
                for (NSInteger i=startingIndex; i <= endingIndex; i++) {
                    row[i] = identifier;
                }
                
                gridRef.x = (colNumber + 1) - consecutiveEmptyCellCount; //to get the first cell in the span [1|2]
                gridRef.y = [rowNumber integerValue]; // 1 => [1|2]
                                                      // 2 => [1|2]
                *innerStop = itemAdded = YES;
            }
        }];
        
        *stop = itemAdded;
    }];
    
    // If the grid has been parsed and the item has not beed added, add it to a new row.
    
    if (!itemAdded) {
        NSNumber *rowNumber = [self addNewRow];
        gridRef = [self addItem:identifier withSpanX:spanX andSpanY:spanY toNewRow:rowNumber];
        
    }
    
    return gridRef;
}

- (HYDGridRef)addItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY toNewRow:(NSNumber *)rowNumber {
    
    HYDGridRef gridRef = {0, 0};
    NSMutableArray *row = self.grid[rowNumber];
    
    NSInteger startingIndex = 0;
    NSInteger endingIndex = spanX-1;
    
    for (NSUInteger i = startingIndex; i <= endingIndex; i++) {
        row[i] = identifier;
    }
    
    gridRef.x = startingIndex+1;
    gridRef.y = [rowNumber integerValue];
    
    return gridRef;
}

- (NSUInteger)numberOfRowsInGrid {
    return [self.grid count];
}

#pragma mark - Private methods
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

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
    
    //Instantiate a grid with a single row
    
    self = [super init];
    if (self) {
        _grid = [NSMutableDictionary new];
        _numberOfColumns = numberOfColumns;
        [self addNewRow];
    }

    return self;
}

- (id)identifierForGridRef:(struct HYDGridRef)gridRef {
    
    //Get the row, then get the cell within the row using the column reference (x)
    
    id identifier;
    NSArray *row = [self.grid objectForKey:@(gridRef.y)];
    if (row) {
        identifier = row[gridRef.x];
    }
    
    return identifier;
}

- (void)addNewRow {
    
    NSMutableArray *newRow = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
    for (NSUInteger i = 0; i < self.numberOfColumns; i++) {
        [newRow addObject:[NSNull null]];
    }
}

- (HYDGridReference)addItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY {
    
    //Given the span size of the item, find the next available slot that it can occupy.
    //Fill the rowArray with the identifier of the item
}

#pragma mark - Private methods
- (NSUInteger)getNextRowNumber
{
    return [[[self.grid allKeys] lastObject] integerValue] + 1;
}

@end

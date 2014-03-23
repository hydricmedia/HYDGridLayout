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

typedef NSNumber HYDRowNumber;

@interface HYDGrid : NSObject

- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns;
- (id)identifierForGridRef:(HYDGridRef)gridRef;
- (HYDGridRef)addItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY;
- (HYDRowNumber *)addNewRow;
- (NSUInteger)numberOfRowsInGrid;

@end

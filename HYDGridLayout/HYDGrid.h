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

- (id)identifierForGridRef:(HYDGridRef)gridRef;
- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns;
- (HYDGridRef)insertItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSInteger)spanY;
- (NSUInteger)numberOfRowsInGrid;

@end

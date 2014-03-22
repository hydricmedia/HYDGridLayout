//
//  HYDGrid.h
//  HYDGridLayout
//
//  Created by Simon Hall on 22/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

struct HYDGridRef {
    NSUInteger x;
    NSUInteger y;
};

typedef struct HYDGridRef HYDGridReference;

@interface HYDGrid : NSObject

- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns;
- (id)identifierForGridRef:(HYDGridReference)gridRef;
- (HYDGridReference)addItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY;
- (void)addGridRow;

@end

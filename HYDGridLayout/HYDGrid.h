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

typedef void (^addItemCompletion)(BOOL itemAdded);

@interface HYDGrid : NSObject

- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns;
- (id)identifierForGridRef:(HYDGridRef)gridRef;
- (HYDGridRef)addItem:(id)identifier withSpanX:(NSUInteger)spanX andSpanY:(NSUInteger)spanY completion:(addItemCompletion)completionBlock;
- (void)addGridRow;

@end

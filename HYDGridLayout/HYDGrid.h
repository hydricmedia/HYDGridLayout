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

@property (nonatomic, assign, readonly) CGFloat gridWidth;
@property (nonatomic, assign, readonly) CGFloat columnWidth;

- (id)identifierForGridRef:(HYDGridRef)gridRef;
- (id)initWithNumberOfColumns:(NSUInteger)numberOfColumns andGridWidth:(CGFloat)width;
- (HYDGridRef)insertItemAtIndexPath:(NSIndexPath *)indexPath withSpanX:(NSUInteger)spanX andSpanY:(NSInteger)spanY;
- (NSUInteger)numberOfRowsInGrid;

@end

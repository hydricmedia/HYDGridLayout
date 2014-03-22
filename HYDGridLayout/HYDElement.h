//
//  HYDElement.h
//  HYDGridLayout
//
//  Created by Simon Hall on 21/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDElement : NSObject

@property (nonatomic, assign) NSUInteger elementNo;
@property (nonatomic, strong) NSString *elementName;
@property (nonatomic, strong) NSString *elementSymbol;
@property (nonatomic, assign) CGFloat elementWeight;
@property (nonatomic, assign) NSUInteger spanX;
@property (nonatomic, assign) NSUInteger spanY;

- (id)initWithLineArray:(NSArray *)array;
- (NSString *)descriptionWithSpanXandY;
- (NSUInteger)itemSpanX;
- (NSUInteger)itemSpanY;

@end

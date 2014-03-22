//
//  HYDElement.m
//  HYDGridLayout
//
//  Created by Simon Hall on 21/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDElement.h"

@implementation HYDElement

- (id)initWithElementNo:(NSUInteger)elementNo
{
    self = [super init];
    if (self) {
        _elementNo = elementNo;
    }
    
    return self;
}

- (id)initWithLineArray:(NSArray *)array
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    NSString *rawElementNo = [array[0] stringByTrimmingCharactersInSet:charSet];

    self = [self initWithElementNo:[rawElementNo intValue]];
    
    if (self) {
        _elementWeight = [[array[1] stringByTrimmingCharactersInSet:charSet] floatValue];
        _elementName = [array[2] stringByTrimmingCharactersInSet:charSet];
        _elementSymbol = [array[3] stringByTrimmingCharactersInSet:charSet];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d -- %@: %@", self.elementNo, self.elementSymbol, self.elementName];
}

- (NSString *)descriptionWithSpanXandY {
    return [NSString stringWithFormat:@"%d -- %@: %@, SpanX: %d, SpanY: %d", self.elementNo, self.elementSymbol, self.elementName, [self spanX], [self spanY]];
}

#pragma mark - Public methods
- (NSUInteger)itemSpanX {
    return (self.elementNo %7 %2) == 1 ? 2 : 1;
}

- (NSUInteger)itemSpanY {
    return (self.elementNo %3 == 0) ? 2 : 1;
}

@end

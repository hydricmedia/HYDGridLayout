//
//  HYDElementCell.m
//  HYDGridLayout
//
//  Created by Simon Hall on 22/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDElementCell.h"


@interface HYDElementCell ()

@property (nonatomic, weak) IBOutlet UIView *elementContainer;
@property (nonatomic, weak) IBOutlet UILabel *elementSymbolLabel;
@property (nonatomic, weak) IBOutlet UILabel *elementNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *elementNumberLabel;

@end

@implementation HYDElementCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureAppearance];
}

#pragma mark - Private methods
- (void)configureAppearance {
    
    self.elementContainer.layer.cornerRadius = 4.f;
}

@end

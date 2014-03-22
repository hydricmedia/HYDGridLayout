//
//  HYDCustomGridViewController.m
//  HYDGridLayout
//
//  Created by Simon Hall on 21/03/2014.
//  Copyright (c) 2014 Simon Hall. All rights reserved.
//

#import "HYDCustomGridViewController.h"
#import "HYDCustomGridLayout.h"
#import "HYDElementCell.h"
#import "HYDElement.h"

@interface HYDCustomGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HYDCustomGridLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, weak) IBOutlet HYDCustomGridLayout *layout;

@end

@implementation HYDCustomGridViewController

- (void)viewDidLoad {
    
    [self createElements];
    [self registerNibs];
}

#pragma mark - Accessors
- (NSMutableArray *)elements
{
    if (!_elements) {
        _elements = [NSMutableArray array];
    }
    
    return _elements;
}

#pragma mark - UICollectionViewDataSource conformance
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.elements count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYDElementCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HYDElementCell class]) forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - HYDCustomGridLayoutDelegate conformance
- (CGFloat)gridWidthForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return self.collectionView.bounds.size.width;
}

- (CGFloat)columnWidthForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return 80.f;
}

- (CGFloat)minInterItemSpacingVerticalForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return 0.f;
}

- (CGFloat)minInterItemSpacingHorizontalForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return 0.f;
}

- (UIEdgeInsets)marginForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

- (CGSize)customGridLayout:(HYDCustomGridLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYDElement *element = self.elements[indexPath.item];
    CGFloat width = [element spanX] * [self columnWidthForCustomGridLayout:layout];
    CGFloat height = [element spanY] * [self columnWidthForCustomGridLayout:layout];
    
    return CGSizeMake(width, height);
}

#pragma mark - Private methods
- (void)configureCell:(HYDElementCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    HYDElement *element = self.elements[indexPath.item];
    
    cell.elementNumberLabel.text = [NSString stringWithFormat:@"%d", element.elementNo];
    cell.elementNameLabel.text = element.elementName;
    cell.elementSymbolLabel.text = element.elementSymbol;
}

- (void)createElements {
    NSError *error;
    NSString *fileString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"periodictabledump.csv" ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    NSArray *fileArray = [fileString componentsSeparatedByString:@"\n"];
    [fileArray enumerateObjectsUsingBlock:^(NSString *elementsLine, NSUInteger idx, BOOL *stop) {
        NSArray *lineArray = [elementsLine componentsSeparatedByString:@","];
        HYDElement *element = [[HYDElement alloc] initWithLineArray:lineArray];
        [self.elements addObject:element];
        NSLog(@"%@", [element descriptionWithSpanXandY]);
    }];
}

- (void)registerNibs {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HYDElementCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HYDElementCell class])];
}

@end

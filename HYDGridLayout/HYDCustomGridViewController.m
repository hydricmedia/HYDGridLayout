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
@property (nonatomic, strong) NSMutableArray *elementsMaster;
@property (nonatomic, weak) IBOutlet HYDCustomGridLayout *layout;

@end

@implementation HYDCustomGridViewController

- (void)viewDidLoad {
    
    [self createElements];
    [self registerNibs];
    
    self.layout.delegate = self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionViewLayout invalidateLayout];
}

#pragma mark - Accessors
- (NSMutableArray *)elements
{
    if (!_elements) {
        _elements = [NSMutableArray arrayWithArray:self.elementsMaster];
    }
    
    return _elements;
}

- (NSMutableArray *)elementsMaster
{
    if (!_elementsMaster) {
        _elementsMaster = [NSMutableArray array];
    }
    
    return _elementsMaster;
}

#pragma mark - Actions
- (IBAction)orderChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        NSSortDescriptor *numberSort = [NSSortDescriptor sortDescriptorWithKey:@"elementNo" ascending:YES];
        [self.elements sortUsingDescriptors:@[numberSort]];
    }
    
    if (sender.selectedSegmentIndex == 1) {
        NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"elementName" ascending:YES];
        [self.elements sortUsingDescriptors:@[nameSort]];
    }

    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    } completion:nil];
}

- (IBAction)nameFilterChanged:(UISegmentedControl *)sender {
    
    NSArray *indexPaths = [NSArray new];
    
    if (sender.selectedSegmentIndex == 0) {
        indexPaths = [self indexPathsOfElementsToAdd];
        self.elements = nil;
        [self.collectionViewLayout invalidateLayout];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:nil];
    }
    
    if (sender.selectedSegmentIndex == 1) {
        indexPaths = [self indexPathsOfElementsToRemove];
        [self.elements filterUsingPredicate:[NSPredicate predicateWithFormat:@"elementName ENDSWITH 'ium'"]];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:indexPaths];
        } completion:nil];
    }
}

- (NSArray *)indexPathsOfElementsToAdd {
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *elementsRemoved = [self.elementsMaster filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(elementName ENDSWITH 'ium')"]];
    
    [self.elementsMaster enumerateObjectsUsingBlock:^(HYDElement *element, NSUInteger idx, BOOL *stop) {
        if ([elementsRemoved containsObject:element]) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
        }
    }];
    
    return indexPaths;
}

- (NSArray *)indexPathsOfElementsToRemove {
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *elementsForRemoval = [self.elementsMaster filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(elementName ENDSWITH 'ium')"]];
    
    [self.elements enumerateObjectsUsingBlock:^(HYDElement *element, NSUInteger idx, BOOL *stop) {
        if ([elementsForRemoval containsObject:element]) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
        }
    }];
    
    return indexPaths;
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

- (NSUInteger)numberOfColumnsForCustomGridLayout:(HYDCustomGridLayout *)layout
{
    if (IPHONE) {
        return 1;
    } else {
        return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) ? 4 : 5;
    }
}

- (CGFloat)gridWidthForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return self.collectionView.bounds.size.width;
}

- (CGFloat)minInterItemSpacingVerticalForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return 10.f;
}

- (CGFloat)minInterItemSpacingHorizontalForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return 10.f;
}

- (UIEdgeInsets)marginForCustomGridLayout:(HYDCustomGridLayout *)layout {
    return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}

- (id)customGridLayout:(HYDCustomGridLayout *)layout gridCellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYDElement *element = self.elements[indexPath.item];
    return @(element.elementNo);
}

- (NSUInteger)customGridLayout:(HYDCustomGridLayout *)layout spanXForItemAtIndexPath:(NSIndexPath *)indexPath {

    HYDElement *element = self.elements[indexPath.item];
    return element.spanX;
}

- (NSUInteger)customGridLayout:(HYDCustomGridLayout *)layout spanYForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYDElement *element = self.elements[indexPath.item];
    return element.spanY;
}

#pragma mark - Private methods
- (void)configureCell:(HYDElementCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    HYDElement *element = self.elements[indexPath.item];
    
    cell.elementName = element.elementName;
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
        [self.elementsMaster addObject:element];
    }];
}

- (void)registerNibs {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HYDElementCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HYDElementCell class])];
}

@end

//
//  DemoCollectionViewController.m
//  LGViewControllersDemo
//
//  Created by Grigory Lutkov on 26.03.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "DemoCollectionViewController.h"

@interface DemoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation DemoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
        
        _textLabel = [UILabel new];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_textLabel sizeToFit];
    _textLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _textLabel.frame = CGRectIntegral(_textLabel.frame);
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) self.backgroundColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
    else self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
}

@end

#pragma mark -

@interface DemoCollectionViewController ()

@property (assign, nonatomic, getter=isInitialized) BOOL initialized;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic, getter=isLoadingData) BOOL loadingData;

@end

@implementation DemoCollectionViewController

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithPlaceholderViewEnabled:YES refreshViewEnabled:YES];
    if (self)
    {
        self.title = title;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.collectionView registerClass:[DemoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [self.collectionView.placeholderView showActivityIndicatorAnimated:NO completionHandler:nil];
        
        self.collectionView.alwaysBounceVertical = YES;
        
        [self addItemsToDataArray];
    }
    return self;
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
}

#pragma mark - Appearing

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSUInteger numberOfCellsInARow = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 3 : 6);
    if (self.view.frame.size.width > self.view.frame.size.height) numberOfCellsInARow += 2;
    
    _loadingData = YES;
    
    [self.collectionView setViewWidth:self.view.frame.size.width
                           cellAspect:1.f
                  numberOfCellsInARow:numberOfCellsInARow
                           cellInsets:2.f
                        sectionInsets:UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f)
                  headerReferenceSize:CGSizeZero
                  footerReferenceSize:CGSizeZero
                      scrollDirection:UICollectionViewScrollDirectionVertical];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                   {
                       _loadingData = NO;
                   });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                   {
                       [self.collectionView.placeholderView dismissAnimated:YES completionHandler:nil];
                       
                       _initialized = YES;
                   });
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    [cell setNeedsLayout];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Collection view did highlight cell section: %i item: %i", (int)indexPath.section, (int)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Collection view did select cell section: %i item: %i", (int)indexPath.section, (int)indexPath.row);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isLoadingData && self.isInitialized &&
        scrollView.contentOffset.y + scrollView.contentInset.top + scrollView.frame.size.height >= scrollView.contentSize.height - 100.f)
    {
        _loadingData = YES;
        
        [self.collectionView performBatchUpdates:^(void)
         {
             [self addItemsToDataArray];
             
             NSMutableArray *array = [NSMutableArray new];
             
             NSUInteger count = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 30 : 70);
             
             for (NSUInteger i=_dataArray.count-count; i<_dataArray.count; i++)
                 [array addObject:[NSIndexPath indexPathForItem:i inSection:0]];
             
             [self.collectionView insertItemsAtIndexPaths:array];
         }
                                      completion:^(BOOL finished)
         {
             _loadingData = NO;
         }];
    }
}

#pragma mark -

- (void)refreshActions
{
    [_dataArray removeAllObjects];
    
    [self addItemsToDataArray];
    
    [self.collectionView reloadData];
    
    [UIView transitionWithView:self.collectionView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    
    [self.collectionView.refreshView endRefreshing];
}

- (void)addItemsToDataArray
{
    if (!_dataArray)
        _dataArray = [NSMutableArray new];
    
    NSUInteger count = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 30 : 70);
    
    for (NSUInteger i=0; i<count; i++)
        [_dataArray addObject:[NSString stringWithFormat:@"Item %i", (int)_dataArray.count+1]];
}

@end

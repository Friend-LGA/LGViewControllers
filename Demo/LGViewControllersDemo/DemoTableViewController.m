//
//  DemoTableViewController.m
//  LGViewControllersDemo
//
//  Created by Grigory Lutkov on 26.03.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "DemoTableViewController.h"

@interface DemoTableViewCell : UITableViewCell

@end

@implementation DemoTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    self.textLabel.font = [UIFont systemFontOfSize:16.0];
    self.textLabel.numberOfLines = 0;
    
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) self.backgroundColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
    else self.backgroundColor = [UIColor whiteColor];
}

@end

#pragma mark -

@interface DemoTableViewController ()

@property (assign, nonatomic, getter=isInitialized) BOOL initialized;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic, getter=isLoadingData) BOOL loadingData;

@end

@implementation DemoTableViewController

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithStyle:UITableViewStylePlain asyncCalculatingHeightForRows:YES placeholderViewEnabled:YES refreshViewEnabled:YES];
    if (self)
    {
        self.title = title;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.tableView registerClass:[DemoTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [self.tableView.placeholderView showActivityIndicatorAnimated:NO completionHandler:nil];
        
        self.tableView.alwaysBounceVertical = YES;
        
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                   {
                       [self.tableView.placeholderView dismissAnimated:YES completionHandler:nil];
                       
                       _initialized = YES;
                   });
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(LGTableView *)tableView heightForRowAtIndexPathAsync:(NSIndexPath *)indexPath
{
    NSString *string = _dataArray[indexPath.row];
    
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)];
    
    return size.height+20.f;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Table view did highlight cell section: %i row: %i", (int)indexPath.section, (int)indexPath.row);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Table view did select cell section: %i row: %i", (int)indexPath.section, (int)indexPath.row);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isLoadingData && self.isInitialized &&
        scrollView.contentOffset.y + scrollView.contentInset.top + scrollView.frame.size.height >= scrollView.contentSize.height - 100.f)
    {
        _loadingData = YES;
        
        [self.tableView beginUpdates];
        
        [self addItemsToDataArray];
        
        NSMutableArray *array = [NSMutableArray new];
        
        NSUInteger count = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 30 : 40);
        
        for (NSUInteger i=_dataArray.count-count; i<_dataArray.count; i++)
            [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        
        [self.tableView insertRowsAtIndexPaths:array
                              withRowAnimation:UITableViewRowAnimationAutomatic
                             completionHandler:^(void)
        {
            [self.tableView endUpdates];
            
            _loadingData = NO;
        }];
    }
}

#pragma mark -

- (void)refreshActions
{
    [_dataArray removeAllObjects];
    
    [self addItemsToDataArray];
    
    [self.tableView reloadDataWithCompletionHandler:^(void)
     {
         [UIView transitionWithView:self.tableView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
         
         [self.tableView.refreshView endRefreshing];
     }];
}

- (void)addItemsToDataArray
{
    if (!_dataArray)
        _dataArray = [NSMutableArray new];
    
    NSUInteger count = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 30 : 40);
    
    for (NSUInteger i=0; i<count; i++)
    {
        NSArray *variants = @[[NSString stringWithFormat:@"Row %i Line 1", (int)_dataArray.count+1],
                              [NSString stringWithFormat:@"Row %i Line 1\nRow %i Line 2", (int)_dataArray.count+1, (int)_dataArray.count+1],
                              [NSString stringWithFormat:@"Row %i Line 1\nRow %i Line 2\nRow %i Line 3", (int)_dataArray.count+1, (int)_dataArray.count+1, (int)_dataArray.count+1]];
        
        NSUInteger i = arc4random() % 3;
        
        [_dataArray addObject:variants[i]];
    }
}

@end

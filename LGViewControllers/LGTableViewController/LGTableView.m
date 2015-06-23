//
//  LGTableView.m
//  LGViewControllers
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGViewControllers)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGTableView.h"

@interface LGTableView ()

@property (strong, nonatomic) NSMutableArray *heightForRowsArray;

@property (strong, nonatomic) UIView *topSeparatorView;

@end

@implementation LGTableView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithFrame:CGRectZero style:style];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style placeholderViewEnabled:(BOOL)placeholderViewEnabled refreshHandler:(void(^)())refreshHandler
{
    self = [super initWithFrame:CGRectZero style:style];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:placeholderViewEnabled refreshHandler:refreshHandler];
    }
    return self;
}

- (void)initializeWithPlaceholderViewEnabled:(BOOL)placeholderViewEnabled refreshHandler:(void(^)())refreshHandler
{
    self.backgroundColor = [UIColor clearColor];
    
    self.placeholderViewEnabled = placeholderViewEnabled;
    
    if (refreshHandler)
        [self setRefreshViewEnabledWithHandler:refreshHandler];
}

#pragma mark - Dealloc

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#endif
    
    self.delegateLG = nil;
}

#pragma mark -

- (void)setFrame:(CGRect)frame
{
    if (_topSeparatorView && CGSizeEqualToSize(self.frame.size, frame.size))
    {
        CGFloat widthDif = frame.size.width-self.frame.size.width;
        
        _topSeparatorView.frame = CGRectMake(_topSeparatorView.frame.origin.x, _topSeparatorView.frame.origin.y, _topSeparatorView.frame.size.width+widthDif, _topSeparatorView.frame.size.height);
    }
    
    [super setFrame:frame];
}

#pragma mark -

- (void)setDelegateLG:(id<LGTableViewDelegate>)delegateLG
{
    _delegateLG = delegateLG;
    
    if (_delegateLG) _heightForRowsArray = [NSMutableArray new];
    else _heightForRowsArray = nil;
}

#pragma mark -

- (void)setRefreshViewEnabledWithHandler:(void(^)())refreshHandler
{
    if (!_refreshViewEnabled && !_refreshView)
    {
        _refreshViewEnabled = YES;
        
        _refreshView = [LGRefreshView refreshViewWithScrollView:self
                                                 refreshHandler:refreshHandler];
    }
}

- (void)setRefreshViewDisabled
{
    if (_refreshViewEnabled && _refreshView)
    {
        _refreshViewEnabled = NO;
        
        if (_refreshView.superview)
            [_refreshView removeFromSuperview];
        
        _refreshView = nil;
    }
}

- (void)setPlaceholderViewEnabled:(BOOL)placeholderViewEnabled
{
    if (_placeholderViewEnabled != placeholderViewEnabled)
    {
        _placeholderViewEnabled = placeholderViewEnabled;
        
        if (_placeholderViewEnabled && !_placeholderView)
            _placeholderView = [LGPlaceholderView placeholderViewWithView:self];
        else if (!_placeholderViewEnabled && _placeholderView)
        {
            if (_placeholderView.superview)
                [_placeholderView removeFromSuperview];
            
            _placeholderView = nil;
        }
    }
}

#pragma mark -

- (void)addTopSeparatorViewWithColor:(UIColor *)color thinckness:(CGFloat)thinckness edgeInsets:(UIEdgeInsets)edgeInsets
{
    if (_topSeparatorView)
    {
        [_topSeparatorView removeFromSuperview];
        _topSeparatorView = nil;
    }
    
    _topSeparatorView = [UIView new];
    _topSeparatorView.backgroundColor = color;
    _topSeparatorView.frame = CGRectMake(edgeInsets.left, -thinckness, self.frame.size.width-edgeInsets.left-edgeInsets.right, thinckness);
    [self addSubview:_topSeparatorView];
}

#pragma mark -

- (void)reloadData
{
    [self reloadDataWithCompletionHandler:nil];
}

- (void)reloadDataWithCompletionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSMutableArray *heightForRowsArray = [NSMutableArray new];
                           
                           for (NSUInteger section=0; section<[self.dataSource numberOfSectionsInTableView:self]; section++)
                           {
                               NSMutableArray *sectionArray = [NSMutableArray new];
                               
                               for (NSUInteger row=0; row<[self.dataSource tableView:self numberOfRowsInSection:section]; row++)
                               {
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                                   
                                   CGFloat height = [_delegateLG tableView:self heightForRowAtIndexPathAsync:indexPath];
                                   
                                   NSNumber *heightObject = [NSNumber numberWithFloat:height];
                                   
                                   [sectionArray addObject:heightObject];
                               }
                               
                               [heightForRowsArray addObject:sectionArray];
                           }
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray;
                                              
                                              [super reloadData];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super reloadData];
        
        if (completionHandler) completionHandler();
    }
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation completionHandler:nil];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSMutableArray *heightForRowsArray = _heightForRowsArray.mutableCopy;
                           
                           for (NSUInteger section=0; section<[self.dataSource numberOfSectionsInTableView:self]; section++)
                           {
                               NSMutableArray *sectionArray = heightForRowsArray[section];
                               
                               for (NSUInteger row=0; row<[self.dataSource tableView:self numberOfRowsInSection:section]; row++)
                               {
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                                   
                                   if ([indexPaths containsObject:indexPath])
                                   {
                                       CGFloat height = [_delegateLG tableView:self heightForRowAtIndexPathAsync:indexPath];
                                       
                                       NSNumber *heightObject = [NSNumber numberWithFloat:height];
                                       
                                       [sectionArray replaceObjectAtIndex:row withObject:heightObject];
                                   }
                               }
                               
                               [heightForRowsArray replaceObjectAtIndex:section withObject:sectionArray];
                           }
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray;
                                              
                                              [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        
        if (completionHandler) completionHandler();
    }
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadSections:sections withRowAnimation:animation completionHandler:nil];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSMutableArray *heightForRowsArray = _heightForRowsArray.mutableCopy;
                           
                           for (NSUInteger section=0; section<[self.dataSource numberOfSectionsInTableView:self]; section++)
                               if ([sections containsIndex:section])
                               {
                                   NSMutableArray *sectionArray = heightForRowsArray[section];
                                   
                                   for (NSUInteger row=0; row<[self.dataSource tableView:self numberOfRowsInSection:section]; row++)
                                   {
                                       NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                                       
                                       CGFloat height = [_delegateLG tableView:self heightForRowAtIndexPathAsync:indexPath];
                                       
                                       NSNumber *heightObject = [NSNumber numberWithFloat:height];
                                       
                                       [sectionArray replaceObjectAtIndex:row withObject:heightObject];
                                   }
                                   
                                   [heightForRowsArray replaceObjectAtIndex:section withObject:sectionArray];
                               }
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray;
                                              
                                              [super reloadSections:sections withRowAnimation:animation];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super reloadSections:sections withRowAnimation:animation];
        
        if (completionHandler) completionHandler();
    }
}

#pragma mark -

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation completionHandler:nil];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSArray *heightForRowsArray = [self insertRowsAtIndexPaths:indexPaths inArray:_heightForRowsArray];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray.mutableCopy;
                                              
                                              [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        
        if (completionHandler) completionHandler();
    }
}

- (NSMutableArray *)insertRowsAtIndexPaths:(NSArray *)indexPaths inArray:(NSArray *)array
{
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
    
    NSArray *indexPathsSorted = [indexPaths sortedArrayUsingDescriptors:@[sortDescriptor1, sortDescriptor2]];
    
    NSMutableArray *heightForRowsArray = array.mutableCopy;
    
    for (NSIndexPath *indexPath in indexPathsSorted)
    {
        CGFloat height = [_delegateLG tableView:self heightForRowAtIndexPathAsync:indexPath];
        
        NSNumber *heightObject = [NSNumber numberWithFloat:height];
        
        if (heightForRowsArray.count > indexPath.section)
        {
            NSMutableArray *sectionArray = heightForRowsArray[indexPath.section];
            
            if (sectionArray.count > indexPath.row)
                [sectionArray insertObject:heightObject atIndex:indexPath.row];
            else
                [sectionArray addObject:heightObject];
        }
        else
        {
            NSMutableArray *sectionArray = [NSMutableArray new];
            
            [sectionArray addObject:heightObject];
            
            [heightForRowsArray addObject:sectionArray];
        }
    }
    
    return heightForRowsArray;
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertSections:sections withRowAnimation:animation completionHandler:nil];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSArray *heightForRowsArray = [self insertSections:sections inArray:_heightForRowsArray];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray.mutableCopy;
                                              
                                              [super insertSections:sections withRowAnimation:animation];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super insertSections:sections withRowAnimation:animation];
        
        if (completionHandler) completionHandler();
    }
}

- (NSMutableArray *)insertSections:(NSIndexSet *)sections inArray:(NSArray *)array
{
    NSMutableIndexSet *sectionsSorted = [NSMutableIndexSet new];
    
    for (NSUInteger i=0; i<sections.count; i++)
    {
        if (i == 0) [sectionsSorted addIndex:[sections indexGreaterThanOrEqualToIndex:0]];
        else [sectionsSorted addIndex:[sections indexGreaterThanIndex:sectionsSorted.lastIndex]];
    }
    
    NSMutableArray *heightForRowsArray = array.mutableCopy;
    
    [sectionsSorted enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop)
     {
         NSMutableArray *sectionArray = [NSMutableArray new];
         
         for (NSUInteger row=0; row<[self.dataSource tableView:self numberOfRowsInSection:section]; row++)
         {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
             
             CGFloat height = [_delegateLG tableView:self heightForRowAtIndexPathAsync:indexPath];
             
             NSNumber *heightObject = [NSNumber numberWithFloat:height];
             
             [sectionArray addObject:heightObject];
         }
         
         [heightForRowsArray insertObject:sectionArray atIndex:section];
     }];
    
    return heightForRowsArray;
}

#pragma mark -

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation completionHandler:nil];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSArray *heightForRowsArray = [self deleteRowsAtIndexPaths:indexPaths inArray:_heightForRowsArray];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray.mutableCopy;
                                              
                                              [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        
        if (completionHandler) completionHandler();
    }
}

- (NSMutableArray *)deleteRowsAtIndexPaths:(NSArray *)indexPaths inArray:(NSArray *)array
{
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:NO];
    
    NSArray *indexPathsSorted = [indexPaths sortedArrayUsingDescriptors:@[sortDescriptor1, sortDescriptor2]];
    
    NSMutableArray *heightForRowsArray = array.mutableCopy;
    
    for (NSIndexPath *indexPath in indexPathsSorted)
    {
        NSMutableArray *sectionArray = heightForRowsArray[indexPath.section];
        
        [sectionArray removeObjectAtIndex:indexPath.row];
        
        if (!sectionArray.count)
            [heightForRowsArray removeObjectAtIndex:indexPath.section];
    }
    
    return heightForRowsArray;
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self deleteSections:sections withRowAnimation:animation completionHandler:nil];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSArray *heightForRowsArray = [self deleteSections:sections inArray:_heightForRowsArray];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = heightForRowsArray.mutableCopy;
                                              
                                              [super deleteSections:sections withRowAnimation:animation];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super deleteSections:sections withRowAnimation:animation];
        
        if (completionHandler) completionHandler();
    }
}

- (NSMutableArray *)deleteSections:(NSIndexSet *)sections inArray:(NSArray *)array
{
    NSMutableIndexSet *sectionsSorted = [NSMutableIndexSet new];
    
    for (NSUInteger i=0; i<sections.count; i++)
    {
        if (i == 0) [sectionsSorted addIndex:[sections indexGreaterThanOrEqualToIndex:0]];
        else [sectionsSorted addIndex:[sections indexGreaterThanIndex:sectionsSorted.lastIndex]];
    }
    
    NSMutableArray *heightForRowsArray = array.mutableCopy;
    
    NSUInteger section = sectionsSorted.lastIndex;
    
    while (section != NSNotFound)
    {
        [heightForRowsArray removeObjectAtIndex:section];
        
        section = [sectionsSorted indexLessThanIndex:section];
    }
    
    return heightForRowsArray;
}

#pragma mark -

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    [self moveRowAtIndexPath:indexPath toIndexPath:newIndexPath completionHandler:nil];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSMutableArray *array1 = [self deleteRowsAtIndexPaths:@[indexPath] inArray:_heightForRowsArray];
                           NSMutableArray *array2 = [self insertRowsAtIndexPaths:@[newIndexPath] inArray:array1];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = array2;
                                              
                                              [super moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        
        if (completionHandler) completionHandler();
    }
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    [self moveSection:section toSection:newSection completionHandler:nil];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection completionHandler:(void(^)())completionHandler
{
    if (_delegateLG && [_delegateLG respondsToSelector:@selector(tableView:heightForRowAtIndexPathAsync:)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void)
                       {
                           NSMutableArray *array1 = [self deleteSections:[NSIndexSet indexSetWithIndex:section] inArray:_heightForRowsArray];
                           NSMutableArray *array2 = [self insertSections:[NSIndexSet indexSetWithIndex:newSection] inArray:array1];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                                          {
                                              _heightForRowsArray = array2;
                                              
                                              [super moveSection:section toSection:newSection];
                                              
                                              if (completionHandler) completionHandler();
                                          });
                       });
    }
    else
    {
        [super moveSection:section toSection:newSection];
        
        if (completionHandler) completionHandler();
    }
}

@end

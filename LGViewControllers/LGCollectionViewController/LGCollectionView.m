//
//  LGCollectionView.m
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

#import "LGCollectionView.h"

@interface LGCollectionView ()

@property (strong, nonatomic) UIView *topSeparatorView;

@end

@implementation LGCollectionView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:(layout ? layout : [UICollectionViewFlowLayout new])];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithPlaceholderViewEnabled:(BOOL)placeholderViewEnabled refreshHandler:(void(^)())refreshHandler
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
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
    if (!_topSeparatorView)
    {
        _topSeparatorView = [UIView new];
        [self addSubview:_topSeparatorView];
    }
    
    _topSeparatorView.backgroundColor = color;
    _topSeparatorView.frame = CGRectMake(edgeInsets.left, -thinckness, self.frame.size.width-edgeInsets.left-edgeInsets.right, thinckness);
}

#pragma mark - UICollectionViewLayout

- (void)setViewWidth:(CGFloat)viewWidth
          cellAspect:(CGFloat)cellAspect
 numberOfCellsInARow:(NSUInteger)numberOfCellsInARow
          cellInsets:(CGFloat)cellInsets
       sectionInsets:(UIEdgeInsets)sectionInsets
 headerReferenceSize:(CGSize)headerReferenceSize
 footerReferenceSize:(CGSize)footerReferenceSize
     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    CGFloat cellWidth = (viewWidth-sectionInsets.left-sectionInsets.right-cellInsets*(numberOfCellsInARow-1))/numberOfCellsInARow;
    CGFloat cellHeight = cellWidth/cellAspect;
    
    [self setCellWidth:cellWidth
            cellHeight:cellHeight
            cellInsets:cellInsets
         sectionInsets:sectionInsets
   headerReferenceSize:headerReferenceSize
   footerReferenceSize:footerReferenceSize
       scrollDirection:scrollDirection];
}

- (void)setViewWidth:(CGFloat)viewWidth
          cellHeight:(CGFloat)cellHeight
 numberOfCellsInARow:(NSUInteger)numberOfCellsInARow
          cellInsets:(CGFloat)cellInsets
       sectionInsets:(UIEdgeInsets)sectionInsets
 headerReferenceSize:(CGSize)headerReferenceSize
 footerReferenceSize:(CGSize)footerReferenceSize
     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    CGFloat cellWidth = (viewWidth-sectionInsets.left-sectionInsets.right-cellInsets*(numberOfCellsInARow-1))/numberOfCellsInARow;
    
    [self setCellWidth:cellWidth
            cellHeight:cellHeight
            cellInsets:cellInsets
         sectionInsets:sectionInsets
   headerReferenceSize:headerReferenceSize
   footerReferenceSize:footerReferenceSize
       scrollDirection:scrollDirection];
}

- (void)setCellWidth:(CGFloat)cellWidth
          cellHeight:(CGFloat)cellHeight
          cellInsets:(CGFloat)cellInsets
       sectionInsets:(UIEdgeInsets)sectionInsets
 headerReferenceSize:(CGSize)headerReferenceSize
footerReferenceSize:(CGSize)footerReferenceSize
     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
    collectionViewLayout.sectionInset = sectionInsets;
    collectionViewLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    collectionViewLayout.minimumLineSpacing = cellInsets; //*(sectionInsets.left || sectionInsets.right ? 1 : 2);
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.scrollDirection = scrollDirection;
    collectionViewLayout.headerReferenceSize = headerReferenceSize;
    collectionViewLayout.footerReferenceSize = footerReferenceSize;
    
    [self setCollectionViewLayout:collectionViewLayout animated:NO];
}

@end

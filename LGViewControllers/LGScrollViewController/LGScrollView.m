//
//  LGScrollView.m
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

#import "LGScrollView.h"

@interface LGScrollView ()

@property (strong, nonatomic) UIView *topSeparatorView;

@end

@implementation LGScrollView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO refreshHandler:nil];
    }
    return self;
}

- (instancetype)initWithPlaceholderViewEnabled:(BOOL)placeholderViewEnabled refreshHandler:(void(^)())refreshHandler
{
    self = [super init];
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

@end

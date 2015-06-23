//
//  LGWebView.m
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

#import "LGWebView.h"

@implementation LGWebView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithPlaceholderViewEnabled:(BOOL)placeholderViewEnabled
{
    self = [super init];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:placeholderViewEnabled];
    }
    return self;
}

- (void)initializeWithPlaceholderViewEnabled:(BOOL)placeholderViewEnabled
{
    self.placeholderViewEnabled = placeholderViewEnabled;
}

#pragma mark - Dealloc

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#endif
}

#pragma mark -

- (void)removeBackgroundImages
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 7)
        for (UIImageView *imageView in self.scrollView.subviews)
            if ([imageView isKindOfClass:[UIImageView class]] && imageView.image.size.width == 1)
                imageView.hidden = YES;
}

- (void)setPlaceholderViewEnabled:(BOOL)placeholderViewEnabled
{
    if (_placeholderViewEnabled != placeholderViewEnabled)
    {
        _placeholderViewEnabled = placeholderViewEnabled;
        
        if (_placeholderViewEnabled && !_placeholderView)
            _placeholderView = [LGPlaceholderView placeholderViewWithView:self.scrollView];
        else if (!_placeholderViewEnabled && _placeholderView)
        {
            if (_placeholderView.superview)
                [_placeholderView removeFromSuperview];
            
            _placeholderView = nil;
        }
    }
}

@end

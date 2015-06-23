//
//  LGWebViewController.m
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

#import "LGWebViewController.h"

@interface LGWebViewController ()

@property (assign, nonatomic, getter=isInitialized) BOOL initialized;

@property (assign, nonatomic) UIEdgeInsets contentInset;

@end

@implementation LGWebViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initializeWithPlaceholderViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
        self.wantsFullScreenLayout = YES;
    else
    {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _webView = [[LGWebView alloc] initWithPlaceholderViewEnabled:placeholderViewEnabled];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

#pragma mark -

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        [self initializeWithTitle:title url:url placeholderViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url placeholderViewEnabled:(BOOL)placeholderViewEnabled
{
    self = [super init];
    if (self)
    {
        [self initializeWithTitle:title url:url placeholderViewEnabled:placeholderViewEnabled];
    }
    return self;
}

- (void)initializeWithTitle:(NSString *)title url:(NSURL *)url placeholderViewEnabled:(BOOL)placeholderViewEnabled
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
        self.wantsFullScreenLayout = YES;
    else
    {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = title;
    
    if ([url isKindOfClass:[NSString class]]) url = [NSURL URLWithString:(NSString *)url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    _webView = [[LGWebView alloc] initWithPlaceholderViewEnabled:placeholderViewEnabled];
    _webView.delegate = self;
    [_webView loadRequest:request];
    _webView.clipsToBounds = NO;
    [self.view addSubview:_webView];
    
    if (_webView.isPlaceholderViewEnabled)
        [_webView.placeholderView showActivityIndicatorAnimated:NO completionHandler:nil];
}

#pragma mark - Dealloc

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#endif
}

#pragma mark - Appearing

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topInset = 0.f;
    topInset += (self.navigationController.navigationBarHidden ? 0.f : MIN(self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height));
    topInset += ([UIApplication sharedApplication].statusBarHidden ? 0.f : MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height));
    
    CGFloat bottomInset = 0.f;
    bottomInset += (self.navigationController.isToolbarHidden ? 0.f : MIN(self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height));
    
    CGFloat topShift = 0.f;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0 &&
        !self.navigationController.isNavigationBarHidden &&
        self.navigationController.navigationBar.isOpaque)
        topShift = topInset;
    
    CGRect newFrame = CGRectMake(0.f, topInset, self.view.frame.size.width, self.view.frame.size.height-topInset-bottomInset);
    
    if (!CGSizeEqualToSize(_webView.frame.size, newFrame.size))
        _webView.frame = newFrame;
}

#pragma mark - UIWebView Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self loadingDidFinishWithError:error];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadingDidFinishWithError:nil];
}

- (void)loadingDidFinishWithError:(NSError *)error
{
    if (_webView.isPlaceholderViewEnabled)
    {
        if (error)
            [_webView.placeholderView showText:error.localizedDescription animated:YES completionHandler:nil];
        else
            [_webView.placeholderView dismissAnimated:YES completionHandler:nil];
    }
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if (inType == UIWebViewNavigationTypeLinkClicked && !self.isOpenLinksInside)
    {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        
        return NO;
    }
    
    return YES;
}

@end

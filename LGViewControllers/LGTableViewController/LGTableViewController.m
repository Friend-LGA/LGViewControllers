//
//  LGTableViewController.m
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

#import "LGTableViewController.h"

@interface LGTableViewController ()

@property (assign, nonatomic, getter=isCalculating) BOOL calculating;

@property (assign, nonatomic) CGFloat bottomContentInset;
@property (assign, nonatomic) CGFloat bottomScrollIndicatorInsets;

@end

@implementation LGTableViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initializeWithStyle:UITableViewStylePlain asyncCalculatingHeightForRows:NO placeholderViewEnabled:NO refreshViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initializeWithStyle:UITableViewStylePlain asyncCalculatingHeightForRows:NO placeholderViewEnabled:NO refreshViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self)
    {
        [self initializeWithStyle:style asyncCalculatingHeightForRows:NO placeholderViewEnabled:NO refreshViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style asyncCalculatingHeightForRows:(BOOL)asyncCalculatingHeightForRows
{
    self = [super init];
    if (self)
    {
        [self initializeWithStyle:style asyncCalculatingHeightForRows:asyncCalculatingHeightForRows placeholderViewEnabled:NO refreshViewEnabled:NO];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style asyncCalculatingHeightForRows:(BOOL)asyncCalculatingHeightForRows placeholderViewEnabled:(BOOL)placeholderViewEnabled refreshViewEnabled:(BOOL)refreshViewEnabled
{
    self = [super init];
    if (self)
    {
        [self initializeWithStyle:style asyncCalculatingHeightForRows:asyncCalculatingHeightForRows placeholderViewEnabled:placeholderViewEnabled refreshViewEnabled:refreshViewEnabled];
    }
    return self;
}

- (void)initializeWithStyle:(UITableViewStyle)style asyncCalculatingHeightForRows:(BOOL)asyncCalculatingHeightForRows placeholderViewEnabled:(BOOL)placeholderViewEnabled refreshViewEnabled:(BOOL)refreshViewEnabled
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
        self.wantsFullScreenLayout = YES;
    else
    {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (refreshViewEnabled)
    {
        __weak typeof(self) wself = self;
        
        _tableView = [[LGTableView alloc] initWithStyle:style
                                 placeholderViewEnabled:placeholderViewEnabled
                                         refreshHandler:^(void)
                      {
                          if (wself)
                          {
                              __strong typeof(wself) self = wself;
                              
                              [self refreshActions];
                          }
                      }];
    }
    else _tableView = [[LGTableView alloc] initWithStyle:style
                                  placeholderViewEnabled:placeholderViewEnabled
                                          refreshHandler:nil];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    if (asyncCalculatingHeightForRows)
        _tableView.delegateLG = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - Dealloc

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#endif
    
    if (self.isKeyboardShowHideObserverEnabled)
        _keyboardShowHideObserverEnabled = NO;
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
    
    CGRect newFrame = CGRectMake(0.f, -topShift, self.view.frame.size.width, self.view.frame.size.height+topShift);
    
    if (!CGSizeEqualToSize(_tableView.frame.size, newFrame.size))
    {
        _tableView.frame = newFrame;
        _tableView.contentInset = UIEdgeInsetsMake(topInset, 0.f, bottomInset, 0.f);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.f, bottomInset, 0.f);
    }
}

#pragma mark - Refresh

- (void)refreshActions
{
    //
}

#pragma mark - Keyboard notification

- (void)setKeyboardShowHideObserverEnabled:(BOOL)keyboardShowHideObserverEnabled
{
    if (_keyboardShowHideObserverEnabled != keyboardShowHideObserverEnabled)
    {
        _keyboardShowHideObserverEnabled = keyboardShowHideObserverEnabled;
        
        if (_keyboardShowHideObserverEnabled)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowHideNotification:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        }
    }
}

- (void)keyboardWillShowHideNotification:(NSNotification *)notification
{
    [LGTableViewController keyboardAnimateWithNotificationUserInfo:notification.userInfo
                                                        animations:^(CGFloat keyboardHeight)
     {
         BOOL appear = (notification.name == UIKeyboardWillShowNotification);
         
         [self keyboardWillShowHideActionsAppear:appear keyboardHeight:keyboardHeight];
     }];
}

- (void)keyboardWillShowHideActionsAppear:(BOOL)appear keyboardHeight:(CGFloat)keyboardHeight
{
    if (appear)
    {
        _bottomContentInset = _tableView.contentInset.bottom;
        _bottomScrollIndicatorInsets = _tableView.scrollIndicatorInsets.bottom;
    }
    
    CGFloat bottomContentInset = (appear ? keyboardHeight : _bottomContentInset);
    CGFloat bottomScrollIndicatorInsets = (appear ? keyboardHeight : _bottomScrollIndicatorInsets);
    
    UIEdgeInsets contentInset = _tableView.contentInset;
    UIEdgeInsets scrollIndicatorInsets = _tableView.scrollIndicatorInsets;
    
    contentInset.bottom = bottomContentInset;
    scrollIndicatorInsets.bottom = bottomScrollIndicatorInsets;
    
    _tableView.contentInset = contentInset;
    _tableView.scrollIndicatorInsets = scrollIndicatorInsets;
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(LGTableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(LGTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(LGTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(LGTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.heightForRowsArray && tableView.heightForRowsArray.count > indexPath.section && [tableView.heightForRowsArray[indexPath.section] count] > indexPath.row)
        return [tableView.heightForRowsArray[indexPath.section][indexPath.row] floatValue];
    else
        return 0.f;
}

#pragma mark - LGTableView Delegate

- (CGFloat)tableView:(LGTableView *)tableView heightForRowAtIndexPathAsync:(NSIndexPath *)indexPath
{
    return 0.f;
}

#pragma mark - Support

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo animations:(void(^)(CGFloat keyboardHeight))animations
{
    CGFloat keyboardHeight = (notificationUserInfo[@"UIKeyboardBoundsUserInfoKey"] ? [notificationUserInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height : 0.f);
    if (!keyboardHeight)
        keyboardHeight = (notificationUserInfo[UIKeyboardFrameBeginUserInfoKey] ? [notificationUserInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height : 0.f);
    if (!keyboardHeight)
        keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? [notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0.f);
    if (!keyboardHeight)
        return;
    
    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (animations) animations(keyboardHeight);
    
    [UIView commitAnimations];
}

@end

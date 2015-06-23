//
//  DemoScrollViewController.m
//  LGViewControllersDemo
//
//  Created by Grigory Lutkov on 26.03.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "DemoScrollViewController.h"

@interface DemoScrollViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation DemoScrollViewController

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithPlaceholderViewEnabled:YES refreshViewEnabled:YES];
    if (self)
    {
        self.title = title;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        _label = [UILabel new];
        _label.text = @"Updated never";
        _label.textColor = [UIColor blackColor];
        [self.scrollView addSubview:_label];
        
        _textField = [UITextField new];
        _textField.placeholder = @"UITextField";
        _textField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f];
        [self.scrollView addSubview:_textField];
        
        self.scrollView.alwaysBounceVertical = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction)];
        gesture.delegate = self;
        [self.scrollView addGestureRecognizer:gesture];
        
        self.keyboardShowHideObserverEnabled = YES;
        
        [self.scrollView.placeholderView showActivityIndicatorAnimated:NO completionHandler:nil];
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
    
    CGFloat shift = 20.f;
    
    [_label sizeToFit];
    _label.center = CGPointMake(self.view.frame.size.width/2, shift+_label.frame.size.height/2);
    _label.frame = CGRectIntegral(_label.frame);
    
    _textField.frame = CGRectMake(10.f, self.scrollView.frame.size.height-self.scrollView.contentInset.top-shift-44.f, self.view.frame.size.width-20.f, 44.f);
    _textField.frame = CGRectIntegral(_textField.frame);
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _textField.frame.origin.y+_textField.frame.size.height+shift);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                   {
                       [self.scrollView.placeholderView dismissAnimated:YES completionHandler:nil];
                   });
}

#pragma mark - Refresh

- (void)refreshActions
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd.MM.yyyy HH:mm:ss";
    
    _label.text = [NSString stringWithFormat:@"Updated %@", [dateFormatter stringFromDate:date]];
    
    CGFloat shift = 20.f;
    
    [_label sizeToFit];
    _label.center = CGPointMake(self.scrollView.frame.size.width/2, shift+_label.frame.size.height/2);
    
    [UIView transitionWithView:_label duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    
    [self.scrollView.refreshView endRefreshing];
}

#pragma mark - Keyboard

- (void)keyboardWillShowHideActionsAppear:(BOOL)appear keyboardHeight:(CGFloat)keyboardHeight
{
    [super keyboardWillShowHideActionsAppear:appear keyboardHeight:keyboardHeight];
    
    if (appear)
        [self.scrollView scrollRectToVisible:_textField.frame animated:NO];
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIControl class]];
}

#pragma mark -

- (void)gestureAction
{
    [self.view endEditing:YES];
}

@end

//
//  ViewController.m
//  LGViewControllersDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "TableViewController.h"
#import "DemoScrollViewController.h"
#import "DemoTableViewController.h"
#import "DemoCollectionViewController.h"
#import "LGWebViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"LGViewControllers";
        
        _titlesArray = @[@"LGScrollViewController",
                         @"LGTableViewController",
                         @"LGCollectionViewController",
                         @"LGWebViewController"];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        DemoScrollViewController *viewController = [[DemoScrollViewController alloc] initWithTitle:_titlesArray[indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 1)
    {
        DemoTableViewController *viewController = [[DemoTableViewController alloc] initWithTitle:_titlesArray[indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2)
    {
        DemoCollectionViewController *viewController = [[DemoCollectionViewController alloc] initWithTitle:_titlesArray[indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 3)
    {
        LGWebViewController *viewController = [[LGWebViewController alloc] initWithTitle:_titlesArray[indexPath.row]
                                                                                     url:[NSURL URLWithString:@"http://google.com"]
                                                                  placeholderViewEnabled:YES];
        viewController.webView.placeholderView.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

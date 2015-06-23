//
//  LGTableView.h
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

#import <UIKit/UIKit.h>
#import "LGPlaceholderView.h"
#import "LGRefreshView.h"

@class LGTableView;

@protocol LGTableViewDelegate <NSObject>

@required

- (CGFloat)tableView:(LGTableView *)tableView heightForRowAtIndexPathAsync:(NSIndexPath *)indexPath;

@end

@interface LGTableView : UITableView

@property (strong, nonatomic, readonly) NSMutableArray *heightForRowsArray;

@property (assign, nonatomic) id<LGTableViewDelegate> delegateLG;

@property (assign, nonatomic, readonly, getter=isRefreshViewEnabled) BOOL refreshViewEnabled;
@property (assign, nonatomic, getter=isPlaceholderViewEnabled) BOOL placeholderViewEnabled;

@property (strong, nonatomic) LGRefreshView *refreshView;
@property (strong, nonatomic) LGPlaceholderView *placeholderView;

- (instancetype)initWithStyle:(UITableViewStyle)style;

/** Do not forget about weak referens to self for refreshHandler block */
- (instancetype)initWithStyle:(UITableViewStyle)style placeholderViewEnabled:(BOOL)placeholderViewEnabled refreshHandler:(void(^)())refreshHandler;

/** Do not forget about weak referens to self for refreshHandler block */
- (void)setRefreshViewEnabledWithHandler:(void(^)())refreshHandler;
- (void)setRefreshViewDisabled;

- (void)addTopSeparatorViewWithColor:(UIColor *)color thinckness:(CGFloat)thinckness edgeInsets:(UIEdgeInsets)edgeInsets;

#pragma mark -

- (void)reloadDataWithCompletionHandler:(void(^)())completionHandler;
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler;

#pragma mark -

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler;
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler;

#pragma mark -

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation completionHandler:(void(^)())completionHandler;

#pragma mark -

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath completionHandler:(void(^)())completionHandler;
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection completionHandler:(void(^)())completionHandler;

@end

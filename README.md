# LGViewControllers

Classes extends abilities of UITableViewController, UICollectionViewController, and more.
- [LGScrollViewController](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGScrollViewController/LGScrollViewController.h) is view controller with LGScrollView as root view, that has LGPlaceholderView and LGRefreshView by default. View controller can watch for show/hide keyboard actions and scroll to first responder view without any manipulation.
- [LGTableViewController](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGTableViewController/LGTableViewController.h) can do everything like LGScrollViewController, more than that it can reload table view asynchronously, without freezing UI.
- [LGCollectionViewController](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGCollectionViewController/LGCollectionViewController.h) can do everything like LGScrollViewController, more than that it has easy initialization methods, to faster setup layout.
- [LGWebViewController](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGWebViewController/LGWebViewController.h) is view controller with LGWebView as root view, that has LGPlaceholderView by default. View controller has easy initialization methods, to use it without subclassing.
- [LGViewControllerAnimator](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGViewControllerAnimator/LGViewControllerAnimator.h) is class that implement slide animation between view controllers.

## Installation

### With source code

- [Download repository](https://github.com/Friend-LGA/LGViewControllers/archive/master.zip), then add [LGViewControllers directory](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/) to your project.
- Also you need to install libraries:
  - [LGPlaceholderView](https://github.com/Friend-LGA/LGPlaceholderView)
  - [LGRefreshView](https://github.com/Friend-LGA/LGRefreshView)

### With CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the "Get Started" section for more details.

#### Podfile
```
platform :ios, '6.0'
pod 'LGViewControllers', '~> 1.0.0'
```

## Usage

In the source files where you need to use the library, import the header file:

```objective-c
#import "LGViewControllers.h"
```

Or you can use sublibraries separately, depend of your needs: 

```objective-c
#import "LGScrollViewController.h"
#import "LGTableViewController.h"
#import "LGCollectionViewController.h"
#import "LGWebViewController.h"

#import "LGScrollView.h"
#import "LGTableView.h"
#import "LGCollectionView.h"
#import "LGWebView.h"

#import "LGViewControllerAnimator.h"
```

### More

For more details try Xcode [Demo project](https://github.com/Friend-LGA/LGViewControllers/blob/master/Demo) and see files:
- [LGScrollViewController.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGScrollViewController/LGScrollViewController.h) and [LGScrollView.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGScrollViewController/LGScrollView.h)
- [LGTableViewController.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGTableViewController/LGTableViewController.h) and [LGTableView.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGTableViewController/LGTableView.h)
- [LGCollectionViewController.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGCollectionViewController/LGCollectionViewController.h) and [LGCollectionView.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGCollectionViewController/LGCollectionView.h)
- [LGWebViewController.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGWebViewController/LGWebViewController.h) and [LGWebView.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGWebViewController/LGWebView.h)
- [LGViewControllerAnimator.h](https://github.com/Friend-LGA/LGViewControllers/blob/master/LGViewControllers/LGViewControllerAnimator/LGViewControllerAnimator.h)

## License

LGViewControllers is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGViewControllers/master/LICENSE) for details.

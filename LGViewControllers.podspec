Pod::Spec.new do |s|

    s.name = 'LGViewControllers'
    s.version = '1.0.0'
    s.platform = :ios, '6.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGViewControllers'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGViewControllers.git', :tag => s.version }
    s.summary = 'Classes extends abilities of UITableViewController, UICollectionViewController, and more'

    s.requires_arc = true

    s.source_files = 'LGViewControllers/*.{h,m}'
    s.source_files = 'LGViewControllers/**/*.{h,m}'

    s.dependency 'LGRefreshView', '~> 1.0.0'
    s.dependency 'LGPlaceholderView', '~> 1.0.0'

end

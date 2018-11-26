//
//  QTIMAddressBookSearchViewController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/23.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMAddressBookSearchViewController.h"

#import "QTIMMacros.h"
#import "UIImage+QTIM.h"

@interface QTIMAddressBookSearchViewController () <UISearchControllerDelegate>
@end

@implementation QTIMAddressBookSearchViewController
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        self.dimsBackgroundDuringPresentation = NO;
        
        [self.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        self.searchBar.placeholder = @"搜索";
        self.searchBar.barTintColor = backGroundColor;
        self.searchBar.backgroundImage = [UIImage imageWithColor:backGroundColor];
        self.delegate = self;
        self.searchBar.tintColor = MainBlueColor(1);
        self.searchResultsUpdater = (id<UISearchResultsUpdating>)searchResultsController;

//        UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    }
    return self;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    CGFloat height = 76;
    if (is_iPhoneXSerious) {
        height = 100;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, height)];
    view.backgroundColor = backGroundColor;
    [self.view insertSubview:view atIndex:0];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.view.subviews[0] removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end

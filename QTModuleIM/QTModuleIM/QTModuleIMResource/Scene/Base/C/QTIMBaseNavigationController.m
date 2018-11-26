//
//  QTIMNavigationController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/18.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "QTIMBaseNavigationController.h"

#import "QTIMMacros.h"
#import "UIImage+QTIM.h"

@interface QTIMBaseNavigationController ()

@end

@implementation QTIMBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:MainBlueColor(1)] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  QTIMLoginController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/19.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "QTIMLoginController.h"
//#import "QTIMTabBarController.h"
#import "QTIMConversationController.h"
#import "QTIMConversationListController.h"
#import "QTIMBaseNavigationController.h"

#import "AFNetworking.h"
#import "QTIMMacros.h"
#import "QTIMBridgeManager.h"
#import "SeptnetHttp.h"
#import "QTIMLoadingView.h"
//#import "RCMCDMessageManager.h"


@interface QTIMLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation QTIMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
//    QTINFOLog(@"%@",[[NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"users_config" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil] valueForKey:@"base_url"]);
    
    [self setLeftItemImage:nil];
}

- (IBAction)didClickLogin:(id)sender
{
    if (_passwordTextField.text.length == 0) {
        QTERRORLog(@"请输入名称或");
        return;
    }
    [self.activity startAnimating];
     [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:QTIMUserDefaultsUserPhoneKey];
    [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/login") param:@{@"id" : _passwordTextField.text}] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSError class]] || [[x valueForKey:@"code"] integerValue] != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activity stopAnimating];
            });
            return ;
        }
        [[QTIMBridgeManager defaultManager] initWithAppKey:QTIMRongAppKey];
        [[QTIMBridgeManager defaultManager] connectRongServerWithUserInfo:[x valueForKey:@"data"] completion:^(BOOL isSucc, RCConnectErrorCode code) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activity stopAnimating];
                if (isSucc) {
                    //FIXME:存储手机号
                    [[NSUserDefaults standardUserDefaults] setObject:[[x valueForKey:@"data"] valueForKey:@"phone"] forKey:QTIMUserDefaultsUserPhoneKey];
                    QTIMConvListViewModel *viewModel = [QTIMConvListViewModel new];
                    QTIMConversationListController *vc = [[QTIMConversationListController alloc] initWithViewModel:viewModel];
                    QTIMBaseNavigationController *nc = [[QTIMBaseNavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:nc animated:YES completion:nil];
                }
            });
        }];
    }];
}


@end

//
//  AppDelegate+QTIM.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/24.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "AppDelegate+QTIM.h"

#import "QTIMBridgeManager.h"
#import "QTIMMacros.h"

#import <objc/runtime.h>

#if NSFoundationVersionNumber_iOS_9_x_Max
#define UNNotificationCenter [UNUserNotificationCenter currentNotificationCenter]
#endif

@implementation AppDelegate (QTIM)
+ (void)load
{
    Method originalDidFinishLaunching, swizzledDidFinishLaunching;
    originalDidFinishLaunching = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
    swizzledDidFinishLaunching = class_getInstanceMethod(self, @selector(swizzled_application:didFinishLaunchingWithOptions:));
    method_exchangeImplementations(originalDidFinishLaunching, swizzledDidFinishLaunching);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

-(BOOL)swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    [self registerAPNS:application];
    BOOL flag = [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];

    NSDictionary *infoDicNew = [NSBundle mainBundle].infoDictionary;
    NSString *rongyunId = infoDicNew[@"RongyunAppID"];
//    [[QTIMBridgeManager defaultManager] initWithAppKey:rongyunId];
    //FIXME:rongyunid
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (nil != remoteNotificationUserInfo) {
        NSLog(@"%@",remoteNotificationUserInfo);
        
        NSDictionary *rc = [remoteNotificationUserInfo objectForKey:@"rc"];
        if (nil == rc) {
            return flag;
        }
        [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:remoteNotificationUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:QTIMAppInActiveReceivedNotification
                                                            object:nil
                                                          userInfo:remoteNotificationUserInfo];
    }
    return flag;
}

#if NSFoundationVersionNumber_iOS_9_x_Max
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0)
{
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED
{
    [self foregroundPushToConversationWithUserInfo:response.notification.request.content.userInfo];
    completionHandler();
}
#else
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    [self foregroundPushToConversationWithUserInfo:userInfo];
}
#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
}

- (void)foregroundPushToConversationWithUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *rc = [userInfo objectForKey:@"rc"];
    if (nil == rc) {
        // 不是聊天的通知
        return;
    }
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:QTIMAppActiveReceivedNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)registerAPNS:(UIApplication *)application
{
    #if NSFoundationVersionNumber_iOS_9_x_Max // 编译时
        if (@available(iOS 10.0, *)) { // yun'xing'shi
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [application registerForRemoteNotifications];
                    });
                }
            }];
        }
    #else
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    #pragma clang diagnostic pop
    #endif
}

@end

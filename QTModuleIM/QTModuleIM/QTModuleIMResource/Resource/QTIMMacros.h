//
//  QTIMMacros.h
//  RIMDemo
//
//  Created by 未可知 on 2018/10/22.
//  Copyright © 2018年 QT. All rights reserved.
//

#pragma mark - Notification
#define QTIMAppInActiveReceivedNotification @"QTIMAppInActiveReceivedNotification"
#define QTIMAppActiveReceivedNotification @"QTIMAppActiveReceivedNotification"
#define QTIMDidQuitGroupNotification @"QTIMDidQuitGroupNotification"
#define QTIMDidDismissGroupNotification @"QTIMDidDismissGroupNotification"
#define QTIMDidClickSystemNotification @"QTIMDidClickSystemNotification"
#define QTIMDidClickCompanyNotification @"QTIMDidClickCompanyNotification"

#define QTIMUserDefaultsUserPhoneKey @"QTIMUserDefaultsUserPhoneKey"


#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

#define QTIMRongAppKey [[NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"users_config" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil] valueForKey:@"appkey"]


#define is_iPhoneXSerious @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0

#define backGroundColor [UIColor colorWithRed:236.f/255 green:236.f/255 blue:244.f/255 alpha:1]
#define MainBlueColor(a) [UIColor colorWithRed:15.f/255 green:131.f/255 blue:255.f/255 alpha:a]
#define QTIMHEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define QTIMHEXCOLORAlpha(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]

#ifdef DEBUG
#define QTINFOLog(fmt, ...) NSLog((@" | QITIAN |  %s  [Line %d] INFO: ----> " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define QTERRORLog(fmt, ...) NSLog((@" | QITIAN |  %s  [Line %d]  ERROR: ****** " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define QTINFOLog(...);
#define QTERRORLog(...);
#endif




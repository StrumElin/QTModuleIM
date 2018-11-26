//
//  QTIMGroupInfoModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#define GroupUserInfoRolePlus NSIntegerMax - 1
#define GroupUserInfoRoleMinus NSIntegerMax - 2

#import <Foundation/Foundation.h>
#import "QTIMAddressBookListContentAdaptor.h"

@interface QTIMGroupInfoModel : NSObject
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *creatUser;
@property (nonatomic, strong) NSMutableArray *members;
@end

@interface QTIMGroupUserInfoModel : NSObject <QTIMAddressBookListContentAdaptor>
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger role;

@property (nonatomic, assign) NSInteger status;

@end

//
//  QTIMUserInfoModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTIMAddressBookListContentAdaptor.h"

@interface QTIMUserInfoModel : NSObject <QTIMAddressBookListContentAdaptor, NSCopying>
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *depart;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSArray *Area;

@property (nonatomic, assign) NSInteger status; // 0 未选择 1 已经选择 3 不可以被选择
@end

@interface QTIMUserInfoAreaModel : NSObject
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *code;
@end


/**
 *                 "id": 10,
 "phone": "13739281745",
 "name": "查自成",
 "avatar": "http://115.28.115.220:3000/upload/user/10/avatar.png",
 "depart": "产品研发中心",
 "role": "产品经理",
 "pinyin": "chazicheng"
 */

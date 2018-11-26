//
//  QTIMUserInfoModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoModel.h"

@implementation QTIMUserInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"Area" : @"QTIMUserInfoAreaModel"
             };
}

- (NSString *)avatarString
{
    return _avatar;
}

- (NSString *)nameString
{
    return _name;
}

- (NSString *)IdString
{
    return _Id;
}

- (NSInteger)statusInteger
{
    return _status;
}

- (id)copyWithZone:(NSZone *)zone
{
    QTIMUserInfoModel *model = [QTIMUserInfoModel new];
    model.Id = self.Id;
    model.phone = self.phone;
    model.name = self.name;
    model.avatar = self.avatar;
    model.depart = self.depart;
    model.role = self.role;
    model.pinyin = self.pinyin;
    model.status = self.status;
    return model;
}
@end

@implementation QTIMUserInfoAreaModel
@end

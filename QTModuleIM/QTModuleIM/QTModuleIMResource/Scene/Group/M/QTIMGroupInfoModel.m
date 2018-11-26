//
//  QTIMGroupInfoModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoModel.h"

@implementation QTIMGroupInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"members" : @"QTIMGroupUserInfoModel"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}
@end

@implementation QTIMGroupUserInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
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

@end

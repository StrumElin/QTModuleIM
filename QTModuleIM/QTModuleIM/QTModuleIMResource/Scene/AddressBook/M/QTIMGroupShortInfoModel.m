//
//  QTIMGroupShortInfoModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupShortInfoModel.h"

@implementation QTIMGroupShortInfoModel
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

- (id)copyWithZone:(NSZone *)zone
{
    QTIMGroupShortInfoModel *model = [QTIMGroupShortInfoModel new];
    model.Id = self.Id;
    model.name = self.name;
    model.avatar = self.avatar;
    return model;
}
@end

//
//  QTIMUserInfoDisplayModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoDisplayModel.h"

@implementation QTIMUserInfoDisplayModel
- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc
{
    if (self = [super init]) {
        _title = title;
        _desc = desc;
    }
    return self;
}
@end

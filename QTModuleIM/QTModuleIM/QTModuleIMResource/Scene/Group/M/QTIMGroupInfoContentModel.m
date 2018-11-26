//
//  QTIMGroupInfoContentModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoContentModel.h"

@implementation QTIMGroupInfoContentModel
- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc isOn:(NSInteger)isOn
{
    if (self = [super init]) {
        _title = title;
        _desc = desc;
        _isOn = isOn;
    }
    return self;
}
@end

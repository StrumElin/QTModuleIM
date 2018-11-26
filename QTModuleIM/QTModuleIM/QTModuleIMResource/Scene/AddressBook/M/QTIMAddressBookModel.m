//
//  QTIMAddressBookModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMAddressBookModel.h"

@implementation QTIMAddressBookModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"list" : @"QTIMAddressBookListModel"
             };
}

//- (QTIMAddressBookListModel *)isExistModel:(QTIMAddressBookListModel *)listModel
//{
//    if (nil == self || self.list.count == 0) {
//        return nil;
//    }
//    for (QTIMAddressBookListModel *model in self.list) {
//        if (model.letter.length && [model.letter isEqualToString:listModel.letter]) {
//            return model;
//        }
//    }
//    return nil;
//}

- (BOOL)isContainsGroup
{
    for (QTIMAddressBookListModel *listModel in self.list) {
        if ([listModel.letter isEqualToString:@"#"]) {
            return YES;
        }
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone
{
    QTIMAddressBookModel *model = [QTIMAddressBookModel new];
    model.num = self.num;
    model.list = [NSMutableArray new];
    for (QTIMAddressBookListModel *listModel in self.list) {
        [model.list addObject:[listModel copy]];
    }
    return model;
}
@end

@implementation QTIMAddressBookListModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"list" : @"QTIMUserInfoModel"
             };
}

- (id)copyWithZone:(NSZone *)zone
{
    QTIMAddressBookListModel *model = [QTIMAddressBookListModel new];
    model.letter = self.letter;
    model.list = [NSMutableArray new];
    for (QTIMUserInfoModel *user in self.list) {
        [model.list addObject:[user copy]];
    }
    return model;
}
@end

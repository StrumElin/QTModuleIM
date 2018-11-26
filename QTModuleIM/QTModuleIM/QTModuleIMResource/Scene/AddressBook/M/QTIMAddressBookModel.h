//
//  QTIMAddressBookModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTIMUserInfoModel.h"

@class QTIMAddressBookListModel;
@interface QTIMAddressBookModel : NSObject <NSCopying>
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSNumber *num;

//- (QTIMAddressBookListModel *)isExistModel:(QTIMAddressBookListModel *)listModel;

- (BOOL)isContainsGroup;

@end

@interface QTIMAddressBookListModel : NSObject <NSCopying>
@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSMutableArray *list;
@end


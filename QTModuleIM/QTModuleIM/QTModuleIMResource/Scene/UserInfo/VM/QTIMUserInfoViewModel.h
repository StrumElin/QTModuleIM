//
//  QTIMUserInfoViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"
#import "QTIMUserInfoModel.h"
#import "QTIMUserInfoDisplayModel.h"

@interface QTIMUserInfoViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) QTIMUserInfoModel *userInfo;
@property (nonatomic, strong, readonly) NSArray *dataSource;
@property (nonatomic, strong, readonly) NSString *userId;

- (instancetype)initWithUserInfo:(QTIMUserInfoModel *)userInfo;

- (instancetype)initWithUserId:(NSString *)userId;

- (RACSignal *)fetchUserInfo;

@end

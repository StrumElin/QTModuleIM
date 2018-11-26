//
//  QTIMUserInfoViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoViewModel.h"

@interface QTIMUserInfoViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) QTIMUserInfoModel *userInfo;
@property (nonatomic, strong) NSString *userId;
@end

@implementation QTIMUserInfoViewModel
- (instancetype)initWithUserInfo:(QTIMUserInfoModel *)userInfo
{
    if (self = [super init]) {
        _title = @"详细资料";
        _userInfo = userInfo;
        
        /**
         * 职位 管辖区域
         */
        QTIMUserInfoDisplayModel *roModel = [[QTIMUserInfoDisplayModel alloc] initWithTitle:@"职位" desc:userInfo.role];
        QTIMUserInfoDisplayModel *depModel = [[QTIMUserInfoDisplayModel alloc] initWithTitle:@"管辖区域" desc:nil];
        self.dataSource = @[roModel,depModel];
        
    }
    return self;
}

- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        _title = @"详细资料";
        _userId = userId;
    }
    return self;
}

- (RACSignal *)fetchUserInfo
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/user/info") param:@{@"id" : self.userId}] subscribeNext:^(id  _Nullable x) {
            QTIMUserInfoModel *model = [QTIMUserInfoModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
            self.userInfo = model;
            QTIMUserInfoDisplayModel *roModel = [[QTIMUserInfoDisplayModel alloc] initWithTitle:@"部门" desc:model.depart];
            NSMutableString *area = [NSMutableString new];
            for (QTIMUserInfoAreaModel *areaModel in model.Area) {
                [area appendFormat:@"%@ ",areaModel.area];
            }
            if (area.length) {
                [area appendString:area];
            }
            QTIMUserInfoDisplayModel *depModel = [[QTIMUserInfoDisplayModel alloc] initWithTitle:@"管辖区域" desc:area];
            self.dataSource = @[roModel,depModel];
            [subscriber sendNext:model];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


@end

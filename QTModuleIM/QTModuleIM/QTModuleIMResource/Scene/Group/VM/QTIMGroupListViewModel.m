//
//  QTIMGroupListViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/24.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupListViewModel.h"

@interface QTIMGroupListViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation QTIMGroupListViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"选择群聊";
    }
    return self;
}

- (RACSignal *)fetchGroupData
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/list") param:nil] subscribeNext:^(id  _Nullable x) {
            x = [x valueForKey:@"data"];
            self.dataSource = [QTIMGroupShortInfoModel mj_objectArrayWithKeyValuesArray:x];
            [subscriber sendNext:self.dataSource];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}
@end

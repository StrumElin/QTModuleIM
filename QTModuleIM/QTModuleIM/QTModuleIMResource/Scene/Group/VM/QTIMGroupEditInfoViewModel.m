//
//  QTIMGroupEditInfoViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupEditInfoViewModel.h"

@interface QTIMGroupEditInfoViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *name;
@end

@implementation QTIMGroupEditInfoViewModel
- (instancetype)initWithGroupId:(NSString *)groupId name:(NSString *)name
{
    if (self = [super init]) {
        self.groupId = groupId;
        self.name = name;
        self.title = @"群组名称";
    }
    return self;
}

- (RACSignal *)updateGroupInfoWithName:(NSString *)name
{
    if (!name.length) {
        return nil;
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/update") param:@{@"groupId" : self.groupId, @"name" : name}] subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}
@end

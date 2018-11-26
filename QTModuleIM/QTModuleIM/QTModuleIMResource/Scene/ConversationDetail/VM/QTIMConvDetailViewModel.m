//
//  QTIMConvDetailViewModel.m
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import "QTIMConvDetailViewModel.h"

#import "QTIMGroupInfoModel.h"

@interface QTIMConvDetailViewModel ()
@property (nonatomic, strong) QTIMGroupInfoModel *groupInfo;
@property (nonatomic, assign) RCConversationType type;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *title;
@end

@implementation QTIMConvDetailViewModel
- (instancetype)initWithConvType:(RCConversationType)aType targetId:(NSString *)aId title:(NSString *)title
{
    return [self initWithConvType:aType targetId:aId title:title groupInfo:nil];
}

- (instancetype)initWithConvType:(RCConversationType)aType targetId:(NSString *)aId title:(NSString *)title groupInfo:(QTIMGroupInfoModel *)groupInfo
{
    if (self = [super init]) {
        _type = aType;
        _targetId = aId;
        _title = title;
        _groupInfo = groupInfo;
    }
    return self;
}

- (RACSignal *)fetchGroupInfo
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/group/getInfo") param:@{@"groupId" : self.targetId}] subscribeNext:^(id  _Nullable x) {
            self.groupInfo = [QTIMGroupInfoModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
            self.title = [NSString stringWithFormat:@"%@(%ld)",self.groupInfo.name,self.groupInfo.members.count];
            [subscriber sendNext:self.title];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}
@end

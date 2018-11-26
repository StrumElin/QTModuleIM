//
//  QTIMGroupInfoViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoViewModel.h"

#import "QTIMGroupInfoContentModel.h"

#import "SeptnetHttp.h"
#import "QTIMMacros.h"

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>

@interface QTIMGroupInfoViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) QTIMGroupInfoModel *model;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSArray *listDatas;
@property (nonatomic, strong) NSArray <NSString*> *userIds;
@end

@implementation QTIMGroupInfoViewModel
- (instancetype)initWithId:(NSString *)aId
{
    if (self = [super init]) {
        self.groupId = aId;
    }
    return self;
}

//- (instancetype)initWithGroupInfo:(QTIMGroupInfoModel *)groupInfo
//{
//    self = [self initWithId:groupInfo.Id];
//    self.model = groupInfo;
//    NSMutableArray *ids = [NSMutableArray new];
//    for (QTIMGroupUserInfoModel *user in self.model.members) {
//        [ids addObject:user.Id];
//    }
//    self.userIds = [[NSArray alloc] initWithArray:ids];
//    self.title = [NSString stringWithFormat:@"群组信息(%ld)",self.model.members.count];
//    //添加➕  ➖ 的数据
//    [self insertPlusAndMinus];
//    //headerHeight计算
//    self.headerHeight = [self calculateHeaderHeight];
//    return self;
//}

- (RACSignal *)fetchGroupInfo
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/group/getInfo") param:@{@"groupId" : self.groupId}] subscribeNext:^(id  _Nullable x) {
            self.model = [QTIMGroupInfoModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
            
            NSMutableArray *ids = [NSMutableArray new];
            for (QTIMGroupUserInfoModel *user in self.model.members) {
                [ids addObject:user.Id];
            }
            self.userIds = [[NSArray alloc] initWithArray:ids];
            
            self.title = [NSString stringWithFormat:@"群组信息(%ld)",self.model.members.count];
            
            //添加➕  ➖ 的数据
            [self insertPlusAndMinus];
            
            //headerHeight计算
            self.headerHeight = [self calculateHeaderHeight];
            
            [subscriber sendNext:self.model];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)fetchGroupPageListData
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.model.Id success:^(RCConversationNotificationStatus nStatus) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:[self constructListDataStatus:nStatus]];
            });
        } error:^(RCErrorCode status) {
            NSAssert(0, @"getConversationNotificationStatus %ld",status);
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendError:nil];
            });
        }];
        return nil;
    }];
}

- (NSArray *)constructListDataStatus:(RCConversationNotificationStatus)status
{
    NSMutableArray *datas = [NSMutableArray new];
    NSInteger count = [self createrIsSelf] ? self.model.members.count - 2 : self.model.members.count - 1;
    QTIMGroupInfoContentModel *member = [[QTIMGroupInfoContentModel alloc] initWithTitle:[NSString stringWithFormat:@"全部成员(%ld)",count] desc:nil isOn:NSIntegerMax];
    
    [datas addObject:@[member]];
    QTIMGroupInfoContentModel *name = [[QTIMGroupInfoContentModel alloc] initWithTitle:@"群组名称" desc:self.model.name isOn:NSIntegerMax];
    [datas addObject:@[name]];
    QTIMGroupInfoContentModel *silence = [[QTIMGroupInfoContentModel alloc] initWithTitle:@"消息免打扰" desc:self.model.name isOn:(status + 1)&1];
    NSArray *convs = [[RCIMClient sharedRCIMClient] getTopConversationList:@[@(ConversationType_GROUP)]];
    NSInteger flag = 0;
    for (RCConversation *conv in convs) {
        if ([conv.targetId isEqualToString:self.model.Id]) {
            flag = 1;
            break;
        }
    }
    QTIMGroupInfoContentModel *top = [[QTIMGroupInfoContentModel alloc] initWithTitle:@"会话置顶" desc:self.model.name isOn:flag];
    [datas addObject:@[silence,top]];
    self.listDatas = [NSArray arrayWithArray:datas];
    return self.listDatas;
}

- (RACSignal *)quitGroup
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
            [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/quit") param:@{@"ids" : @[[RCIM sharedRCIM].currentUserInfo.userId], @"groupId" : self.model.Id}] subscribeNext:^(id  _Nullable x) {
                // FIXME: 当人数为2人时 返回201 人数不足，群解散
                if ([[x valueForKey:@"code"] integerValue]== 200) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:QTIMDidQuitGroupNotification
                                                                        object:nil
                                                                      userInfo:@{@"id" : self.model.Id}];
                }
                [subscriber sendNext:x];
            } error:^(NSError * _Nullable error) {
                [subscriber sendError:error];
            }];
        return nil;
    }];
}

- (RACSignal *)constructSelectPageDataIsPlus:(BOOL)isPlus
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSMutableArray *filters = [NSMutableArray new];
        if (isPlus) {
            for (QTIMGroupUserInfoModel *user in self.model.members) {
                if (user.role == GroupUserInfoRolePlus || user.role == GroupUserInfoRoleMinus) {
                    [filters addObject:user];
                }
            }
            for (QTIMGroupUserInfoModel *user in filters) {
                [self.model.members removeObject:user];
            }
        }
        else {
            for (QTIMGroupUserInfoModel *user in self.model.members) {
                if (user.role == GroupUserInfoRolePlus || user.role == GroupUserInfoRoleMinus || [user.Id isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                    [filters addObject:user];
                }
            }
            for (QTIMGroupUserInfoModel *user in filters) {
                [self.model.members removeObject:user];
            }
        }
        [subscriber sendNext:self.model];
        return nil;
    }];
}

#pragma mark - Privite
- (BOOL)createrIsSelf
{
    return [[RCIM sharedRCIM].currentUserInfo.userId isEqualToString:self.model.creatUser];
}

- (NSInteger)displayLine
{
    if (self.model.members.count >= 20) {
        return 4;
    }
    NSInteger line;
    if (self.model.members.count%LineItemCount == 0) {
        line = self.model.members.count/LineItemCount;
    }
    else {
        line = self.model.members.count/LineItemCount + 1;
    }
    return line;
}

- (CGFloat)calculateHeaderHeight
{
    if (self.model.members.count >= DisplayMaxCount) {
        return ((MainScreenWidth - 40 - 20 * (LineItemCount - 1))/LineItemCount + 24) * MaxLine + 20 + 20 + 20 * (MaxLine - 1);
    }
    else {
        if ([[RCIM sharedRCIM].currentUserInfo.userId isEqualToString:self.model.creatUser]) {
            if (self.model.members.count%LineItemCount == 1 || self.model.members.count%LineItemCount == 2) {
                // 处理
                NSInteger line = [self displayLine];
                return ((MainScreenWidth - 40 - 20 * (LineItemCount -1))/LineItemCount + 24) * line + 20 + 20 + 20 * (line - 1) - 24;
            }
            else {
                    NSInteger line = [self displayLine];
                    return ((MainScreenWidth - 40 - 20 * (LineItemCount -1))/LineItemCount + 24) * line + 20 + 20 + 20 * (line - 1);
            }
        }
        else {
            if (self.model.members.count%LineItemCount == 1) {
                NSInteger line = [self displayLine];
                return ((MainScreenWidth - 40 - 20 * (LineItemCount -1))/LineItemCount + 24) * line + 20 + 20 + 20 * (line - 1) - 24;
            }
            else {
                NSInteger line = [self displayLine];
                return ((MainScreenWidth - 40 - 20 * (LineItemCount -1))/LineItemCount + 24) * line + 20 + 20 + 20 * (line - 1);
                }
        }
    }
}

- (void)insertPlusAndMinus
{
    if (self.model.members.count <= DisplayMaxCount - 2) {
        QTIMGroupUserInfoModel *plus = [QTIMGroupUserInfoModel new];
        plus.role = GroupUserInfoRolePlus;
        [self.model.members addObject:plus];
        if ([self.model.creatUser isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            QTIMGroupUserInfoModel *minus = [QTIMGroupUserInfoModel new];
            minus.role = GroupUserInfoRoleMinus;
            [self.model.members addObject:minus];
        }
    }
    else {
        QTIMGroupUserInfoModel *plus = [QTIMGroupUserInfoModel new];
        plus.role = GroupUserInfoRolePlus;
        [self.model.members insertObject:plus atIndex:DisplayMaxCount - 2];
        if ([self.model.creatUser isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            QTIMGroupUserInfoModel *minus = [QTIMGroupUserInfoModel new];
            minus.role = GroupUserInfoRoleMinus;
            [self.model.members insertObject:minus atIndex:DisplayMaxCount -1];
        }
    }
}
@end

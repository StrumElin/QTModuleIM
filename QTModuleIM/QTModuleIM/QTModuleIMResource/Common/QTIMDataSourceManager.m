//
//  QTIMDataSourceManager.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMDataSourceManager.h"

#import "QTIMUserInfoModel.h"

#import "QTIMMacros.h"
#import "SeptnetHttp.h"
#import "MJExtension.h"

@implementation QTIMDataSourceManager
+ (instancetype)defaultManager
{
    static QTIMDataSourceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)clearConvWithConvType:(RCConversationType)aType targetId:(NSString *)targetId completion:(void (^)(BOOL, RCErrorCode))completion
{
        //MARK:Test
        BOOL flag = [[RCIMClient sharedRCIMClient] removeConversation:aType targetId:targetId];
    if (!flag) {
        if (completion) {
            completion(NO,0000);
        }
    }
        [[RCIMClient sharedRCIMClient] deleteMessages:aType targetId:targetId success:^{
            if (completion) {
                completion(YES,0);
            }
        } error:^(RCErrorCode status) {
            if (completion) {
                completion(NO,status);
            }
        }];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    if (nil == userId) {
        QTERRORLog(@"userId is nil");
        return;
    }
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        completion([RCIM sharedRCIM].currentUserInfo);
    }
    else {
        RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:userId];
        if (user) {
            if (completion) {
                completion(user);
            }
        }
        else {
            [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/user/info") param:@{@"id" : userId}] subscribeNext:^(id  _Nullable x) {
                QTIMUserInfoModel *user = [QTIMUserInfoModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
                RCUserInfo *rcUser = [[RCUserInfo alloc] initWithUserId:user.Id
                                                                   name:user.name
                                                               portrait:user.avatar];
                [[RCIM sharedRCIM] refreshUserInfoCache:rcUser withUserId:rcUser.userId];
                if (completion) {
                    completion(rcUser);
                }
            } error:^(NSError * _Nullable error) {
                QTERRORLog(@"%@",error);
            }];
        }
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion
{
    if (nil == groupId) {
        return;
    }
//    @weakify(self);
    [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/group/getInfo") param:@{@"groupId" : groupId}] subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
        x = [x valueForKey:@"data"];
        RCGroup *group = [[RCGroup alloc] initWithGroupId:groupId
                                                groupName:[x valueForKey:@"name"]
                                              portraitUri:[x valueForKey:@"avatar"]];
        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
        if (completion) {
            completion(group);
        }
        QTINFOLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        QTERRORLog(@"%@",error);
    }];
}

- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSParameterAssert(0);
}

- (void)getAllContacts:(void (^)(NSArray<RCCCUserInfo *> *contactsInfoList))resultBlock
{
    
}

- (void)getGroupInfoByGroupId:(NSString *)groupId result:(void (^)(RCCCGroupInfo *groupInfo))resultBlock
{
    
}
@end

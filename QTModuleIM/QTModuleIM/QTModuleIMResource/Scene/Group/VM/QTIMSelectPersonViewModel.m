//
//  QTIMSelectPersonViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMSelectPersonViewModel.h"

#import "SeptnetHttp.h"
#import "QTIMMacros.h"
#import "BMChineseSort.h"

@interface QTIMSelectPersonViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) QTIMAddressBookModel *model;
@property (nonatomic, strong) NSMutableArray *selectedUsers;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *filterUsers;
@property (nonatomic, strong) NSMutableArray *filterIds;
@property (nonatomic, assign) QTIMSelectPersonDataSourceType type;
@property (nonatomic, strong) NSString *groupId;

@property (nonatomic, strong) NSMutableArray *userList;

@end

@implementation QTIMSelectPersonViewModel
- (instancetype)initWithFilterUsers:(NSArray<QTIMGroupUserInfoModel *> *)filterUsers type:(QTIMSelectPersonDataSourceType)type groupId:(NSString *)groupId
{
    if (self = [super init]) {
        self.title = @"选择联系人";
        self.groupId = groupId;
        self.selectedUsers = [NSMutableArray new];
        self.sectionTitles = [NSMutableArray new];
        self.filterUsers = [NSMutableArray new];
        self.filterIds = [NSMutableArray new];
        self.userList = [NSMutableArray new];
        for (QTIMGroupUserInfoModel *user in filterUsers) {
            QTIMUserInfoModel *userModel = [QTIMUserInfoModel new];
            userModel.Id = user.Id;
            userModel.name = user.name;
            userModel.avatar = user.avatar;
            if (self.type == QTIMSelectPersonDataSourceUnlessGroupList) {
                userModel.status = 2;
            }
            [self.filterUsers addObject:userModel];
            [self.filterIds addObject:user.Id];
        }
        self.type = type;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFilterUsers:nil type:QTIMSelectPersonDataSourceCreatGroup groupId:nil];
}

/**
 * 如果key为空 获取全部数据
 */
- (RACSignal *)fetchDataWithKey:(NSString *)aKey
{
    switch (self.type) {
        case QTIMSelectPersonDataSourceCreatGroup:
        {
            @weakify(self);
            if (self.userList.count) {
                return [self searchWithKey:aKey];
            }
            else {
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/users/list") param:nil] subscribeNext:^(id  _Nullable x) {
                        @strongify(self);
                        self.model = [QTIMAddressBookModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
                        // 生成排序用的list
                        for (QTIMAddressBookListModel *model in self.model.list) {
                            for (QTIMUserInfoModel *user in model.list) {
                                [self.userList addObject:user];
                            }
                        }
                        [[self searchWithKey:nil] subscribeNext:^(id  _Nullable x) {
                            [subscriber sendNext:self.model];
                        }];
                    } error:^(NSError * _Nullable error) {
                        [subscriber sendError:error];
                    }];
                    return nil;
                }];
            }
        }
            break;
        case QTIMSelectPersonDataSourceGroupList:
        {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                if (!self.userList.count) {
                    [self.userList addObjectsFromArray:self.filterUsers];
                }

                [[self searchWithKey:aKey] subscribeNext:^(id  _Nullable x) {
                    [subscriber sendNext:x];
                }];
                return nil;
            }];
        }
            break;
        case QTIMSelectPersonDataSourceUnlessGroupList:
        {
            @weakify(self);
            if (self.userList.count) {
                return [self searchWithKey:aKey];
            }
            else {
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/users/list") param:nil] subscribeNext:^(id  _Nullable x) {
                        @strongify(self);
                        self.model = [QTIMAddressBookModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
                        for (QTIMAddressBookListModel *model in self.model.list) {
                            if (self.filterIds.count != 0) {
                                for (QTIMUserInfoModel *user in model.list) {
                                    // 传进来的群组成员不可点
                                    if ([self.filterIds containsObject:user.Id]) {
                                        user.status = 2;
                                    }
                                    [self.userList addObject:user];
                                }
                            }
                        }
                        [[self searchWithKey:nil] subscribeNext:^(id  _Nullable x) {
                            [subscriber sendNext:self.model];
                        }];
                    } error:^(NSError * _Nullable error) {
                        [subscriber sendError:error];
                    }];
                    return nil;
                }];
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

- (RACSignal *)addSelectedUser:(QTIMUserInfoModel *)user
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        if (nil == user) {
            [subscriber sendNext:self.selectedUsers];
            return nil;
        }
        if (![self.selectedUsers containsObject:user]) {
            [self.selectedUsers addObject:user];
        }
        [subscriber sendNext:self.selectedUsers];
        return nil;
    }];
}

- (RACSignal *)deleteSelectedUser:(QTIMUserInfoModel *)user
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        if (nil == user) {
            [subscriber sendNext:self.selectedUsers];
            return nil;
        }
        if ([self.selectedUsers containsObject:user]) {
            [self.selectedUsers removeObject:user];
        }
        [subscriber sendNext:self.selectedUsers];
        return nil;
    }];
}

- (RACSignal *)addUsersToGroup
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSMutableArray *ids = [NSMutableArray new];
        for (QTIMUserInfoModel *user in self.selectedUsers) {
            [ids addObject:user.Id];
        }
        [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/join") param:@{@"groupId" : self.groupId, @"ids" : ids}] subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)deleteUsersFromGroup
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSMutableArray *ids = [NSMutableArray new];
        for (QTIMUserInfoModel *user in self.selectedUsers) {
            [ids addObject:user.Id];
        }
        [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/quit") param:@{@"groupId" : self.groupId, @"ids" : ids}] subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)searchWithKey:(NSString *)aKey
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSString *key = [aKey lowercaseString];
        NSMutableArray *datas = [NSMutableArray new];
        if (key.length) {
            for (QTIMUserInfoModel *user in self.userList) {
                // 根据搜索字段获取user 名称、电话号码
                if ([user.name containsString:key] || [user.pinyin containsString:key] || [user.phone containsString:key]) {
                    [datas addObject:user];
                }
            }
        }
        else{
            [datas addObjectsFromArray:self.userList];
        }
        
        // 根据名字的首字母排序 Example : 孙超 = SC
        BMChineseSortSetting.share.logEable = NO;
        BMChineseSortSetting.share.sortMode = 2;
        [BMChineseSort sortAndGroup:datas key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
            self.sectionTitles = sectionTitleArr;
            QTIMAddressBookModel *bookModel = [QTIMAddressBookModel new];
            bookModel.list = [NSMutableArray new];
            NSInteger index = 0;
            NSInteger num = 0;
            for (NSArray *array in sortedObjArr) {
                QTIMAddressBookListModel *listModel  =[QTIMAddressBookListModel new];
                listModel.letter = sectionTitleArr[index];
                listModel.list = [NSMutableArray arrayWithArray:array];
                index++;
                num+=array.count;
                [bookModel.list addObject:listModel];
            }
            // 选择一个群
            if (self.type == QTIMSelectPersonDataSourceCreatGroup) {
                QTIMAddressBookListModel *listModel  =[QTIMAddressBookListModel new];
                [self.sectionTitles insertObject:@" " atIndex:0];
                listModel.letter = @" ";
                listModel.list = [NSMutableArray arrayWithObject:@" "];
                [bookModel.list insertObject:listModel atIndex:0];
            }
            
            bookModel.num = @(num);
            self.model = bookModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:self.model];
            });
        }];
        return nil;
    }];
}

- (RACSignal *)creatGroup
{
    NSMutableArray *ids = [NSMutableArray new];
    for (QTIMUserInfoModel *user in self.selectedUsers) {
        [ids addObject:user.Id];
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/creat") param:@{@"members" : ids}] subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:[[x valueForKey:@"data"] valueForKey:@"groupId"]];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


@end

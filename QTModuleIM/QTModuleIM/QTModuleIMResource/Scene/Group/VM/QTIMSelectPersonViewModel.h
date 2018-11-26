//
//  QTIMSelectPersonViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"
#import "QTIMAddressBookModel.h"
#import "QTIMGroupInfoModel.h"

typedef NS_ENUM(NSInteger, QTIMSelectPersonDataSourceType) {
    QTIMSelectPersonDataSourceCreatGroup = 1,
    QTIMSelectPersonDataSourceGroupList, // 从群组详情页进入  减少群成员
    QTIMSelectPersonDataSourceUnlessGroupList, // 从群组详情页进去，加入新成员
};

@interface QTIMSelectPersonViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) QTIMAddressBookModel *model;
@property (nonatomic, strong, readonly) NSMutableArray *selectedUsers;
@property (nonatomic, strong, readonly) NSMutableArray *sectionTitles;

/**
 * 进入这个页面已经选择的users
 */
@property (nonatomic, strong, readonly) NSMutableArray *filterUsers;

@property (nonatomic, assign, readonly) QTIMSelectPersonDataSourceType type;

/**
 * QTIMSelectPersonDataSourceCreatGroup
 */
- (instancetype)init;

- (instancetype)initWithFilterUsers:(NSArray <QTIMGroupUserInfoModel *> *)filterUsers type:(QTIMSelectPersonDataSourceType)type groupId:(NSString *)groupId;

/**
 * 如果key为空 获取全部数据
 */
- (RACSignal *)fetchDataWithKey:(NSString *)aKey;

/**
 * 添加user到users
 */
- (RACSignal *)addSelectedUser:(QTIMUserInfoModel *)user;

/**
 * 在选择的users中删除user
 */
- (RACSignal *)deleteSelectedUser:(QTIMUserInfoModel *)user;

/**
 * 添加user到群组中
 */
- (RACSignal *)addUsersToGroup;

/**
 * 从群组中移除user
 */
- (RACSignal *)deleteUsersFromGroup;

/**
 * 创建群组
 */
- (RACSignal *)creatGroup;

@end

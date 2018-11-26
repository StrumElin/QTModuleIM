//
//  QTIMBridgeManager.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/23.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "QTIMBridgeManager.h"

#import "QTIMConversationController.h"
#import "QTIMConversationListController.h"

#import "QTIMDataSourceManager.h"
#import "QTIMMacros.h"
#import <RongContactCard/RongContactCard.h>
#import <RongContactCard/RongContactCard.h>

@interface QTIMBridgeManager () <RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>
@property (nonatomic, strong) QTIMConversationListController *convListVc;
@property (nonatomic, strong) UIViewController *convListParentVc;
@end

@implementation QTIMBridgeManager
+ (instancetype)defaultManager
{
    static QTIMBridgeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedInActiveNoti:) name:QTIMAppInActiveReceivedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedActiveNoti:)
                                                     name:QTIMAppActiveReceivedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willResign)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Public
- (void)initWithAppKey:(NSString *)aKey
{
    if (aKey.length == 0) {
        return;
    }
    [[RCIM sharedRCIM] initWithAppKey:aKey];
    
    [[RCIM sharedRCIM] registerMessageType:[RCContactCardMessage class]];
    [self registerMessageClass];
}

- (void)registerMessageClass {
   
}

- (void)connectRongServerWithUserInfo:(NSDictionary *)userInfo completion:(Completion)completion
{
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo valueForKey:@"phone"] forKey:QTIMUserDefaultsUserPhoneKey];
    BOOL flag = [userInfo objectForKey:@"imtoken"] == nil ||
    [userInfo objectForKey:@"id"] == nil ||
    [userInfo objectForKey:@"name"] == nil ||
    [userInfo objectForKey:@"avatar"] == nil;
    if (flag) {
        completion(NO, 0000);
        return;
    }
    [[RCIM sharedRCIM] logout];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    
    [[RCIM sharedRCIM] connectWithToken:[userInfo objectForKey:@"imtoken"] success:^(NSString *userId) {
        
        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        [[RCIM sharedRCIM] setUserInfoDataSource:[QTIMDataSourceManager defaultManager]];
        [[RCIM sharedRCIM] setGroupInfoDataSource:[QTIMDataSourceManager defaultManager]];
//        [RCContactCardKit shareInstance].contactsDataSource = [QTIMDataSourceManager defaultManager];
//        [RCContactCardKit shareInstance].groupDataSource = [QTIMDataSourceManager defaultManager];
//        [[RCIM sharedRCIM] setGroupUserInfoDataSource:[QTIMDataSourceManager defaultManager]];
//        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
        [[RCIM sharedRCIM] setEnableMessageAttachUserInfo:YES];
        
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:[[userInfo objectForKey:@"id"] stringValue]
                                                         name:[userInfo objectForKey:@"name"]
                                                     portrait:[userInfo objectForKey:@"avatar"]];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        [RCIM sharedRCIM].currentUserInfo = user;
        
        if (completion) {
            completion(YES,0);
        }
    } error:^(RCConnectErrorCode status) {
        if (completion) {
            completion(NO, status);
        }
        QTERRORLog(@"connect error RCConnectErrorCode = %ld",(long)status);
    } tokenIncorrect:^{
        if (completion) {
            completion(NO, 0000);
        }
        QTERRORLog(@"token 不正确");
    }];
}

- (RCConnectionStatus)connectStatus
{
    return [[RCIM sharedRCIM] getConnectionStatus];
}

- (void)disconnect:(BOOL)isReceivePush
{
    [[RCIM sharedRCIM] disconnect:isReceivePush];
}

- (void)logout
{
    [self disconnect:NO];
}

//- (void)refreshFriendListWithUserInfo:(RCUserInfo *)userInfo
//{
//    if (nil == userInfo.userId) {
//        return;
//    }
//    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
//    void (^completion)(RCUserInfo *rcUserInfo) = _getUserInfoBlocks[userInfo.userId];
//    if (completion) {
//        completion(userInfo);
//        [_getUserInfoBlocks removeObjectForKey:userInfo.userId];
//    }
//}
//
//- (NSArray *)getConsJsonsWithConvType:(RCConversationType)aType
//{
//    NSArray *conversations = [[RCIMClient sharedRCIMClient] getConversationList:@[@(aType)]];
//    NSMutableArray *jsonStrings = [NSMutableArray new];
//    for (RCConversation *conversation in conversations) {
//        NSDictionary *info = [self dictionaryWithConversation:conversation];
//        [jsonStrings addObject:info];
//    }
//    return jsonStrings;
//}
//
//- (NSDictionary *)getConvJsonWithTargetId:(NSString *)targetId convType:(RCConversationType)aType
//{
//    if (nil == targetId) {
//        return nil;
//    }
//    RCConversation *conversation = [[RCIMClient sharedRCIMClient] getConversation:aType targetId:targetId];
//    return [self dictionaryWithConversation:conversation];
//}

- (NSInteger)getAllUnReadMessageCount
{
    return [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
}

- (NSInteger)getUnReadMessageCountWithConvType:(RCConversationType)aType
{
    return [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(aType)]];
}

//- (BOOL)removeConversationWithTargetId:(NSString *)targetId convType:(RCConversationType)aType
//{
//    if (nil == targetId) {
//        return NO;
//    }
//    BOOL flag = [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:targetId];
//    if (flag) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:QTIMBridgeDeleteConversationDidFinishedNotification object:nil];
//    }
//    return flag;
//}
//
//- (void)clearConversationWithTargetId:(NSString *)targetId convType:(RCConversationType)aType completion:(void (^)(BOOL, RCErrorCode))completion
//{
//    //MARK:Test
//    BOOL flag = [[RCIMClient sharedRCIMClient] removeConversation:aType targetId:targetId];
//    if (!flag) {
//        completion(NO,0000);
//        return;
//    }
//    [[RCIMClient sharedRCIMClient] deleteMessages:aType targetId:targetId success:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:QTIMBridgeDeleteConversationDidFinishedNotification object:nil];
//        if (completion) {
//            completion(YES,0);
//        }
//    } error:^(RCErrorCode status) {
//        if (completion) {
//            completion(NO,status);
//        }
//    }];
//}
//
//- (BOOL)setConversationToTopWithTargetId:(NSString *)targetId convType:(RCConversationType)aType isTop:(BOOL)isTop
//{
//    return [[RCIMClient sharedRCIMClient] setConversationToTop:aType targetId:targetId isTop:isTop];
//}
//
//- (void)setConversationNotiStatusWithTargetId:(NSString *)targeId convType:(RCConversationType)aType isBlocked:(BOOL)isBlocked completion:(void (^)(BOOL, RCErrorCode))completion
//{
//    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:aType targetId:targeId isBlocked:isBlocked success:^(RCConversationNotificationStatus nStatus) {
//        if (completion) {
//            completion(YES, 0);
//        }
//    } error:^(RCErrorCode status) {
//        if (completion) {
//            completion(NO,status);
//        }
//    }];
//}
//
//- (void)setNotificationQuietWithCompletion:(void(^)(BOOL isSucc, RCErrorCode code))completion
//{
//    [[RCIMClient sharedRCIMClient] setNotificationQuietHours:@"00:00:00" spanMins:1439 success:^{
//        if (completion) {
//            completion(YES,0);
//        }
//    } error:^(RCErrorCode status) {
//        if (completion) {
//            completion(NO,status);
//        }
//    }];
//}
//
//- (void)removeNotificationQuietWithCompletion:(void(^)(BOOL isSucc, RCErrorCode code))completion
//{
//    [[RCIMClient sharedRCIMClient] removeNotificationQuietHours:^{
//        if (completion) {
//            completion(YES,0);
//        }
//    } error:^(RCErrorCode status) {
//        if (completion) {
//            completion(NO,status);
//        }
//    }];
//}
//
//- (void)presentConversationListWithViewController:(UIViewController *)aViewController
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        QTIMConversationListController *vc = [QTIMConversationListController new];
////        vc.view.frame = CGRectMake(0, 44, aViewController.view.bounds.size.width, aViewController.view.bounds.size.height - 44 - 64);
////        [aViewController addChildViewController:vc];
////        [aViewController.view addSubview:vc.view];
////        [vc didMoveToParentViewController:aViewController];
////        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
////        [aViewController presentViewController:nc animated:YES completion:nil];
//        [aViewController.navigationController pushViewController:vc animated:YES];
//    });
//}
//
//- (void)presentConversationWithTargetId:(NSString *)targetId title:(NSString *)title convType:(RCConversationType)aType viewController:(UIViewController *)aViewController
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:aType targetId:targetId title:title ? title : [[RCIM sharedRCIM] getUserInfoCache:targetId].name];
//        QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
////        QTIMConversationController *vc = [[QTIMConversationController alloc] initWithConversationType:aType targetId:targetId];
////        vc.title = title ? title : [[RCIM sharedRCIM] getUserInfoCache:targetId].name;
////        vc.isPresent = YES;
//        self.currentPresentVc = vc;
////        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
////        [aViewController presentViewController:nc animated:YES completion:nil];
//        [aViewController.navigationController pushViewController:vc animated:YES];
//    });
//}
//
//- (void)pushConversationWithTargetId:(NSString *)targetId title:(NSString *)title navigationController:(UINavigationController *)aNavigationController
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
////        QTIMConversationController *vc = [[QTIMConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:targetId];
////        vc.title = title ? title : [[RCIM sharedRCIM] getUserInfoCache:targetId].name;
//        QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:ConversationType_PRIVATE targetId:targetId title:title ? title : [[RCIM sharedRCIM] getUserInfoCache:targetId].name];
//        QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
//        [aNavigationController pushViewController:vc animated:YES];
//    });
//}

- (void)showConvListInViewController:(UIViewController *)aViewController insetTop:(CGFloat)aTop insetBottom:(CGFloat)aBottom
{
    if (nil == aViewController) {
        return;
    }
    _convListParentVc = aViewController;
    
    UINavigationController *nc;
    if(!self.convListVc){
        QTIMConvListViewModel *viewModel = [QTIMConvListViewModel new];
        self.convListVc = [[QTIMConversationListController alloc] initWithViewModel:viewModel];
        nc = [[UINavigationController alloc] initWithRootViewController:self.convListVc];
        nc.view.frame = CGRectMake(0, aTop, aViewController.view.bounds.size.width, aViewController.view.bounds.size.height - aTop - aBottom);
//        [aViewController.view addSubview:self.convListVc.view];
//        [aViewController addChildViewController:self.convListVc ];
//        [self.convListVc didMoveToParentViewController:aViewController];
//        self.convListVc.view.hidden = NO;
    }
    
    [aViewController.view addSubview:nc.view];
    [aViewController addChildViewController:nc ];
    [nc didMoveToParentViewController:aViewController];
    
//    self.convListVc.view.hidden = NO;
    /*
    NSArray *arr =  aViewController.childViewControllers;
    for (UIViewController *vcc in arr) {
        if([vcc isKindOfClass:[QTIMConversationListController class]]){
            NSLog(@"showConvList");
            self.convListVc.view.hidden = NO;
        }
    }
     */
    
}

- (void)hideConvList
{
    if (nil == _convListParentVc || nil == self.convListVc ) {
        return;
    }
    
    /*
    NSArray *arr =  _convListParentVc.childViewControllers;
    for (UIViewController *vcc in arr) {
        if([vcc isKindOfClass:[QTIMConversationListController class]]){
            NSLog(@"hideConvList");
            self.convListVc.view.hidden = YES;
        }
    }
     */
//       self.convListVc.view.hidden = YES;
    
    [self.convListVc.view removeFromSuperview];
    [self.convListVc willMoveToParentViewController:nil];
    [self.convListVc removeFromParentViewController];
     
    
    //_convListVc = nil;
    //_convListParentVc = nil;
}

#pragma mark - RCConnectionStatusChangeDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    QTINFOLog(@"状态连接改变 %ld",status);
    if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunconnectStatus:)]) {
        [self.delegate rongyunconnectStatus:@(status).stringValue];
    }
}

#pragma mark - RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    /**
     * 收到新消息之后传给cordova
     */
    if ([message.content isKindOfClass:[RCGroupNotificationMessage class]]) {
        RCGroupNotificationMessage *group = (RCGroupNotificationMessage *)message.content;
        QTINFOLog(@"%@ - %@",message.objectName,group.operation);
    }
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunReceiveMessageWithConvJson:)]) {
//        RCConversation *conversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
//        NSDictionary *convDic = [self dictionaryWithConversation:conversation];
//        [self.delegate rongyunReceiveMessageWithConvJson:convDic];
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                                 @(ConversationType_PRIVATE), @(ConversationType_SYSTEM),
                                                                                 @(ConversationType_GROUP)
                                                                                 ]];
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        }
    });
}

#pragma mark - RCIMUserInfoDataSource
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
//{
//    if (nil == userId) {
//        QTERRORLog(@"userId is nil");
//        return;
//    }
//    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//        completion([RCIM sharedRCIM].currentUserInfo);
//    }
//    else {
//        RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:userId];
//        if (nil == user) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunGetUserInfoWithUserid:)]) {
//                [_getUserInfoBlocks setObject:completion forKey:userId];
//                [self.delegate rongyunGetUserInfoWithUserid:userId];
//            }
//        }
//        else {
//            completion(user);
//        }
//    }
//}

#pragma mark -  Privite
- (NSDictionary *)dictionaryWithConversation:(RCConversation *)conversation
{
    RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
    // 当前若在聊天页面内，web的会话List就不会收到当前聊天的未读消息数
//    BOOL flag = _currentPresentVc.targetId && [_currentPresentVc.targetId isEqualToString:conversation.targetId];
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    info[@"id"] = user ? user.userId : conversation.targetId;
    info[@"name"] = user.name;
    info[@"avatar"] = user.portraitUri;
    info[@"unreadMessageCount"] = @(conversation.unreadMessageCount).stringValue;
    info[@"receivedTime"] = @(conversation.receivedTime).stringValue;
    info[@"lastestMessage"] = [conversation.lastestMessage conversationDigest];
    info[@"draft"] = conversation.draft;
    info[@"convType"] = @(conversation.conversationType);
    return info;
}

//- (void)removeConv:(NSNotification *)noti
//{
//    NSDictionary *userInfo = noti.userInfo;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunRemoveConvWithTargetId:convType:)]) {
//        [self.delegate rongyunRemoveConvWithTargetId:[userInfo objectForKey:@"targetId"] convType:[[userInfo objectForKey:@"convType"] integerValue]];
//    }
//}

- (void)receivedInActiveNoti:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    if (nil == userInfo) {
        QTINFOLog(@"nil == useriNFO");
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunReceivedAppInActiveNotificationWithUserInfo:)]) {
        [self.delegate rongyunReceivedAppInActiveNotificationWithUserInfo:userInfo];
    }
}

- (void)receivedActiveNoti:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    if (nil == userInfo) {
        QTINFOLog(@"nil == useriNFO");
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunReceivedAppActiveNotificationWithUserInfo:)]) {
        [self.delegate rongyunReceivedAppActiveNotificationWithUserInfo:userInfo];
    }
}

- (void)willResign
{
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE), @(ConversationType_SYSTEM),@(ConversationType_GROUP)
                                                                         ]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
}

////FIXME: 创建一个假数据
//- (void)creatMineData
//{
//    NSDictionary *mine = @{
//                           @"userId" : @"18855525251",
//                           @"name" : @"shaobinbin",
//                           @"avatar" : @"http://q.qlogo.cn/headimg_dl?bs=qq&dst_uin=130831003&fid=blog&spec=100",
//                           @"imtoken" : @"CS3uJoCZ/a7BP/IBBphx9DvQGSdu7b8TfrCV/Ox6si50LVBwEKpL7ZD4ZFr36XTCd2tsMpjyBrUyKzq6mxxy/JjFnkcgp+QH",
//                           };
//    [[NSUserDefaults standardUserDefaults] setObject:mine forKey:QTIMUserDefaultsUserInfoKey];
//}

//- (NSArray *)getUnReadMessageWithTargetId:(NSString *)targetId row:(int)row
//{
//    RCMessage *message = [[RCIMClient sharedRCIMClient] getFirstUnreadMessage:ConversationType_PRIVATE targetId:targetId];
//    if (row == 0) {
//        // 获取全部
//        NSMutableArray *unReadMsgs = [NSMutableArray new];
//        unReadMsgs = [self getAllUnReadMsg:message.messageId targetId:targetId container:unReadMsgs];
//        [unReadMsgs insertObject:message atIndex:0];
//    }
//    else {
//        // 获取指定数量
//        NSArray *msgs = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:targetId count:row];
//        NSMutableArray *unReadMsgs = [NSMutableArray new];
//        for (RCMessage *message in msgs) {
//            if (message.receivedStatus == ReceivedStatus_READ) {
//                return unReadMsgs;
//            }
//            [unReadMsgs addObject:message];
//        }
//        return unReadMsgs;
//    }
//    return nil;
//}

//- (NSMutableArray *)getAllUnReadMsg:(long)msgId targetId:(NSString *)targetId container:(NSMutableArray *)container
//{
//    NSArray *msgs = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:targetId objectName:nil baseMessageId:msgId isForward:YES count:20];
//    RCMessage *lasMsg;
//    for (RCMessage *message in msgs) {
//        if (message.receivedStatus == ReceivedStatus_READ) {
//            return container;
//        }
//        lasMsg = message;
//        [container addObject:message];
//    }
//    msgId = lasMsg.messageId;
//    return [self getAllUnReadMsg:msgId targetId:targetId container:container];
//}
//
//- (NSMutableArray *)getUnreadMsg:(long)msgId targetId:(NSString *)targetId count:(int)count container:(NSMutableArray *)container
//{
//    NSArray *datas = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:targetId count:count];
//    for (RCMessage *message in datas) {
//        [container addObject:message];
//        if (message.receivedStatus == ReceivedStatus_READ) {
//            return container;
//        }
//    }
//    return container;
//}

///**
// * 获取指定会话的历史记录
// */
//- (NSArray *)getHistoryMessageWithTargetId:(NSString *)targetId lastMessageId:(long)lastMessageId row:(int)row
//{
//    return [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:targetId oldestMessageId:lastMessageId count:row];
//}
//
///**
// * 清除指定会话的未读状态，不传默认清除所有
// */
//- (void)clearMessageStatusWithTargetId:(NSString *)targetId
//{
//    if (nil == targetId) {
//        for (RCConversation *conversation in [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]]) {
//            [self clearSpecifiedConvUnReadStatusWithTargetId:conversation.targetId];
//        }
//    }
//    else {
//        [self clearSpecifiedConvUnReadStatusWithTargetId:targetId];
//    }
//}
//
//- (void)clearSpecifiedConvUnReadStatusWithTargetId:(NSString *)targetId
//{
//    long long lastReceiveTime = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:targetId].receivedTime;
//clearMessagesUnreadStatus
//}


@end

@implementation QTIMBridgeManager (Privite)
//- (void)setPresentVcNil
//{
//    if (_currentPresentVc) {
//        _currentPresentVc = nil;
//    }
//}

- (void)updateUnReadMsgCount
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rongyunUpdateUnReadMsgCount:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger count = [self getAllUnReadMessageCount];
            [self.delegate rongyunUpdateUnReadMsgCount:count];
        });
    }
}
@end

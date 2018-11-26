//
//  QTIMBridgeManager.h
//  RIMDemo
//
//  Created by 未可知 on 2018/10/23.
//  Copyright © 2018年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RongIMKit/RongIMKit.h>

#define BridgeManager [QTIMBridgeManager defaultManager]

typedef void(^Completion)(BOOL isSucc, RCConnectErrorCode code);

@protocol QTIMBridgeDelegate;
@interface QTIMBridgeManager : NSObject

@property (nonatomic, weak) id<QTIMBridgeDelegate> delegate;

+ (instancetype)defaultManager;

/**
 * 初始化
 */
- (void)initWithAppKey:(NSString *)aKey;

/**
 * 连接融云   completion : code == 0 成功 ; code == 0000; token 有误
 */
- (void)connectRongServerWithUserInfo:(NSDictionary *)userInfo completion:(Completion)completion;

/**
 * 获取连接状态
 */
- (RCConnectionStatus)connectStatus;

/**
 *  断开连接
 *  isReceivePush 是否接受通知消息
 */
- (void)disconnect:(BOOL)isReceivePush;

/**
 *  退出登录 不接收推送
 */
- (void)logout;

/**
 * 获取到指定的用户信息的回调
 */
//- (void)refreshFriendListWithUserInfo:(RCUserInfo *)userInfo;

/**
 * 获取指定类型的全部的会话字典, 现支持 System、Privite
 * ParamKey :  userId name avatar unreadMessageCount receivedTime lastestMessage draft
 */
//- (NSArray *)getConsJsonsWithConvType:(RCConversationType)aType;

/**
 * 获取指定 会话的字典数据
 */
//- (NSDictionary *)getConvJsonWithTargetId:(NSString *)targetId convType:(RCConversationType)aType;

/**
 * 获取全部未读会话的数量
 */
- (NSInteger)getAllUnReadMessageCount;

/**
 * 获取指定类型的未读消息数
 */
- (NSInteger)getUnReadMessageCountWithConvType:(RCConversationType)aType;

/**
 * 删除指定会话，但是不会删除会话中的信息
 */
//- (BOOL)removeConversationWithTargetId:(NSString *)targetId convType:(RCConversationType)aType;

/**
 * 删除指定会话，同时删除会话中的消息
 */
//- (void)clearConversationWithTargetId:(NSString *)targetId convType:(RCConversationType)aType completion:(void(^)(BOOL isSucc, RCErrorCode code))completion;

/**
 * 设置某一会话置顶
 */
//- (BOOL)setConversationToTopWithTargetId:(NSString *)targetId convType:(RCConversationType)aType isTop:(BOOL)isTop;

/**
 * 设置全局消息免打扰
 */
//- (void)setNotificationQuietWithCompletion:(void(^)(BOOL isSucc, RCErrorCode code))completion;

/**
 * 移除全局消息免打扰
 */
//- (void)removeNotificationQuietWithCompletion:(void(^)(BOOL isSucc, RCErrorCode code))completion;

/**
 * 设置指定会话通知开关。isBlocked : 是否屏蔽消息包括通知 code == 0 表示成功
 */
//- (void)setConversationNotiStatusWithTargetId:(NSString *)targeId convType:(RCConversationType)aType isBlocked:(BOOL)isBlocked completion:(void(^)(BOOL isSucc, RCErrorCode code))completion;

/**
 *  present 会话列表
 */
//- (void)presentConversationListWithViewController:(UIViewController *)aViewController;

/**
 * present 单聊页面 ，当会话是当前用户第一次发起时，缓存中没有数据，取不到title（title可以为空，此时会从缓存中取）
 */
//- (void)presentConversationWithTargetId:(NSString *)targetId title:(NSString *)title convType:(RCConversationType)aType viewController:(UIViewController *)aViewController;

/**
 * push
 */
//- (void)pushConversationWithTargetId:(NSString *)targetId title:(NSString *)title navigationController:(UINavigationController *)aNavigationController;

- (void)showConvListInViewController:(UIViewController *)aViewController insetTop:(CGFloat)aTop insetBottom:(CGFloat)aBottom;

- (void)hideConvList;

@end

@interface QTIMBridgeManager (Privite)
//- (void)setPresentVcNil;
- (void)updateUnReadMsgCount;
@end

@protocol QTIMBridgeDelegate <NSObject>

//- (void)rongyunGetUserInfoWithUserid:(NSString *)userId;

- (void)rongyunconnectStatus:(NSString *)status;

//- (void)rongyunReceiveMessageWithConvJson:(NSDictionary *)convJson;

//- (void)rongyunRemoveConvWithTargetId:(NSString *)targetId convType:(RCConversationType)aType;

- (void)rongyunReceivedAppInActiveNotificationWithUserInfo:(NSDictionary *)userInfo;
/**
 * 返回的数据格式
 {
 　　"aps" :
         {
         "alert" : "You got your emails.",
         "badge" : 1,
         "sound" : "default"
         },
         "rc":{"cType":"PR","fId":"xxx","oName":"xxx","tId":"xxxx"},
         "appData":"xxxx"
 }
 https://www.rongcloud.cn/docs/ios_push.html#push_json
 */
- (void)rongyunReceivedAppActiveNotificationWithUserInfo:(NSDictionary *)userInfo;

- (void)rongyunUpdateUnReadMsgCount:(NSInteger)count;

- (void)rongyunDidClickCompanyNotice;

- (void)rongyunDidClickSystemNotice;

@end


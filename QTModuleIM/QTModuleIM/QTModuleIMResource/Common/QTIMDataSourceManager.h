//
//  QTIMDataSourceManager.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <RongContactCard/RongContactCard.h>

@interface QTIMDataSourceManager : NSObject  <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupUserInfoDataSource, RCCCContactsDataSource, RCCCGroupDataSource>

+ (instancetype)defaultManager;

//- (void)clearConvWithConvType:(RCConversationType)aType targetId:(NSString *)targetId completion:(void(^)(BOOL isSucc, RCErrorCode code))completion;

@end

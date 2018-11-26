//
//  QTIMConvDetailViewModel.h
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import "QTIMBaseViewModel.h"

#import "QTIMGroupInfoModel.h"

#import <RongIMLib/RongIMLib.h>

@interface QTIMConvDetailViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) QTIMGroupInfoModel *groupInfo;
@property (nonatomic, assign, readonly) RCConversationType type;
@property (nonatomic, strong, readonly) NSString *targetId;
@property (nonatomic, strong, readonly) NSString *title;

- (instancetype)initWithConvType:(RCConversationType)aType targetId:(NSString *)aId title:(NSString *)title;

- (RACSignal *)fetchGroupInfo;
@end

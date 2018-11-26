//
//  QTIMConversationController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/10/18.
//  Copyright © 2018年 QT. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#import "QTIMControlerAdaptor.h"
#import "QTIMConvDetailViewModel.h"

@interface QTIMConversationController : RCConversationViewController <QTIMControlerAdaptor>

@property (nonatomic, strong, readonly) QTIMConvDetailViewModel *viewModel;

- (instancetype)initWithConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId NS_UNAVAILABLE;

@end


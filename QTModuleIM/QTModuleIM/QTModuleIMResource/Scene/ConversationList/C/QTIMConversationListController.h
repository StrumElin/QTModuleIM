//
//  QTIMConversationListController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/10/18.
//  Copyright © 2018年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

#import "QTIMConvListViewModel.h"
#import "QTIMControlerAdaptor.h"

@interface QTIMConversationListController : RCConversationListViewController <QTIMControlerAdaptor>

@property (nonatomic, strong, readonly) QTIMConvListViewModel *viewModel;

@end


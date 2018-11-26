//
//  QTIMConvListViewModel.h
//  七天汇
//
//  Created by 未可知 on 2018/11/15.
//

#import "QTIMBaseViewModel.h"

#import "ReactiveObjC.h"
#import <RongIMLib/RongIMLib.h>

@interface QTIMConvListViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger companyUnreadNums;
@property (nonatomic, assign, readonly) NSInteger systemNoticeUnreadNums;
@property (nonatomic, strong, readonly) NSArray *displayConversationType;
@property (nonatomic, strong, readonly) NSMutableArray *headerDataSource;

@end

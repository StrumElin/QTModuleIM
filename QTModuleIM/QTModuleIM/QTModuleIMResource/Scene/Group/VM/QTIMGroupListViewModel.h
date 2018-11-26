//
//  QTIMGroupListViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/24.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"
#import "QTIMGroupShortInfoModel.h"

@interface QTIMGroupListViewModel : QTIMBaseViewModel
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSArray *dataSource;
/**
 * 获取群组数据
 */
- (RACSignal *)fetchGroupData;
@end

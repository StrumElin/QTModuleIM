//
//  QTIMGroupMemeberListViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"
#import "QTIMGroupInfoModel.h"

@interface QTIMGroupMemeberListViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSArray *dataSource;

- (instancetype)initWithDataSource:(NSArray *)dataSource;

@end

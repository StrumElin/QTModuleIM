//
//  QTIMGroupInfoViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"
#import "QTIMGroupInfoModel.h"

#define MaxLine 4
#define LineItemCount 5
#define DisplayMaxCount (MaxLine * LineItemCount)

@interface QTIMGroupInfoViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *groupId;
@property (nonatomic, assign, readonly) CGFloat headerHeight;
@property (nonatomic, strong, readonly) QTIMGroupInfoModel *model;
@property (nonatomic, strong, readonly) NSArray <NSString*> *userIds;
@property (nonatomic, strong, readonly) NSArray *listDatas;

- (instancetype)initWithId:(NSString *)aId;

//- (instancetype)initWithGroupInfo:(QTIMGroupInfoModel *)groupInfo;

- (RACSignal *)fetchGroupInfo;

- (RACSignal *)fetchGroupPageListData;

- (RACSignal *)quitGroup;

/**
 * 当前的model里面包含用于显示plus以及minus的假数据，这个方法会把当前的model里的这两条假数据清除
 */
- (RACSignal *)constructSelectPageDataIsPlus:(BOOL)isPlus;

@end

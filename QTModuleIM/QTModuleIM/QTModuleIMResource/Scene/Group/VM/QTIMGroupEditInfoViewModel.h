//
//  QTIMGroupEditInfoViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"

@interface QTIMGroupEditInfoViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *name;

- (instancetype)initWithGroupId:(NSString *)groupId name:(NSString *)name;

- (RACSignal *)updateGroupInfoWithName:(NSString *)name;

@end

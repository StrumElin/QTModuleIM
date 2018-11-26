//
//  QTIMAddressBookSearchResultViewModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/23.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseViewModel.h"

#import "QTIMAddressBookModel.h"
#import "QTIMGroupShortInfoModel.h"
#import "QTIMAddressBookViewModel.h"

@interface QTIMAddressBookSearchResultViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) QTIMAddressBookModel *model;
@property (nonatomic, strong, readonly) NSMutableArray *sectionTitles;
@property (nonatomic, strong, readonly) NSArray *tableRightSectionTitles;

- (instancetype)initWithViewModel:(QTIMAddressBookViewModel *)viewModel;

/**
 * aKey 为空返回全部的数据
 */
- (RACSignal *)fetchDataWithKey:(NSString *)aKey;


@end

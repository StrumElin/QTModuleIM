//
//  QTIMAddressBookViewModel.h
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import "QTIMBaseViewModel.h"

#import "QTIMAddressBookModel.h"
#import "QTIMGroupShortInfoModel.h"

@interface QTIMAddressBookViewModel : QTIMBaseViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) QTIMAddressBookModel *model;
@property (nonatomic, strong, readonly) NSMutableArray *sectionTitles;
@property (nonatomic, assign, readonly) BOOL isContactCard;
@property (nonatomic, strong, readonly) NSArray *groupDatas;

- (instancetype)initWithIsContactCard:(BOOL)isContactCard;

/**
 * 获取用户好友以及用户群组的数据
 */
- (RACSignal *)fetchAddressBookData;

@end

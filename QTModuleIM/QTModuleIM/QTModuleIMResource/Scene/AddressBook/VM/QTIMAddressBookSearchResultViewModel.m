//
//  QTIMAddressBookSearchResultViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/23.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMAddressBookSearchResultViewModel.h"

#import "BMChineseSort.h"

@interface QTIMAddressBookSearchResultViewModel ()
@property (nonatomic, strong) QTIMAddressBookModel *model;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
//@property (nonatomic, strong) NSArray *tableRightSectionTitles;

@property (nonatomic, strong) NSArray *groupDatas;
@property (nonatomic, strong) NSMutableArray *userDatas;
@end

@implementation QTIMAddressBookSearchResultViewModel
- (instancetype)initWithViewModel:(QTIMAddressBookViewModel *)viewModel
{
    if (self = [super init]) {
        self.userDatas = [NSMutableArray new];
        if (viewModel.groupDatas.count) {
            QTIMAddressBookListModel *listModel = viewModel.model.list[0];
            self.groupDatas = [NSMutableArray arrayWithArray:listModel.list];
            for (QTIMAddressBookListModel *model in viewModel.model.list) {
                if ([model.letter isEqualToString:@"#"]) {
                    continue;
                }
                for (QTIMUserInfoModel *user in model.list) {
                    [self.userDatas addObject:user];
                }
            }
        }
        else {
            for (QTIMAddressBookListModel *model in viewModel.model.list) {
                for (QTIMUserInfoModel *user in model.list) {
                    [self.userDatas addObject:user];
                }
            }
        }
    }
    return self;
}

- (RACSignal *)fetchDataWithKey:(NSString *)aKey
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       @strongify(self);
        NSString *key = [aKey lowercaseString];
        NSMutableArray *searchGroupResults = [NSMutableArray new];
        NSMutableArray *searchUserResults = [NSMutableArray new];
        if (key.length) {
            for (QTIMGroupShortInfoModel *group in self.groupDatas) {
                if ([[group.name lowercaseString] containsString:[key lowercaseString]]) {
                    [searchGroupResults addObject:group];
                }
            }
            for (QTIMUserInfoModel *user in self.userDatas) {
                if ([[user.name lowercaseString] containsString:key] || [user.phone containsString:key])  {
                    [searchUserResults addObject:user];
                }
            }
        }
        else {
            if (self.groupDatas.count) {
                [searchGroupResults addObjectsFromArray:self.groupDatas];
            }
            [searchUserResults addObjectsFromArray:self.userDatas];
        }

        BMChineseSortSetting.share.logEable = NO;
        BMChineseSortSetting.share.sortMode = 2;
        [BMChineseSort sortAndGroup:searchUserResults key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
            if (searchGroupResults.count) {
                [sectionTitleArr insertObject:@"#" atIndex:0];
            }
            self.sectionTitles = sectionTitleArr;
            QTIMAddressBookModel *bookModel = [QTIMAddressBookModel new];
            bookModel.list = [NSMutableArray new];
            NSInteger index = 0;
            NSInteger num = 0;
            for (NSArray *array in sortedObjArr) {
                QTIMAddressBookListModel *listModel  =[QTIMAddressBookListModel new];
                listModel.letter = sectionTitleArr[index];
                listModel.list = [NSMutableArray arrayWithArray:array];
                index++;
                num+=array.count;
                [bookModel.list addObject:listModel];
            }
            if (searchGroupResults.count) {
                QTIMAddressBookListModel *listModel  =[QTIMAddressBookListModel new];
                listModel.letter = @"#";
                listModel.list = [NSMutableArray arrayWithArray:searchGroupResults];
                num+=searchGroupResults.count;
                [bookModel.list insertObject:listModel atIndex:0];
            }
            bookModel.num = @(num);
            self.model = bookModel;
            [subscriber sendNext:self.model];
        }];
        return nil;
    }];
}

@end

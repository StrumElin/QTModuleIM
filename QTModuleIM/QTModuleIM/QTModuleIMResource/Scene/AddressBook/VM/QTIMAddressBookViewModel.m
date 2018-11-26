
//
//  QTIMAddressBookViewModel.m
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import "QTIMAddressBookViewModel.h"
#import "SeptnetHttp.h"
#import "QTIMMacros.h"
//#import "YYModel.h"

@interface QTIMAddressBookViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) QTIMAddressBookModel *model;
@property (nonatomic, strong) NSMutableArray *sectionTitles;

@property (nonatomic, strong) RACSignal *dataFetchSignal;
@property (nonatomic, assign) BOOL isContactCard;
@property (nonatomic, strong) NSArray *groupDatas;
@end

@implementation QTIMAddressBookViewModel
- (instancetype)init
{
    return [self initWithIsContactCard:NO];
}

- (instancetype)initWithIsContactCard:(BOOL)isContactCard
{
    if (self = [super init]) {
        self.title = @"通讯录";
        self.isContactCard = isContactCard;
        self.dataFetchSignal = [RACSubject subject];
        self.sectionTitles = [NSMutableArray new];
    }
    return self;
}

- (RACSignal *)fetchAddressBookData
{
    if (self.isContactCard) {
        return [[self fetchFriendListData] map:^id _Nullable(id  _Nullable value) {
            for (QTIMAddressBookListModel *model in self.model.list) {
                [self.sectionTitles addObject:model.letter];
            }
            return self.model;
        }];
    }
    else {
        RACSignal *friendSignal = [self fetchFriendListData];
        RACSignal *groupSignal = [self fetchGroupData];
        [self rac_liftSelector:@selector(constructFriendAndGroupData:group:) withSignals:friendSignal,groupSignal, nil];
        return _dataFetchSignal;
    }
}

- (void)constructFriendAndGroupData:(QTIMAddressBookModel *)friend group:(NSArray *)group
{
    if ([friend isKindOfClass:[NSError class]]) {
        [(RACSubject *)_dataFetchSignal sendError:(NSError *)friend];
        return;
    }
    if ([group isKindOfClass:[NSError class]]) {
        [(RACSubject *)_dataFetchSignal sendError:(NSError *)group];
        return;
    }
    
    if (group.count) {
        QTIMAddressBookListModel *listModel = [QTIMAddressBookListModel new];
        listModel.letter = @"#";
        listModel.list = [NSMutableArray new];
        [listModel.list addObjectsFromArray:group];
        
        [self.model.list insertObject:listModel atIndex:0];
        self.model.num = @(self.model.num.integerValue + listModel.list.count);
    }
    for (QTIMAddressBookListModel *model in ((QTIMAddressBookModel *)friend).list) {
        [self.sectionTitles addObject:model.letter];
    }
    [(RACSubject *)_dataFetchSignal sendNext:self.model];
}

- (RACSignal *)fetchFriendListData
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[SeptnetHttp racGetRequestWithUrl:QTIMUrlbyAppendPath(@"/users/list") param:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.model = [QTIMAddressBookModel mj_objectWithKeyValues:[x valueForKey:@"data"]];
            [subscriber sendNext:self.model];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)fetchGroupData
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[SeptnetHttp racPostRequestWithUrl:QTIMUrlbyAppendPath(@"/group/list") param:nil] subscribeNext:^(id  _Nullable x) {
            x = [x valueForKey:@"data"];
            self.groupDatas = [QTIMGroupShortInfoModel mj_objectArrayWithKeyValuesArray:x];
            [subscriber sendNext:self.groupDatas];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}
@end

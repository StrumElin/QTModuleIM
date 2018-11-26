//
//  QTIMConvListViewModel.m
//  七天汇
//
//  Created by 未可知 on 2018/11/15.
//

#import "QTIMConvListViewModel.h"
#import "QTIMConvListHeaderModel.h"

#import <RongIMKit/RongIMKit.h>

@interface QTIMConvListViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger companyUnreadNums;
@property (nonatomic, assign) NSInteger systemNoticeUnreadNums;
@property (nonatomic, strong) NSArray *displayConversationType;
@property (nonatomic, strong) NSMutableArray *headerDataSource;
@end

@implementation QTIMConvListViewModel
- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"消息";
        self.displayConversationType = @[@(ConversationType_GROUP),@(ConversationType_PRIVATE)];
        _headerDataSource = [NSMutableArray new];
        
        [self receivedmsg];
        
        [self initHeaderData];
    }
    return self;
}

- (void)receivedmsg
{
    @weakify(self);
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:RCKitDispatchMessageNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            RCMessage *message = x.object;
            if (message.conversationType != ConversationType_SYSTEM) {
                return;
            }
            if ([message.targetId isEqualToString:@"rong_system_company"]) {
                for (QTIMConvListHeaderModel *model in self.headerDataSource) {
                    if ([model.Id isEqualToString:message.targetId]) {
                        model.unreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_SYSTEM targetId:model.Id];
                        self.companyUnreadNums = model.unreadCount;
                        break;
                    }
                }
            }
            else if ([message.targetId isEqualToString:@"rong_system_notice"]) {
                for (QTIMConvListHeaderModel *model in self.headerDataSource) {
                    if ([model.Id isEqualToString:message.targetId]) {
                        model.unreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_SYSTEM targetId:model.Id];
                        self.systemNoticeUnreadNums = model.unreadCount;
                        break;
                    }
                }
            }
        });
    }] rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (void)initHeaderData
{
    NSArray *datas = [self readUserConfigData];
    for (NSDictionary *item in datas) {
        QTIMConvListHeaderModel *model = [[QTIMConvListHeaderModel alloc] initWithId:[item valueForKey:@"id"]
                                                                                name:[item valueForKey:@"name"]
                                                                              avatar:[item valueForKey:@"portrait"]
                                                                         unreadCount:0];
        if ([[item valueForKey:@"id"] length]) {
            model.unreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_SYSTEM targetId:model.Id];
        }
        [_headerDataSource addObject:model];
    }
}

- (NSArray *)readUserConfigData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"users_config" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] valueForKey:@"h-users"];
}
@end

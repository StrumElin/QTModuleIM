//
//  QTIMConversationListController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/18.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "QTIMConversationListController.h"
#import "QTIMConversationController.h"
#import "QTIMAddressBookController.h"
#import "QTIMGroupSelectPersonController.h"

#import "QTIMConvListHeaderView.h"

#import "QTIMConvListHeaderModel.h"
#import "QTIMBridgeManager.h"
#import "QTIMMacros.h"
#import "UIImage+QTIM.h"

@interface QTIMConversationListController()
@property (nonatomic, assign) BOOL refreshControlValueChanged;
@property (nonatomic, strong) QTIMConvListViewModel *viewModel;

@property (nonatomic, assign) BOOL needRefresh;
@end

@implementation QTIMConversationListController
#pragma mark - LifeCycle
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = (QTIMConvListViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = _viewModel.title;
    self.displayConversationTypeArray = _viewModel.displayConversationType;
    
    [self initUI];
    
    [self setupNoti];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[QTIMBridgeManager defaultManager] updateUnReadMsgCount];
//    if (self.needRefresh) {
//        [self refreshConversationTableViewIfNeeded];
//    }
}

- (void)setupNoti
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:QTIMDidQuitGroupNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self clearConversationWithNoti:x];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:QTIMDidDismissGroupNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self clearConversationWithNoti:x];
    }];
}

- (void)initUI
{
    self.conversationListTableView.tableFooterView = [UIView new];
    
    QTIMConvListHeaderView *header = [[QTIMConvListHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120) viewModel:_viewModel];
    self.conversationListTableView.tableHeaderView = header;
    @weakify(self);
    [[header rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSIndexPath *indexPath = x.second;
        @strongify(self);
        if (indexPath.item == 0) {
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:@"rong_system_company"];
            if (BridgeManager.delegate && [BridgeManager.delegate respondsToSelector:@selector(rongyunDidClickCompanyNotice)]) {
                [BridgeManager.delegate rongyunDidClickCompanyNotice];
            }
        }
        else if (indexPath.row == 1) {
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:@"rong_system_notice"];
            if (BridgeManager.delegate && [BridgeManager.delegate respondsToSelector:@selector(rongyunDidClickSystemNotice)]) {
                [BridgeManager.delegate rongyunDidClickSystemNotice];
            }
        }
        else {
            QTIMAddressBookViewModel *viewModel = [QTIMAddressBookViewModel new];
            QTIMAddressBookController *vc = [[QTIMAddressBookController alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    if (@available(iOS 10,*)) {
        //添加下拉刷新
        UIRefreshControl *refreshControl = [UIRefreshControl new];
        refreshControl.tintColor = [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:0.5];
        self.conversationListTableView.refreshControl = refreshControl;
        [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.refreshControlValueChanged = YES;
        }];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"creategroup_icon"] imageByScalingToSize:CGSizeMake(25, 25)] style:UIBarButtonItemStylePlain target:self action:@selector(didClickGroup)];
}

- (void)didClickGroup
{
    QTIMSelectPersonViewModel *viewModel = [[QTIMSelectPersonViewModel alloc] init];
    QTIMGroupSelectPersonController *vc = [[QTIMGroupSelectPersonController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (@available(iOS 10, *)) {
        if (self.refreshControlValueChanged) {
            self.refreshControlValueChanged = NO;
            [self refreshConversationTableViewIfNeeded];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                QTINFOLog(@"endRefresh");
                [self.conversationListTableView.refreshControl endRefreshing];
            });
        }
    }
    else {
        if (scrollView.contentOffset.y < -100) {
            [self refreshConversationTableViewIfNeeded];
        }
    }
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath
{
    QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:model.conversationType targetId:model.targetId title:model.conversationTitle];
    QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clearConversationWithNoti:(NSNotification *)noti
{
    NSString *groupId = [noti.userInfo valueForKey:@"id"];
    if (!groupId) {
        return ;
    }
    [[RCIM sharedRCIM] refreshGroupInfoCache:nil withGroupId:groupId];
    RCConversationModel *deModel;
    for (RCConversationModel *model in self.conversationListDataSource) {
        if ([model.targetId isEqualToString:groupId]) {
            deModel = model;
            break;
        }
    }
    [self.conversationListDataSource removeObject:deModel];
    BOOL reflag = [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:groupId];
    BOOL clFlag = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:groupId];
    NSAssert(clFlag == YES && reflag == YES, @"reflag = %d, clflag = %d",reflag, clFlag);
    [self refreshConversationTableViewIfNeeded];
}

@end



//
//  QTIMConversationController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/10/18.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "QTIMConversationController.h"
#import "QTIMGroupInfoController.h"
#import "QTIMAddressBookController.h"
#import "QTIMBaseNavigationController.h"
#import "QTIMUserInfoController.h"

#import "QTIMBridgeManager.h"

#import "UIImage+QTIM.h"

#import <RongContactCard/RongContactCard.h>
#import <RongIMLib/RongIMLib.h>

@interface QTIMConversationController ()
@property (nonatomic, strong) QTIMConvDetailViewModel *viewModel;
@end

@implementation QTIMConversationController

- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    _viewModel = (QTIMConvDetailViewModel *)viewModel;
    if (self = [super initWithConversationType:_viewModel.type targetId:_viewModel.targetId]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.title = self.viewModel.title;
    [self registerClass:[RCContactCardMessageCell class] forMessageClass:[RCContactCardMessage class]];
    
    [self initUI];
    [self initData];
}

- (void)initUI
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageByScalingToSize:CGSizeMake(20, 20)]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(left_click:)];
    self.navigationItem.leftBarButtonItem = item;
    
    if (self.conversationType == ConversationType_GROUP) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"creategroup_icon"] imageByScalingToSize:CGSizeMake(25, 25)] style:UIBarButtonItemStylePlain target:self action:@selector(didClickGroup)];
    }
    
    UIImage *imageFile = [RCKitUtility imageNamed:@"actionbar_file_icon" ofBundle:@"RongCloud.bundle"];
    RCPluginBoardView *pluginBoardView = self.chatSessionInputBarControl.pluginBoardView;
    [pluginBoardView insertItemWithImage:imageFile
                                   title:NSLocalizedStringFromTable(@"File", @"RongCloudKit", nil)
                                 atIndex:3
                                     tag:PLUGIN_BOARD_ITEM_FILE_TAG];
    
    imageFile = [RCKitUtility imageNamed:@"card" ofBundle:@"RongCloud.bundle"];
    [pluginBoardView insertItemWithImage:imageFile
                                   title:NSLocalizedStringFromTable(@"ContactCard", @"RongCloudKit", nil)
                                 atIndex:4
                                     tag:PLUGIN_BOARD_ITEM_CARD_TAG];
}

- (void)initData
{
    if (self.conversationType == ConversationType_GROUP) {
        @weakify(self);
        [[self.viewModel fetchGroupInfo] subscribeNext:^(NSString *x) {
            @strongify(self);
            self.title = x;
        } error:^(NSError * _Nullable error) {
            
        }];
    }
}
- (void)didClickGroup
{
    QTIMGroupInfoViewModel *viewModel = [[QTIMGroupInfoViewModel alloc] initWithId:self.viewModel.targetId];
    QTIMGroupInfoController *vc = [[QTIMGroupInfoController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    if (tag == PLUGIN_BOARD_ITEM_CARD_TAG) {
        QTIMAddressBookViewModel *viewModel = [[QTIMAddressBookViewModel alloc] initWithIsContactCard:YES];
        QTIMAddressBookController *vc = [[QTIMAddressBookController alloc] initWithViewModel:viewModel];
        QTIMBaseNavigationController *nc = [[QTIMBaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];

        @weakify(self);
        [[vc rac_signalForSelector:@selector(sendUserInfo:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            QTIMUserInfoModel *user = x.first;
            RCCCUserInfo *acUser = [[RCCCUserInfo alloc] initWithUserId:user.Id name:user.name portrait:user.avatar];
            acUser.displayName = acUser.name;
            
            RCUserInfo *toUser = [[RCIM sharedRCIM] getUserInfoCache:self.targetId];
            RCCCUserInfo *targetUser = [[RCCCUserInfo alloc] initWithUserId:toUser.userId name:toUser.name portrait:toUser.portraitUri];
            targetUser.displayName = toUser.name;
//            [[RCContactCardKit shareInstance] popupSendContactCardView:acUser targetUserInfo:targetUser];
            
            RCContactCardMessage *message = [RCContactCardMessage messageWithUserInfo:acUser];
            message.sendUserId = [RCIM sharedRCIM].currentUserInfo.userId;
            message.sendUserName = [RCIM sharedRCIM].currentUserInfo.name;
            message.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;

            [[RCIM sharedRCIM] sendMessage:self.viewModel.type targetId:self.viewModel.targetId content:message pushContent:nil pushData:nil success:^(long messageId) {
                QTINFOLog(@"%ld",messageId);
            } error:^(RCErrorCode nErrorCode, long messageId) {
                QTERRORLog(@"%ld",nErrorCode);
            }];
        }];
    }
    else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCContactCardMessage class]]) {
        RCContactCardMessage *card = (RCContactCardMessage *)model.content;
        QTIMUserInfoViewModel *viewModel = [[QTIMUserInfoViewModel alloc] initWithUserId:card.userId];
        QTIMUserInfoController *vc = [[QTIMUserInfoController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didTapCellPortrait:(NSString *)userId
{
    QTIMUserInfoViewModel *viewModel = [[QTIMUserInfoViewModel alloc] initWithUserId:userId];
    QTIMUserInfoController *vc = [[QTIMUserInfoController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)left_click:(id)sender
{
    //FIXME:  融云要求重写 但是这里会有一个动画上的小瑕疵 不知道不重写会有什么后果
//    [super leftBarButtonItemPressed:sender];
//    if (self.conversationType == ConversationType_GROUP) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else if (self.conversationType == ConversationType_PRIVATE) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    [super leftBarButtonItemPressed:sender];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

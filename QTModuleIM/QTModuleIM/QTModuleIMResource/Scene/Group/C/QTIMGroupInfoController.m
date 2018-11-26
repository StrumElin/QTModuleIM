//
//  QTIMGroupInfoController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoController.h"
#import "QTIMGroupMemberListController.h"
#import "QTIMGroupEditInfoController.h"
#import "QTIMGroupSelectPersonController.h"
#import "QTIMGroupSelectPersonController.h"
#import "QTIMUserInfoController.h"

#import "QTIMGroupInfoHeaderView.h"
#import "QTIMGroupInfoCell.h"
#import "QTIMGroupInfoFooterView.h"

#import "QTIMDataSourceManager.h"
#import "QTIMMacros.h"
#import "UIAlertController+Blocks.h"

@interface QTIMGroupInfoController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QTIMGroupInfoViewModel *viewModel;
@property (nonatomic, strong) QTIMGroupInfoHeaderView *header;
@property (nonatomic, strong) QTIMGroupInfoFooterView *footer;

@property (nonatomic, assign) CGFloat headerHeight;
@end

@implementation QTIMGroupInfoController
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        _viewModel = (QTIMGroupInfoViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self dataBinding];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @weakify(self);
    [[self.viewModel fetchGroupInfo] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.footer.frame = CGRectMake(0, 0, MainScreenWidth, 100);
        self.tableView.tableFooterView = self.footer;
        [[self.viewModel fetchGroupPageListData] subscribeNext:^(id  _Nullable x) {
            [self.tableView reloadData];
        }];
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)dataBinding
{
    @weakify(self);
    [RACObserve(self.viewModel, title) subscribeNext:^(NSString *x) {
        @strongify(self);
        self.title = x;
    }];
    
    [[RACObserve(self.viewModel, headerHeight) filter:^BOOL(NSNumber *value) {
        return [value integerValue] != 0;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.header.frame = CGRectMake(0, 0, MainScreenWidth, [x floatValue]);
        self.tableView.tableHeaderView = self.header;
    }];
    
    [[self.header rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSIndexPath *indexPath = x.second;
        @strongify(self);
        QTIMGroupUserInfoModel *userInfo = self.viewModel.model.members[indexPath.item];
        if (userInfo.role != GroupUserInfoRolePlus && userInfo.role != GroupUserInfoRoleMinus) {
            QTIMUserInfoViewModel *viewModel = [[QTIMUserInfoViewModel alloc] initWithUserId:userInfo.Id];
            QTIMUserInfoController *vc = [[QTIMUserInfoController alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }

        @weakify(self);
        if (userInfo.role == GroupUserInfoRoleMinus) {
            [[self.viewModel constructSelectPageDataIsPlus:NO] subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                QTIMSelectPersonViewModel *viewModel = [[QTIMSelectPersonViewModel alloc] initWithFilterUsers:self.viewModel.model.members type:QTIMSelectPersonDataSourceGroupList groupId:self.viewModel.model.Id];
                QTIMGroupSelectPersonController *vc = [[QTIMGroupSelectPersonController alloc] initWithViewModel:viewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        else if (userInfo.role == GroupUserInfoRolePlus) {
            [[self.viewModel constructSelectPageDataIsPlus:YES] subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                QTIMSelectPersonViewModel *viewModel = [[QTIMSelectPersonViewModel alloc] initWithFilterUsers:self.viewModel.model.members type:QTIMSelectPersonDataSourceUnlessGroupList groupId:self.viewModel.model.Id];
                QTIMGroupSelectPersonController *vc = [[QTIMGroupSelectPersonController alloc] initWithViewModel:viewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }];
}

- (void)initUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMGroupInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMGroupInfoCell"];
    self.header = [QTIMGroupInfoHeaderView headerView];
    self.header.viewModel = self.viewModel;
    
    self.footer = [QTIMGroupInfoFooterView footerView];
    @weakify(self);
    [[self.footer rac_signalForSelector:@selector(didClickQuit:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [UIAlertController showAlertInViewController:self
                                           withTitle:@""
                                             message:@"删除并退出后，将不再接受此群聊信息"
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[@"确定"]
                                            tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                               if (buttonIndex == 2) {
                                                   [[self.viewModel quitGroup] subscribeNext:^(id  _Nullable x) {
                                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                                   } error:^(NSError * _Nullable error) {
                                                   }];
                                               }
                                           }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.listDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *datas =self.viewModel.listDatas[section];
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIMGroupInfoCell"];
    NSArray *datas =self.viewModel.listDatas[indexPath.section];
    cell.model = datas[indexPath.row];
    @weakify(self);
    [[cell rac_signalForSelector:@selector(swichValueChanged:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        UISwitch *sw = x.first;
        if (indexPath.row == 0) {
            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP
                                                                    targetId:self.viewModel.model.Id
                                                                   isBlocked:sw.isOn
                                                                     success:^(RCConversationNotificationStatus nStatus) {
                                                                         QTINFOLog(@"设置成功 %ld",nStatus)
                                                                     }
                                                                       error:^(RCErrorCode status) {
                                                                           sw.on = !sw.isOn;
            }];
        }
        else if (indexPath.row == 1) {
            BOOL flag = [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP
                                                                   targetId:self.viewModel.model.Id
                                                                      isTop:sw.isOn];
            if (!flag) {
                sw.on = !sw.isOn;
            }
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSMutableArray *filters = [NSMutableArray new];
        for (QTIMGroupUserInfoModel *user in self.viewModel.model.members) {
            if (user.role == GroupUserInfoRolePlus || user.role == GroupUserInfoRoleMinus) {
                [filters addObject:user];
            }
        }
        for (QTIMGroupUserInfoModel *user in filters) {
            [self.viewModel.model.members removeObject:user];
        }
        QTIMGroupMemeberListViewModel *viewModel = [[QTIMGroupMemeberListViewModel alloc] initWithDataSource:self.viewModel.model.members];
        QTIMGroupMemberListController *vc = [[QTIMGroupMemberListController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1) {
        QTIMGroupEditInfoViewModel *viewModel = [[QTIMGroupEditInfoViewModel alloc] initWithGroupId:self.viewModel.model.Id name:self.viewModel.model.name];
        QTIMGroupEditInfoController *vc = [[QTIMGroupEditInfoController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
        
//        @weakify(self);
//        [[vc rac_signalForSelector:@selector(updateGroupInfoPage:)] subscribeNext:^(RACTuple * _Nullable x) {
//            @strongify(self);
//            self.viewModel.model.name = x.first;
//            [[self.viewModel fetchGroupPageListData] subscribeNext:^(id  _Nullable x) {
//                [self.tableView reloadData];
//            }];
//        }];
    }
    
}

@end

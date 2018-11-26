//
//  QTIMGroupMemberListController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupMemberListController.h"
#import "QTIMConversationController.h"

#import "QTIMAddressBookCell.h"
#import "QTIMMacros.h"

@interface QTIMGroupMemberListController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QTIMGroupMemeberListViewModel *viewModel;
@end

@implementation QTIMGroupMemberListController
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        _viewModel = (QTIMGroupMemeberListViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;

    [self initUI];
}

- (void)initUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 64;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMAddressBookCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMAddressBookCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIMAddressBookCell"];
    cell.model = self.viewModel.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMGroupUserInfoModel *model = self.viewModel.dataSource[indexPath.row];
    if ([model.Id isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        return;
    }
    QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:ConversationType_PRIVATE targetId:model.Id title:model.name];
    QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  QTIMGroupListController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/24.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupListController.h"
#import "QTIMConversationController.h"

#import "QTIMAddressBookCell.h"

@interface QTIMGroupListController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QTIMGroupListViewModel *viewModel;
@end

@implementation QTIMGroupListController
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super initWithViewModel:viewModel]) {
        _viewModel = (QTIMGroupListViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.viewModel.title;
    
    [self initUI];
    
    @weakify(self);
    [[self.viewModel fetchGroupData] subscribeNext:^(id  _Nullable x) {
       @strongify(self);
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
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
    QTIMGroupShortInfoModel *groupInfo = self.viewModel.dataSource[indexPath.row];
    QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:ConversationType_GROUP targetId:groupInfo.Id title:groupInfo.name];
    QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

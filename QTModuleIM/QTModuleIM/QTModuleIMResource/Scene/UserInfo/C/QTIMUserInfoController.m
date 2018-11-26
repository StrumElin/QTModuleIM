//
//  QTIMUserInfoController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoController.h"
#import "QTIMConversationController.h"

#import "QTIMUserInfoHeaderView.h"
#import "QTIMUserInfoFooterView.h"
#import "QTIMUserInfoCell.h"

#import "QTIMUserInfoViewModel.h"
#import "QTIMMacros.h"

@interface QTIMUserInfoController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QTIMUserInfoViewModel *viewModel;
@property (nonatomic, strong) QTIMUserInfoHeaderView *header;
@end

@implementation QTIMUserInfoController
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = (QTIMUserInfoViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMUserInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMUserInfoCell"];
    
    QTIMUserInfoHeaderView *header = [QTIMUserInfoHeaderView headerView];
    _header = header;
    header.viewModel = self.viewModel;
    self.tableView.tableHeaderView = header;
    
    QTIMUserInfoFooterView *footer = [QTIMUserInfoFooterView footerView];
    self.tableView.tableFooterView = footer;
    
    @weakify(self);
    [[footer rac_signalForSelector:@selector(startConvs:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:ConversationType_PRIVATE
                                                                                      targetId:self.viewModel.userInfo.Id
                                                                                         title:self.viewModel.userInfo.name];
        QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    if (nil == self.viewModel.userInfo) {
        [[self.viewModel fetchUserInfo] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView reloadData];
        } error:^(NSError * _Nullable error) {
        }];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
    
    self.tableView.tableFooterView.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    [self.tableView setTableFooterView:self.tableView.tableFooterView];
}

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIMUserInfoCell"];
    cell.model = self.viewModel.dataSource[indexPath.row];
    return cell;
}
@end

//
//  QTIMAddressBookSearchResultController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/23.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMAddressBookSearchResultController.h"
#import "QTIMConversationController.h"
#import "QTIMUserInfoController.h"

#import "QTIMAddressBookCell.h"
#import "QTIMAddressBookHeaderView.h"

@interface QTIMAddressBookSearchResultController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation QTIMAddressBookSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 64;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMAddressBookCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMAddressBookCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMAddressBookHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"QTIMAddressBookHeaderView"];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = QTIMHEXCOLOR(0x666666);
    self.tableView.sectionIndexTrackingBackgroundColor = QTIMHEXCOLOR(0xbbbbbb);
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    @weakify(self);
    [[self.viewModel fetchDataWithKey:searchController.searchBar.text] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.model.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QTIMAddressBookListModel *model = self.viewModel.model.list[section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIMAddressBookCell"];
    QTIMAddressBookListModel *model = self.viewModel.model.list[indexPath.section];
    cell.model = model.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QTIMAddressBookHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QTIMAddressBookHeaderView"];
    header.title = self.viewModel.sectionTitles[section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.viewModel.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

@end

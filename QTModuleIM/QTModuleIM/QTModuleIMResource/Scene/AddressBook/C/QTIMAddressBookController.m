//
//  QTIMAddressBookController.m
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import "QTIMAddressBookController.h"
#import "QTIMUserInfoController.h"
#import "QTIMConversationController.h"
#import "QTIMAddressBookSearchViewController.h"
#import "QTIMAddressBookSearchResultController.h"

#import "QTIMAddressBookCell.h"
#import "QTIMAddressBookHeaderView.h"

#import "QTIMAddressBookSearchResultViewModel.h"

#import "QTIMMacros.h"
#import "UIImage+QTIM.h"

@interface QTIMAddressBookController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) QTIMAddressBookViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) QTIMAddressBookSearchViewController *searchViewController;
@property (nonatomic, strong) QTIMAddressBookSearchResultController *resultVc;
@end

@implementation QTIMAddressBookController
#pragma mark - LifeCycle
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = (QTIMAddressBookViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
    @weakify(self);
    [[self.viewModel fetchAddressBookData] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.resultVc.viewModel = [[QTIMAddressBookSearchResultViewModel alloc] initWithViewModel:self.viewModel];
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
    }];
    [self initUI];
}

- (void)initUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 64;

    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMAddressBookCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMAddressBookCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMAddressBookHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"QTIMAddressBookHeaderView"];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = QTIMHEXCOLOR(0x666666);
    self.tableView.sectionIndexTrackingBackgroundColor = QTIMHEXCOLOR(0xbbbbbb);
    
    self.resultVc = [QTIMAddressBookSearchResultController new];
    @weakify(self);
    [[self.resultVc rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self tableView:x.first didSelectRowAtIndexPath:x.second];
    }];
    
    self.definesPresentationContext = YES;
    self.searchViewController = [[QTIMAddressBookSearchViewController alloc] initWithSearchResultsController:_resultVc];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.searchViewController.searchBar.frame.size.height)];
    [view addSubview:self.searchViewController.searchBar];
    self.tableView.tableHeaderView = view;
}

- (void)leftItemEvent:(id)sender
{
    if (self.viewModel.isContactCard) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMAddressBookListModel *model = self.viewModel.model.list[indexPath.section];
    id info = model.list[indexPath.row];
    if (self.viewModel.isContactCard) {
        [self sendUserInfo:(QTIMUserInfoModel *)info];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    if ([info isKindOfClass:[QTIMUserInfoModel class]]) {
        QTIMUserInfoModel *userInfo = (QTIMUserInfoModel *)info;
        QTIMUserInfoViewModel *viewModel = [[QTIMUserInfoViewModel alloc] initWithUserId:userInfo.Id];
        QTIMUserInfoController *vc = [[QTIMUserInfoController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([info isKindOfClass:[QTIMGroupShortInfoModel class]]) {
        QTIMGroupShortInfoModel *groupInfo = (QTIMGroupShortInfoModel *)info;
        QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:ConversationType_GROUP targetId:groupInfo.Id title:groupInfo.name];
        QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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

#pragma mark - Privite
- (void)sendUserInfo:(QTIMUserInfoModel *)userInfo {}
@end

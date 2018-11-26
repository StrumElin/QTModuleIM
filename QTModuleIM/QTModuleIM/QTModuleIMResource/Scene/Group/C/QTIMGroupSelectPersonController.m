//
//  QTIMGroupSelectPersonController.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupSelectPersonController.h"
#import "QTIMGroupListController.h"
#import "QTIMConversationController.h"

#import "QTIMAddressBookHeaderView.h"
#import "QTIMSelectPersonTableCell.h"
#import "QTIMSelectPersonCollectionCell.h"
#import "QTIMSelectPersonGroupCell.h"

#import "UIImage+QTIM.h"
#import "QTIMMacros.h"

@interface QTIMGroupSelectPersonController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTextWidth;

@property (nonatomic, strong) QTIMSelectPersonViewModel *viewModel;
@end

@implementation QTIMGroupSelectPersonController
- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = (QTIMSelectPersonViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
    self.searchTextWidth.constant = self.view.frame.size.width - 5;
    
    [self initUI];
    [self dataBinding];
}

- (void)initUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 64;
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMSelectPersonTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMSelectPersonTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMSelectPersonGroupCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QTIMSelectPersonGroupCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QTIMAddressBookHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"QTIMAddressBookHeaderView"];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = QTIMHEXCOLOR(0x666666);
    self.tableView.sectionIndexTrackingBackgroundColor = QTIMHEXCOLOR(0xbbbbbb);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"QTIMSelectPersonCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QTIMSelectPersonCollectionCell"];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageV.image = [[UIImage imageNamed:@"search"] imageByScalingToSize:CGSizeMake(20, 20)];
    _searchTextfield.leftView = imageV;
    _searchTextfield.leftViewMode = UITextFieldViewModeAlways;
    _searchTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 搜索" attributes:@{NSForegroundColorAttributeName : QTIMHEXCOLOR(0x999999),NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    _searchTextfield.textColor = QTIMHEXCOLOR(0x333333);
    _searchTextfield.font = [UIFont systemFontOfSize:16];
    
    @weakify(self);
    [[_searchTextfield rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.searchTextfield.leftViewMode = UITextFieldViewModeNever;
    }];
    
    [[_searchTextfield rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self);
        [[self.viewModel fetchDataWithKey:self.searchTextfield.text] subscribeNext:^(id  _Nullable x) {
            [self.tableView reloadData];
        }];
    }];
}

- (void)dataBinding
{
    @weakify(self);
    [[self.viewModel fetchDataWithKey:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
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
    if (self.viewModel.type == QTIMSelectPersonDataSourceCreatGroup && indexPath.section == 0) {
        QTIMSelectPersonGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIMSelectPersonGroupCell"];
        return cell;
    }
    QTIMSelectPersonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIMSelectPersonTableCell"];
    QTIMAddressBookListModel *model = self.viewModel.model.list[indexPath.section];
    cell.model = model.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.type == QTIMSelectPersonDataSourceCreatGroup && indexPath.section == 0) {
        QTIMGroupListViewModel *viewModel = [QTIMGroupListViewModel new];
        QTIMGroupListController *vc = [[QTIMGroupListController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    QTIMAddressBookListModel *model = self.viewModel.model.list[indexPath.section];
    QTIMUserInfoModel *user = model.list[indexPath.row];
    if (user.status == 2) {
        return;
    }
    else if (user.status == 1) {
        _searchTextfield.leftViewMode = UITextFieldViewModeNever;
        NSInteger index = 0;
        for (QTIMUserInfoModel *sUser in self.viewModel.selectedUsers) {
            if ([sUser.Id isEqualToString:user.Id]) {
                break;
            }
            index++;
        }
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    else {
        _searchTextfield.leftViewMode = UITextFieldViewModeNever;
        user.status = 1;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        @weakify(self);
        [[self.viewModel addSelectedUser:user]
         subscribeNext:^(id  _Nullable x) {
             @strongify(self);
             [self.collectionView reloadData];
             CGFloat textWidth = self.view.frame.size.width -  (self.viewModel.selectedUsers.count * (38 + 8) + 10);
             if (textWidth < 100) {
                 self.searchTextWidth.constant = 100;
                 [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedUsers.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
             }
             else {
                 self.searchTextWidth.constant = textWidth;
             }
             [self setupRightBarButton];
         }];
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
    if (self.viewModel.type == QTIMSelectPersonDataSourceCreatGroup && section == 0) {
        return CGFLOAT_MIN;
    }
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

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.selectedUsers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMSelectPersonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QTIMSelectPersonCollectionCell" forIndexPath:indexPath];
    cell.model = self.viewModel.selectedUsers[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMUserInfoModel *model = self.viewModel.selectedUsers[indexPath.item];
    model.status = 0;
    @weakify(self);
    [[self.viewModel deleteSelectedUser:model] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self setupRightBarButton];
        
        if (self.viewModel.selectedUsers.count == 0) {
            [[self.viewModel fetchDataWithKey:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                [self.tableView reloadData];
                [self.collectionView reloadData];
                self.searchTextWidth.constant = self.view.frame.size.width - 5;
                self.searchTextfield.text = nil;
                self.searchTextfield.leftViewMode = UITextFieldViewModeNever;
            }];
        }
        else {
            [self.collectionView reloadData];
            [self.tableView reloadData];
            CGFloat textWidth = self.view.frame.size.width -  (self.viewModel.selectedUsers.count * (38 + 8) + 10);
            if (textWidth < 100) {
                self.searchTextWidth.constant = 100;
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedUsers.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            }
            else {
                self.searchTextWidth.constant = textWidth;
            }
        }
    }];
}

- (void)setupRightBarButton
{
    NSString *content;
    if (self.viewModel.selectedUsers.count == 0) {
        content = @"确定";
    }
    else {
        content = [NSString stringWithFormat:@"确定(%ld)",self.viewModel.selectedUsers.count];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:content
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(didClickRightItem:)];
    if (self.viewModel.selectedUsers.count == 0) {
        item.tintColor = QTIMHEXCOLORAlpha(0xffffff, 0.5);
    }
    else {
        item.tintColor = [UIColor whiteColor];
    }
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didClickRightItem:(id)sender
{
    if (self.viewModel.selectedUsers.count == 0) {
        return;
    }
    switch (self.viewModel.type) {
        case QTIMSelectPersonDataSourceGroupList:
        {
            [[self.viewModel deleteUsersFromGroup] subscribeNext:^(id  _Nullable x) {
                if ([[x valueForKey:@"code"] integerValue] == 200) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    QTINFOLog(@"删除失败");
                }
            } error:^(NSError * _Nullable error) {
                QTERRORLog(@"删除失败");
            }];
        }
            break;
        case QTIMSelectPersonDataSourceCreatGroup:
        {
            [QTIMLoadingView show];
            [[self.viewModel creatGroup] subscribeNext:^(NSString *x) {
                [QTIMLoadingView hide];
                if (x.length) {
                    QTIMConvDetailViewModel *viewModel = [[QTIMConvDetailViewModel alloc] initWithConvType:ConversationType_GROUP targetId:x title:nil];
                    QTIMConversationController *vc = [[QTIMConversationController alloc] initWithViewModel:viewModel];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } error:^(NSError * _Nullable error) {
                [QTIMLoadingView hide];
            }];
        }
            break;
        case QTIMSelectPersonDataSourceUnlessGroupList:
        {
            [[self.viewModel addUsersToGroup] subscribeNext:^(id  _Nullable x) {
                if ([[x valueForKey:@"code"] integerValue] == 200) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    QTINFOLog(@"添加失败");
                }
            } error:^(NSError * _Nullable error) {
                QTERRORLog(@"添加失败");
            }];
        }
            break;
            
        default:
            break;
    }
}


@end

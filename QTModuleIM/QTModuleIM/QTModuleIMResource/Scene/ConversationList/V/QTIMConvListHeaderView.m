//
//  QTIMConvListHeaderView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/14.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMConvListHeaderView.h"
#import "QTIMConvListHeaderCollectionCell.h"

@interface QTIMConvListHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QTIMConvListViewModel *videoModel;
@end

@implementation QTIMConvListHeaderView
- (instancetype)initWithFrame:(CGRect)frame viewModel:(QTIMConvListViewModel *)viewModel
{
    if (self = [super initWithFrame:frame]) {
        _videoModel = viewModel;
        
        @weakify(self);
        [[RACObserve(_videoModel, systemNoticeUnreadNums) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
        
        [[RACObserve(_videoModel, companyUnreadNums) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            [self.collectionView reloadData];
        }];
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake(self.frame.size.width/3, self.frame.size.height - 10);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"QTIMConvListHeaderCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QTIMConvListHeaderCollectionCell"];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, collectionView.frame.size.height, self.frame.size.width, 10)];
    lineV.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
    [self addSubview:lineV];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoModel.headerDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMConvListHeaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QTIMConvListHeaderCollectionCell" forIndexPath:indexPath];
    cell.model = _videoModel.headerDataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{}

@end

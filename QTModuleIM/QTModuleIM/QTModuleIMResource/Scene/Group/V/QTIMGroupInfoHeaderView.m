//
//  QTIMGroupInfoHeaderView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoHeaderView.h"

#import "QTIMGroupInfoHeaderCell.h"
#import "QTIMMacros.h"

@interface QTIMGroupInfoHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation QTIMGroupInfoHeaderView
+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"QTIMGroupInfoHeaderView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"QTIMGroupInfoHeaderCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QTIMGroupInfoHeaderCell"];
}

- (void)setViewModel:(QTIMGroupInfoViewModel *)viewModel
{
    _viewModel = viewModel;
    @weakify(self);
    [RACObserve(self.viewModel, model) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.model.members.count > DisplayMaxCount ? DisplayMaxCount : self.viewModel.model.members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTIMGroupInfoHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QTIMGroupInfoHeaderCell" forIndexPath:indexPath];
    cell.model = self.viewModel.model.members[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{}
@end

@interface QTIMGroupInfoHeaderCollectionViewFlowLayout : UICollectionViewFlowLayout
@end

@implementation QTIMGroupInfoHeaderCollectionViewFlowLayout
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        self.minimumLineSpacing = 20;
        self.minimumInteritemSpacing = 20;
        CGFloat width = (MainScreenWidth - 40 - 20 * (LineItemCount  - 1))/LineItemCount;
        self.itemSize = CGSizeMake(width, width + 24);
    }
    return self;
}
@end

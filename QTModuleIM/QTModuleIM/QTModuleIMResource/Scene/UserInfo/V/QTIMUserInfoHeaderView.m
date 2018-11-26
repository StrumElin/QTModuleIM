//
//  QTIMUserInfoHeaderView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoHeaderView.h"
#import "UIImageView+WebCache.h"

@interface QTIMUserInfoHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation QTIMUserInfoHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"QTIMUserInfoHeaderView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarImgView.layer.cornerRadius = 5;
    self.avatarImgView.layer.masksToBounds = YES;
}

- (void)setViewModel:(QTIMUserInfoViewModel *)viewModel
{
    _viewModel = viewModel;
    @weakify(self);
    [RACObserve(self.viewModel, userInfo) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.userInfo.avatar] placeholderImage:nil];
        self.nameLabel.text = self.viewModel.userInfo.name;
        self.phoneLabel.text = [NSString stringWithFormat:@"职位 : %@",self.viewModel.userInfo.role];
    }];
}

@end

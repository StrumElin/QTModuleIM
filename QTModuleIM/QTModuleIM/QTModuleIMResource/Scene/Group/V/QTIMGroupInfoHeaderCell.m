//
//  QTIMGroupInfoHeaderCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoHeaderCell.h"

#import "UIImageView+WebCache.h"
#import "QTIMMacros.h"
#import "UIImage+QTIM.h"

@interface QTIMGroupInfoHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation QTIMGroupInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImgView.layer.cornerRadius = 5;
    self.avatarImgView.layer.masksToBounds = YES;
}

- (void)setModel:(QTIMGroupUserInfoModel *)model
{
    _model = model;
    if (model.Id.length == 0) {
        _avatarImgView.layer.borderWidth = 0.5;
        _avatarImgView.layer.borderColor = QTIMHEXCOLOR(0xdddddd).CGColor;
        if (model.role == GroupUserInfoRolePlus) {
            _avatarImgView.image = [[UIImage imageNamed:@"plus"] imageByScalingToSize:CGSizeMake(30, 30)];
        }
        else if (model.role == GroupUserInfoRoleMinus) {
            _avatarImgView.image = [[UIImage imageNamed:@"minus"] imageByScalingToSize:CGSizeMake(30, 30)];
        }
        _avatarImgView.contentMode = UIViewContentModeCenter;
        _titleLabel.text = nil;
    }
    else {
        _avatarImgView.layer.borderWidth = 0;
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
        _avatarImgView.contentMode = UIViewContentModeScaleToFill;
        _titleLabel.text = model.name;
    }
}

@end

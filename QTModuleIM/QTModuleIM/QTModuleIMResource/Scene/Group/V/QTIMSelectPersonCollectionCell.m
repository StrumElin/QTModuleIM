//
//  QTIMSelectPersonCollectionCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMSelectPersonCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface QTIMSelectPersonCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@end

@implementation QTIMSelectPersonCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImgView.layer.cornerRadius = 5;
    self.avatarImgView.layer.masksToBounds = YES;
}

- (void)setModel:(QTIMUserInfoModel *)model
{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
}

@end

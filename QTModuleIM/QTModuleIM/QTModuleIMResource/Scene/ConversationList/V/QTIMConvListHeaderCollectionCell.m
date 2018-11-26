//
//  QTIMConvListHeaderCollectionCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/14.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMConvListHeaderCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface QTIMConvListHeaderCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;

@end

@implementation QTIMConvListHeaderCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _dotLabel.layer.cornerRadius = _dotLabel.frame.size.height/2;
    _dotLabel.layer.masksToBounds = YES;
}

- (void)setModel:(QTIMConvListHeaderModel *)model
{
    _model = model;
    _titleLabel.text = model.name;
    [_logoImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    _dotLabel.hidden = model.unreadCount == 0;
    if (model.unreadCount) {
        _dotLabel.text = @(model.unreadCount).stringValue;
    }
}
@end

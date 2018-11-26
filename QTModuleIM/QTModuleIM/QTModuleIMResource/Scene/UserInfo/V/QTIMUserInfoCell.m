//
//  QTIMUserInfoCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoCell.h"

@interface QTIMUserInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation QTIMUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(QTIMUserInfoDisplayModel *)model
{
    _model = model;
    _titleLabel.text = model.title;
    _descLabel.text = model.desc;
}

@end

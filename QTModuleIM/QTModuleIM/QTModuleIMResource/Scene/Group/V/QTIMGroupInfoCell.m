//
//  QTIMGroupInfoCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoCell.h"

@interface QTIMGroupInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UISwitch *swich;
@end

@implementation QTIMGroupInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_swich addTarget:self action:@selector(swichValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setModel:(QTIMGroupInfoContentModel *)model
{
    _model = model;
    _titleLabel.text = model.title;
    if (model.isOn == NSIntegerMax) {
        _swich.hidden = YES;
        _descLabel.hidden = NO;
        _descLabel.text = model.desc;
        if ([model.title hasPrefix:@"全部"]) {
            _descLabel.hidden = YES;
        }
    }
    else {
        _swich.hidden = NO;
        _descLabel.hidden = YES;
        _swich.on = model.isOn;
    }
}

- (void)swichValueChanged:(UISwitch *)swich{};

@end

//
//  QTIMSelectPersonTableCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMSelectPersonTableCell.h"
#import "UIImageView+WebCache.h"

@interface QTIMSelectPersonTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedIconImg;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation QTIMSelectPersonTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImgView.layer.cornerRadius = 5;
    _avatarImgView.layer.masksToBounds = YES;
}

- (void)setModel:(id<QTIMAddressBookListContentAdaptor>)model
{
    _model = model;
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:[model avatarString]] placeholderImage:nil];
    _titleLabel.text = [model nameString];
    if ([model statusInteger] == 0) {
        _selectedIconImg.image = [UIImage imageNamed:@"unselect"];
    }
    else if ([model statusInteger] == 1) {
        _selectedIconImg.image = [UIImage imageNamed:@"select"];
    }
    else if ([model statusInteger] == 2) {
        _selectedIconImg.image = [UIImage imageNamed:@"disable_select"];
    }
}

@end

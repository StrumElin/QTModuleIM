//
//  QTIMAddressBookCell.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMAddressBookCell.h"
#import "UIImageView+WebCache.h"

@interface QTIMAddressBookCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation QTIMAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImgView.layer.cornerRadius = 5;
    self.avatarImgView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setModel:(id<QTIMAddressBookListContentAdaptor>)model
{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[model avatarString]] placeholderImage:nil];
    _titleLabel.text = [model nameString];
}

@end

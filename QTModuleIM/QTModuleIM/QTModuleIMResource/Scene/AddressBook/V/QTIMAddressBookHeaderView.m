//
//  QTIMAddressBookHeaderView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMAddressBookHeaderView.h"

#import "QTIMMacros.h"

@interface QTIMAddressBookHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QTIMAddressBookHeaderView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.backgroundColor = backGroundColor;
    self.contentView.backgroundColor = backGroundColor;
    self.backgroundColor = backGroundColor;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    if ([title isEqualToString:@"#"]) {
        _titleLabel.text = @"群组";
    }
}

@end

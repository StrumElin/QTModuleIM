//
//  QTIMUserInfoFooterView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMUserInfoFooterView.h"

@interface QTIMUserInfoFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *startConv;
@property (weak, nonatomic) IBOutlet UIButton *voiceConv;
@end

@implementation QTIMUserInfoFooterView

+ (instancetype)footerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"QTIMUserInfoFooterView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.startConv.layer.cornerRadius = 5;
    self.startConv.layer.masksToBounds = YES;
    
    self.voiceConv.layer.cornerRadius = 5;
    self.voiceConv.layer.masksToBounds = YES;
}

- (IBAction)startConvs:(id)sender {
}

@end

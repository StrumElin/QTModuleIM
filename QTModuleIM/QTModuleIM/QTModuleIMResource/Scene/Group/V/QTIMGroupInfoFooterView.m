//
//  QTIMGroupInfoFooterView.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupInfoFooterView.h"

@interface QTIMGroupInfoFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@end

@implementation QTIMGroupInfoFooterView
+ (instancetype)footerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"QTIMGroupInfoFooterView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.quitBtn.layer.cornerRadius = 5;
    self.quitBtn.layer.masksToBounds = YES;
}

- (IBAction)didClickQuit:(id)sender
{}
@end

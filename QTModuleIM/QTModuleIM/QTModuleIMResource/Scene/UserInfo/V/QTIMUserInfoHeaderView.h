//
//  QTIMUserInfoHeaderView.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTIMUserInfoViewModel.h"

@interface QTIMUserInfoHeaderView : UIView

@property (nonatomic, strong) QTIMUserInfoViewModel *viewModel;

+ (instancetype)headerView;

@end

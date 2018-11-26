//
//  QTIMGroupInfoHeaderView.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTIMGroupInfoViewModel.h"

@interface QTIMGroupInfoHeaderView : UIView

@property (nonatomic, strong) QTIMGroupInfoViewModel *viewModel;

+ (instancetype)headerView;

@end

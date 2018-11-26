//
//  QTIMConvListHeaderView.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/14.
//  Copyright © 2018 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QTIMConvListViewModel.h"

@interface QTIMConvListHeaderView : UIView

@property (nonatomic, strong, readonly) QTIMConvListViewModel *videoModel;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(QTIMConvListViewModel *)viewModel;

@end

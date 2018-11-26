//
//  QTIMUserInfoController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseController.h"
#import "QTIMUserInfoViewModel.h"
#import "QTIMControlerAdaptor.h"

@interface QTIMUserInfoController : QTIMBaseController <QTIMControlerAdaptor>
@property (nonatomic, strong, readonly) QTIMUserInfoViewModel *viewModel;
@end

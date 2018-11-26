//
//  QTIMGroupSelectPersonController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseController.h"

#import "QTIMSelectPersonViewModel.h"
#import "QTIMControlerAdaptor.h"

@interface QTIMGroupSelectPersonController : QTIMBaseController <QTIMControlerAdaptor>
@property (nonatomic, strong, readonly) QTIMSelectPersonViewModel *viewModel;
@end

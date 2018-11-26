//
//  QTIMGroupEditInfoController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/21.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseController.h"
#import "QTIMGroupEditInfoViewModel.h"

@interface QTIMGroupEditInfoController : QTIMBaseController <QTIMControlerAdaptor>
@property (nonatomic, strong, readonly) QTIMGroupEditInfoViewModel *viewMode;
@end

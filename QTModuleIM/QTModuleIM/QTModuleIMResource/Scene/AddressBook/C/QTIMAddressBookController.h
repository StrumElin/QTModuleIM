//
//  QTIMAddressBookController.h
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import "QTIMBaseController.h"
#import "QTIMControlerAdaptor.h"
#import "QTIMAddressBookViewModel.h"

@interface QTIMAddressBookController : QTIMBaseController <QTIMControlerAdaptor>
@property (nonatomic, strong, readonly) QTIMAddressBookViewModel *viewModel;
@end

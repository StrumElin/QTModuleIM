//
//  QTIMAddressBookSearchResultController.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/23.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMBaseController.h"

#import "QTIMAddressBookSearchResultViewModel.h"

@interface QTIMAddressBookSearchResultController : QTIMBaseController <UISearchResultsUpdating>
@property (nonatomic, strong) QTIMAddressBookSearchResultViewModel *viewModel;
@end

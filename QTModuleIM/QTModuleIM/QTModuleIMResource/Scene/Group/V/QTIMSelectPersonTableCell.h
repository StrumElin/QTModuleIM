//
//  QTIMSelectPersonTableCell.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTIMUserInfoModel.h"
#import "QTIMAddressBookListContentAdaptor.h"

@interface QTIMSelectPersonTableCell : UITableViewCell
@property (nonatomic, strong) id<QTIMAddressBookListContentAdaptor> model;
@end

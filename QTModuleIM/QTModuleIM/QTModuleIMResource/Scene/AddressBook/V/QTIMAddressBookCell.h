//
//  QTIMAddressBookCell.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTIMAddressBookListContentAdaptor.h"

@interface QTIMAddressBookCell : UITableViewCell
@property (nonatomic, strong)  id<QTIMAddressBookListContentAdaptor>model;
@end

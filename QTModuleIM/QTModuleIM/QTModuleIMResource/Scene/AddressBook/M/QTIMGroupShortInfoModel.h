//
//  QTIMGroupInfoModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTIMAddressBookListContentAdaptor.h"

@interface QTIMGroupShortInfoModel : NSObject <QTIMAddressBookListContentAdaptor, NSCopying>
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSNumber *role;
/**
 *"id":10000,
 "name":"群名称",
 "avatar":""
 */
@end

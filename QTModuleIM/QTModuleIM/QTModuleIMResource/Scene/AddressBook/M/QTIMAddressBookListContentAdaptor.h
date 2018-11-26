//
//  QTIMAddressBookCellAdaptor.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/19.
//  Copyright © 2018 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QTIMAddressBookListContentAdaptor <NSObject>
- (NSString *)avatarString;
- (NSString *)nameString;
@optional
- (NSString *)IdString;
- (NSInteger)statusInteger;
@end

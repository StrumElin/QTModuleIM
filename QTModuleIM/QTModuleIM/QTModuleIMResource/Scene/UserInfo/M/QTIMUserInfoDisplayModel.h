//
//  QTIMUserInfoDisplayModel.h
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTIMUserInfoDisplayModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc;

@end

//
//  QTIMControlerAdaptor.h
//  七天汇
//
//  Created by 未可知 on 2018/11/16.
//

#import <Foundation/Foundation.h>
@class QTIMBaseViewModel;

@protocol QTIMControlerAdaptor <NSObject>

- (instancetype)initWithViewModel:(QTIMBaseViewModel *)viewModel;

@end

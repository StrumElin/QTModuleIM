//
//  QTIMGroupMemeberListViewModel.m
//  RIMDemo
//
//  Created by 未可知 on 2018/11/20.
//  Copyright © 2018 QT. All rights reserved.
//

#import "QTIMGroupMemeberListViewModel.h"

@interface QTIMGroupMemeberListViewModel ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation QTIMGroupMemeberListViewModel
- (instancetype)initWithDataSource:(NSArray *)dataSource
{
    if (self = [super init]) {
        _dataSource = dataSource;
        self.title = [NSString stringWithFormat:@"群组成员(%ld)",dataSource.count];
    }
    return self;
}

@end

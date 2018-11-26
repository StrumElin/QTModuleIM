//
//  QTIMConvListHeaderModel.m
//  MyApp
//
//  Created by 未可知 on 2018/11/14.
//

#import "QTIMConvListHeaderModel.h"

@implementation QTIMConvListHeaderModel
- (instancetype)initWithId:(NSString *)aId name:(NSString *)name avatar:(NSString *)aAvatar unreadCount:(NSInteger)unreadCount
{
    if (self = [super init]) {
        _Id = aId;
        _name = name;
        _avatar = aAvatar;
        _unreadCount = unreadCount;
    }
    return self;
}
@end

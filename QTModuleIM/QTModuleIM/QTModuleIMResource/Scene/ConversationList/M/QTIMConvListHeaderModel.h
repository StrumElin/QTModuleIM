//
//  QTIMConvListHeaderModel.h
//  MyApp
//
//  Created by 未可知 on 2018/11/14.
//

#import <Foundation/Foundation.h>

@interface QTIMConvListHeaderModel : NSObject
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger unreadCount;

- (instancetype)initWithId:(NSString *)aId name:(NSString *)name avatar:(NSString *)aAvatar unreadCount:(NSInteger)unreadCount;

@end

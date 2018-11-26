//
//  SeptnetHttp.h
//  七天汇
//
//  Created by ☺strum☺ on 2018/11/15.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "QTIMMacros.h"

//#define QTIMUrlbyAppendPath(path) [NSString stringWithFormat:@"http://192.168.0.152:3000%@",path]
#define QTIMUrlbyAppendPath(path) [NSString stringWithFormat:@"http://115.28.115.220:3000%@",path]
#define QTIMRequestHeaderAuthKey @"Authorization"
#define QTIMRequestHeaderAuthValue (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:QTIMUserDefaultsUserPhoneKey]

//static NSString *baseUrl() {
//    return [[NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"users_config" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil] valueForKey:@"appkey"];
//}

@interface SeptnetHttp : NSObject

#pragma mark get 请求
/**
 * get 请求
 * @param url 请求地址
 * @param headers 头部字段
 * @param success 成功回调
 * @param fail 失败回调
 */
+(void)requestGetWithUrl:(NSString*)url Headers:(NSDictionary*)headers success:(void (^)(id response))success fail:(void (^)(NSError *error))fail;


/**
 * RAC get 请求
 * @param url 请求地址
 * @param headers 头部字段
 */
+(RACSignal *)racRequestGetWithUrl:(NSString*)url Headers:(NSDictionary*)headers;

#pragma mark post 请求
/**
 * post 请求
 * @param postData 请求数据
 * @param url 请求地址
 * @param bodyType 请求类型
 * @param success 失败回调
 * @param fail 失败回调
 */
+(void)requestPostData:(NSData *)postData ServerUrl:(NSString *)url bodyType:(NSString *)bodyType Headers:(NSDictionary*)headers success:(void (^)(id response))success fail:(void (^)(NSError *error))fail;

/**
 * RAC post 请求
 * @param postData 请求数据
 * @param url 请求地址
 * @param bodyType 请求类型
 */
+(RACSignal *)racRequestPostData:(NSData *)postData ServerUrl:(NSString *)url bodyType:(NSString *)bodyType Headers:(NSDictionary*)headers;


@end

@interface SeptnetHttp (simplify)

/**
 * RAC Get 请求
 * @param url 请求地址
 * @param param 请求参数
 */
+ (RACSignal *)racGetRequestWithUrl:(NSString *)url param:(NSDictionary *)param;

/**
 * RAC Post 请求
 * @param url 请求地址
 * @param param 请求参数
 */
+ (RACSignal *)racPostRequestWithUrl:(NSString *)url param:(NSDictionary *)param;

@end

@interface NSDictionary (serialize)

- (NSData *)httpBody;

- (NSString *)queryString;

@end




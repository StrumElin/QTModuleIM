//
//  SeptnetHttp.m
//  七天汇
//
//  Created by ☺strum☺ on 2018/11/15.
//

#import "SeptnetHttp.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@implementation SeptnetHttp

#pragma mark - get 请求
+(void)requestGetWithUrl:(NSString*)url Headers:(NSDictionary*)headers success:(void (^)(id response))success fail:(void (^)(NSError *error))fail{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
//    if(headers){
//        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
//        }];
//    }
    
//    [manager.requestSerializer setTimeoutInterval:5];


    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [urlRequest setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            fail(error);
        } else {
            NSLog(@"get success url--- %@",url);
            success(responseObject);
        }
    }];
    
    [dataTask resume];
}


+(RACSignal *)racRequestGetWithUrl:(NSString*)url Headers:(NSDictionary*)headers{
    @weakify(self)
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        [self requestGetWithUrl:url Headers:headers success:^(id response) {
            [subscriber sendNext:response];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    
    }];
}

#pragma mark - post 请求
+(void)requestPostData:(NSData *)postData ServerUrl:(NSString *)url bodyType:(NSString *)bodyType Headers:(NSDictionary*)headers success:(void (^)(id response))success fail:(void (^)(NSError *error))fail{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy = securityPolicy;                //设置验证模式
//    [manager.requestSerializer setTimeoutInterval:5];
    
    if(headers){
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [urlRequest setAllHTTPHeaderFields:headers];
    [urlRequest setTimeoutInterval:15];
    [urlRequest setHTTPBody:postData];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[NSString stringWithFormat:@"application/%@",bodyType] forHTTPHeaderField:@"Content-Type"];
//    [urlRequest setValue:[NSString stringWithFormat:@"application/%@",@"json"] forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"NET WORK ERROR IN CellRefreshRequest: %@ code:%ld---url:%@", error.localizedDescription, (long)error.code,url);
            fail(error);
            
        } else {
            NSLog(@"post success url--- %@",url);
            success(responseObject);
        }
    }];
    [dataTask resume];
}


+(RACSignal *)racRequestPostData:(NSData *)postData ServerUrl:(NSString *)url bodyType:(NSString *)bodyType Headers:(NSDictionary*)headers{
    
    @weakify(self)
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        [self requestPostData:postData ServerUrl:url bodyType:bodyType Headers:headers success:^(id response) {
            [subscriber sendNext:response];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
    
}


@end

@implementation SeptnetHttp (simplify)

+ (RACSignal *)racPostRequestWithUrl:(NSString *)url param:(NSDictionary *)param
{
    return [self racPostRequestWithUrl:url param:param header:@{QTIMRequestHeaderAuthKey : QTIMRequestHeaderAuthValue}];
}

+ (RACSignal *)racGetRequestWithUrl:(NSString *)url param:(NSDictionary *)param
{
    return [self racGetRequestWithUrl:url param:param header:@{QTIMRequestHeaderAuthKey : QTIMRequestHeaderAuthValue}];
}

+ (RACSignal *)racGetRequestWithUrl:(NSString *)url param:(NSDictionary *)param header:(NSDictionary *)header
{
    NSString *queryString = [param queryString];
    if (nil != queryString) {
        url = [NSString stringWithFormat:@"%@?%@",url,queryString];
    }
    return [[self racRequestGetWithUrl:url Headers:header] map:^id _Nullable(id  _Nullable value) {
        if ([[value valueForKey:@"code"] integerValue] != 200) {
            QTERRORLog("%@",[value valueForKey:@"msg"]);
        }
        return value;
    }];
}

+ (RACSignal *)racPostRequestWithUrl:(NSString *)url param:(NSDictionary *)param header:(NSDictionary *)header
{
    
    return [[self racRequestPostData:[param httpBody] ServerUrl:url bodyType:@"x-www-form-urlencoded" Headers:header]  map:^id _Nullable(id  _Nullable value) {
        if ([[value valueForKey:@"code"] integerValue] != 200) {
            QTERRORLog("%@",[value valueForKey:@"msg"]);
        }
        return value;
    }];;}
@end

@implementation NSDictionary (serialize)
- (NSData *)httpBody
{

    return [[self queryString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)queryString
{
    if (nil == self) {
        return nil;
    }
    __block NSMutableString *mutableString = [@"" mutableCopy];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutableString appendString:[self escapeCharatersWithString:key]];
        [mutableString appendString:[NSString stringWithFormat:@"=%@&",[self escapeCharatersWithString:[obj mj_JSONString]]]];
    }];
    if ([mutableString hasSuffix:@"&"]) {
        [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 1, 1)];
    }
    return (NSString *)mutableString;
}

- (NSString *)escapeCharatersWithString:(NSString *)string
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}
@end



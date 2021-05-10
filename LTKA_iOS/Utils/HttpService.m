//
//  HttpService.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import "HttpService.h"
#import "LTKAContext.h"

#import <AFNetworking/AFNetworking.h>

@implementation HttpService

+ (instancetype)shareInstance {
    static HttpService *hs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hs = [[HttpService alloc] init];
    });
    return hs;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)registerServiceWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSString *urlPrefix = [[LTKAContext shareInstance] urlPrefix];
    NSString *url = [urlPrefix stringByAppendingString:@"/RegisterServlet"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{
        @"email":email,
        @"password":password
    };
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self dictionaryWithJsonString:[responseObject[@"data"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
        if(data) {
            User *user = [User new];
            user.userId = ((NSNumber *)[data objectForKey:@"userId"]).integerValue;
            user.userName = (NSString *)[data objectForKey:@"userName"];
            user.email = (NSString *)[data objectForKey:@"email"];
            user.password = (NSString *)[data objectForKey:@"password"];
            user.conpetence = ((NSNumber *)[data objectForKey:@"conpetence"]).integerValue;
            user.ledgerId = ((NSNumber *)[data objectForKey:@"ledgerId"]).integerValue;
            [[LTKAContext shareInstance] setUser:user];
            [[LTKAContext shareInstance] setIsLogIn:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Register_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Register_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

- (void)logInServiceWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSString *urlPrefix = [[LTKAContext shareInstance] urlPrefix];
    NSString *url = [urlPrefix stringByAppendingString:@"/LoginServlet"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = @{
        @"email":email,
        @"password":password
    };
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self dictionaryWithJsonString:[responseObject[@"data"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
        if(data) {
            User *user = [User new];
            user.userId = ((NSNumber *)[data objectForKey:@"userId"]).integerValue;
            user.userName = (NSString *)[data objectForKey:@"userName"];
            user.email = (NSString *)[data objectForKey:@"email"];
            user.password = (NSString *)[data objectForKey:@"password"];
            user.conpetence = ((NSNumber *)[data objectForKey:@"conpetence"]).integerValue;
            user.ledgerId = ((NSNumber *)[data objectForKey:@"ledgerId"]).integerValue;
            [[LTKAContext shareInstance] setUser:user];
            [[LTKAContext shareInstance] setIsLogIn:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Log_In_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Log_In_Notification object:nil userInfo:@{@"code":@(3), @"msg":@"服务器异常"}];
    }];
}

@end

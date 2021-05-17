//
//  HttpService.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import "HttpService.h"
#import "LTKAContext.h"
#import "TimeGetter.h"

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

- (id)decodeJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                             error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObj;
}

- (void)updateUserInfo {
    User *user = [LTKAContext shareInstance].user;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:user.userId forKey:@"userId"];
    [userDefault setObject:user.userName forKey:@"userName"];
    [userDefault setObject:user.email forKey:@"email"];
    [userDefault setObject:user.password forKey:@"password"];
    [userDefault setInteger:user.conpetence forKey:@"conpetence"];
    [userDefault setInteger:user.ledgerId forKey:@"ledgerId"];
    [userDefault synchronize];
}

#pragma mark - 通用post模板
- (void)basePostServiceWithParams:(NSDictionary *)params andAppendingUrl:(NSString *)appendingUrl andSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success andFailure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    NSString *urlPrefix = [[LTKAContext shareInstance] urlPrefix];
    NSString *url = [urlPrefix stringByAppendingString:appendingUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:params headers:nil progress:nil success:success failure:failure];
}

#pragma mark - 注册
- (void)registerServiceWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *params = @{
        @"email":email,
        @"password":password
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/RegisterServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self decodeJsonString:responseObject[@"data"]];
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
            [self updateUserInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Register_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Register_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 登录
- (void)logInServiceWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *params = @{
        @"email":email,
        @"password":password
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/LoginServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self decodeJsonString:responseObject[@"data"]];
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
            [self updateUserInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Log_In_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Log_In_Notification object:nil userInfo:@{@"code":@(3), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 引用上下文信息修改用户信息
- (void)ModifyUserService {
    User *user = [[LTKAContext shareInstance] user];
    NSDictionary *params = @{
        @"userId":@(user.userId),
        @"userName":user.userName,
        @"email":user.email,
        @"password":user.password,
        @"conpetence":@(user.conpetence),
        @"ledgerId":@(user.ledgerId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/ModifyUserServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        [self updateUserInfo];
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Modify_User_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Modify_User_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 创建账本
- (void)createLedgerServiceWithbelongUserId:(NSInteger)belongUserId {
    NSDictionary *params = @{
        @"serialCode":[NSString stringWithFormat:@"%@_%ld", [[TimeGetter shareInstance] currentDateStrWithDateFormat:@"YYYYMMddhhmmss"], (long)belongUserId],
        @"belongUserId":@(belongUserId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/CreateLedgerServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self decodeJsonString:responseObject[@"data"]];
        if(data) {
            User *user = [[LTKAContext shareInstance] user];
            user.conpetence = ConpetenceType_creator;
            user.ledgerId = ((NSNumber *)[data objectForKey:@"ledgerId"]).integerValue;
            [[LTKAContext shareInstance] setUser:user];
            [self updateUserInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Create_Ledger_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Create_Ledger_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 查询账本序列号
- (void)checkSerialCodeServiceWithLedgerId:(NSInteger)ledgerId {
    NSDictionary *params = @{
        @"ledgerId":@(ledgerId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/CheckSerialCodeServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self decodeJsonString:responseObject[@"data"]];
        NSString *serialCode = nil;
        if(data) {
            serialCode = (NSString *)[data objectForKey:@"serialCode"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Check_Serial_Code_Notification object:nil userInfo:@{@"code":code, @"msg":msg, @"serialCode":serialCode}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Check_Serial_Code_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 加入账本
- (void)joinLedgerServiceWithSerialCode:(NSString *)serialCode andUserId:(NSInteger)userId {
    NSDictionary *params = @{
        @"serialCode":serialCode,
        @"userId":@(userId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/JoinLedgerServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSDictionary *data = [self decodeJsonString:responseObject[@"data"]];
        if(data) {
            User *user = [[LTKAContext shareInstance] user];
            NSInteger belongUserId = ((NSNumber *)[data objectForKey:@"belongUserId"]).integerValue;
            user.conpetence = belongUserId == user.userId ? ConpetenceType_creator : ConpetenceType_partner;
            user.ledgerId = ((NSNumber *)[data objectForKey:@"ledgerId"]).integerValue;
            [[LTKAContext shareInstance] setUser:user];
            [self updateUserInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Join_Ledger_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Join_Ledger_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 退出账本
- (void)quiteLedgerServiceWithLedgerId:(NSInteger)ledgerId andUserId:(NSInteger)userId {
    NSDictionary *params = @{
        @"ledgerId":@(ledgerId),
        @"userId":@(userId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/QuiteLedgerServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        if(code.integerValue == 0) {
            [LTKAContext shareInstance].user.conpetence = ConpetenceType_nil;
            [self updateUserInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Quite_Ledger_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Quite_Ledger_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 删除账本
- (void)deleteLedgerServiceWithLedgerId:(NSInteger)ledgerId andUserId:(NSInteger)userId {
    NSDictionary *params = @{
        @"ledgerId":@(ledgerId),
        @"userId":@(userId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/DeleteLedgerServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        if(code.integerValue == 0) {
            [LTKAContext shareInstance].user.conpetence = ConpetenceType_nil;
            [self updateUserInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Delete_Ledger_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Delete_Ledger_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 获取账单列表
- (void)getLedgerArrayServiceWithLedgerId:(NSInteger)ledgerId andCompletedBlock:(void (^)(NSInteger code, NSString *msg, NSArray<Bill *> *ledgerArray))completedBlock {
    NSDictionary *params = @{
        @"ledgerId":@(ledgerId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/GetLedgerArrayServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSArray *jsonData = [self decodeJsonString:responseObject[@"data"]];
        NSMutableArray<Bill *> *data = [NSMutableArray array];
        if(jsonData != nil) {
            for(NSDictionary *dict in jsonData) {
                Bill *bill = [[Bill alloc] initWithDictionary:dict];
                [data addObject:bill];
            }
        }
        completedBlock(code.integerValue, msg, data);
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        completedBlock(2, @"服务器异常", nil);
    }];
}

#pragma mark - 添加账单
- (void)addBillServiceWithBill:(Bill *)bill {
    NSDictionary *params = @{
        @"belong":bill.belong,
        @"details":bill.details,
        @"money":bill.money,
        @"billType":@(bill.billType),
        @"billConcreteType":@(bill.billConcreteType),
        @"billFlowType":@(bill.billFlowType),
        @"createTime":bill.createTime,
        @"realTime":bill.realTime,
        @"ledgerId":@([[LTKAContext shareInstance] user].ledgerId),
        @"belongUserId":@([[LTKAContext shareInstance] user].userId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/AddBillServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Add_Bill_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Add_Bill_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 删除账单
- (void)deleteBillServiceWithBillId:(NSInteger)billId {
    NSDictionary *params = @{
        @"billId":@(billId)
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/DeleteBillServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Delete_Bill_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Delete_Bill_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 修改账单
- (void)modifyBillServiceWithBill:(Bill *)bill {
    NSDictionary *params = [Bill billToDict:bill];
    [self basePostServiceWithParams:params andAppendingUrl:@"/ModifyBillServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Modify_Bill_Notification object:nil userInfo:@{@"code":code, @"msg":msg}];
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:U_Http_Service_Modify_Bill_Notification object:nil userInfo:@{@"code":@(2), @"msg":@"服务器异常"}];
    }];
}

#pragma mark - 查找账单
- (void)searchBillServiceWithBill:(Bill *)bill andCompletedBlock:(void (^)(NSInteger code, NSString *msg, NSArray<Bill *> *ledgerArray))completedBlock {
    NSDictionary *params = @{
        @"belong":bill.belong,
        @"details":bill.details,
        @"realTime":bill.realTime,
    };
    [self basePostServiceWithParams:params andAppendingUrl:@"/SearchBillServlet" andSuccess:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSArray *jsonData = [self decodeJsonString:responseObject[@"data"]];
        NSMutableArray<Bill *> *data = [NSMutableArray array];
        if(jsonData != nil) {
            for(NSDictionary *dict in jsonData) {
                Bill *bill = [[Bill alloc] initWithDictionary:dict];
                [data addObject:bill];
            }
        }
        completedBlock(code.integerValue, msg, data);
    } andFailure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        completedBlock(2, @"服务器异常", nil);
    }];
}

@end

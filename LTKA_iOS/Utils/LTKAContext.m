//
//  LTKAContext.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import "LTKAContext.h"

@implementation LTKAContext

+ (instancetype)shareInstance {
    static LTKAContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[LTKAContext alloc] init];
    });
    return context;
}

- (User *)user {
    if(_user == nil) {
        _user = [[User alloc] init];
    }
    return _user;
}

- (NSString *)urlPrefix {
    return @"http://192.168.31.103:8080/LTKAServer";
}

@end

//
//  HttpService.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpService : NSObject

+ (instancetype)shareInstance;

- (void)registerServiceWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)logInServiceWithEmail:(NSString *)email andPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END

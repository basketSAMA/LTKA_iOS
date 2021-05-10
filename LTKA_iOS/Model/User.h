//
//  User.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ConpetenceType_nil,         // 没有账本
    ConpetenceType_creator,     // 当前账本的创建人
    ConpetenceType_partner,     // 当前账本的参与人
} ConpetenceType; // 权限类型

@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) ConpetenceType conpetence;
@property (nonatomic, assign) NSInteger ledgerId;

@end

NS_ASSUME_NONNULL_END

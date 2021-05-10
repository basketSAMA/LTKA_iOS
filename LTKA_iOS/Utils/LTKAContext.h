//
//  LTKAContext.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import <Foundation/Foundation.h>

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

#define U_Http_Service_Register_Notification @"UtilHttpServiceRegisterNotification"
#define U_Http_Service_Log_In_Notification @"MineLogInNotification"

#define M_Log_Out_Notification @"MineLogOutNotification"

@interface LTKAContext : NSObject

@property (nonatomic, assign) Boolean isLogIn;
@property (nonatomic, strong) User *user;
@property (nonatomic, readonly) NSString *urlPrefix;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END

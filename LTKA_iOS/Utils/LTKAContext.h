//
//  LTKAContext.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

#define U_Http_Service_Register_Notification @"UtilHttpServiceRegisterNotification"
#define U_Http_Service_Log_In_Notification @"UtilHttpServiceLogInNotification"
#define U_Http_Service_Modify_User_Notification @"UtilHttpServiceModifyUserNotification"

#define U_Http_Service_Create_Ledger_Notification @"UtilHttpServiceCreateLedgerNotification"
#define U_Http_Service_Check_Serial_Code_Notification @"UtilHttpServiceCheckSerialCodeNotification"
#define U_Http_Service_Delete_Ledger_Notification @"UtilHttpServiceDeleteLedgerNotification"
#define U_Http_Service_Join_Ledger_Notification @"UtilHttpServiceJoinLedgerNotification"
#define U_Http_Service_Quite_Ledger_Notification @"UtilHttpServiceQuiteLedgerNotification"

#define U_Http_Service_Add_Bill_Notification @"UtilHttpServiceAddBillNotification"
#define U_Http_Service_Modify_Bill_Notification @"UtilHttpServiceModifyBillNotification"
#define U_Http_Service_Delete_Bill_Notification @"UtilHttpServiceDeleteBillNotification"

#define M_Log_Out_Notification @"MineLogOutNotification"

#define KA_Request_Data_Notification @"KeepAccountsRequestDataNotification"

@interface LTKAContext : NSObject

@property (nonatomic, assign) Boolean isLogIn;
@property (nonatomic, strong) User *user;
@property (nonatomic, readonly) NSString *urlPrefix;
@property (nonatomic, assign) CGRect screenFrame;
@property (nonatomic, assign) CGFloat toastY;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END

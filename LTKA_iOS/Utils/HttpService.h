//
//  HttpService.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/8.
//

#import <Foundation/Foundation.h>

#import "Bill.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpService : NSObject

+ (instancetype)shareInstance;

- (void)registerServiceWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)logInServiceWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)ModifyUserService;

- (void)createLedgerServiceWithbelongUserId:(NSInteger)belongUserId;
- (void)checkSerialCodeServiceWithLedgerId:(NSInteger)ledgerId;
- (void)joinLedgerServiceWithSerialCode:(NSString *)serialCode andUserId:(NSInteger)userId;
- (void)quiteLedgerServiceWithLedgerId:(NSInteger)ledgerId andUserId:(NSInteger)userId;
- (void)deleteLedgerServiceWithLedgerId:(NSInteger)ledgerId andUserId:(NSInteger)userId;

- (void)getLedgerArrayServiceWithLedgerId:(NSInteger)ledgerId andCompletedBlock:(void (^)(NSInteger code, NSString *msg, NSArray<Bill *> *ledgerArray))completedBlock;

- (void)addBillServiceWithBill:(Bill *)bill;
- (void)deleteBillServiceWithBillId:(NSInteger)billId;
- (void)modifyBillServiceWithBill:(Bill *)bill;
- (void)searchBillServiceWithBill:(Bill *)bill andCompletedBlock:(void (^)(NSInteger code, NSString *msg, NSArray<Bill *> *ledgerArray))completedBlock;

@end

NS_ASSUME_NONNULL_END

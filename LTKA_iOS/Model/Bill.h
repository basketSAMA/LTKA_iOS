//
//  Bill.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BillType_income,            // 收入
    BillType_expenditure,       // 支出
} BillType; // 账单类型

typedef enum : NSUInteger {
    BillConcreteType_eating,        // 待定
    BillConcreteType_dressing,
} BillConcreteType; // 账单具体类型

typedef enum : NSUInteger {
    BillFlowType_cash,      // 现金
    BillFlowType_alipay,    // 支付宝
} BillFlowType; // 出入帐方式

@interface Bill : NSObject

@property (nonatomic, assign) NSInteger billId;
@property (nonatomic, strong) NSString *belong;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, copy) NSString *createTime;   // @"YYYY-MM-dd hh:mm"
@property (nonatomic, strong) NSString *realTime;   // @"YYYY-MM-dd hh:mm"
@property (nonatomic, strong) NSString *money;
@property (nonatomic, assign) BillType billType;
@property (nonatomic, assign) BillConcreteType billConcreteType;
@property (nonatomic, assign) BillFlowType billFlowType;

- (Bill *)initWithBelong:(NSString *)belong andDetails:(NSString *)details andRealTime:(nullable NSString *)realTime andMoney:(NSString *)money andBillType:(BillType)billType andBillConcreteType:(BillConcreteType)billConcreteType andBillFlowType:(BillFlowType)billFlowType;

@end

NS_ASSUME_NONNULL_END

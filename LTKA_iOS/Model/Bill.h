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

// @[@"食物", @"衣服", @"住宿", @"旅行", @"红包", @"工资", @"奖金", @"人情", @"医疗", @"教学", @"娱乐", @"杂物", @"健康"]
typedef enum : NSUInteger {
    BillConcreteType_eating,
    BillConcreteType_dressing,
    BillConcreteType_staying,
    BillConcreteType_travelling,
    BillConcreteType_hongbao,
    BillConcreteType_wages,
    BillConcreteType_bonus,
    BillConcreteType_favor,
    BillConcreteType_medical,
    BillConcreteType_teaching,
    BillConcreteType_entertainment,
    BillConcreteType_sundries,
    BillConcreteType_health
} BillConcreteType; // 账单具体类型

// @[@"现金", @"支付宝", @"微信", @"网银"]
typedef enum : NSUInteger {
    BillFlowType_cash,
    BillFlowType_alipay,
    BillFlowType_wechat,
    BillFlowType_onlinebanking
} BillFlowType; // 出入帐方式

@interface Bill : NSObject

@property (nonatomic, assign) NSInteger billId;
@property (nonatomic, strong) NSString *belong;
@property (nonatomic, assign) NSInteger belongUserId;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, copy) NSString *createTime;   // @"YYYY-MM-dd hh:mm"
@property (nonatomic, strong) NSString *realTime;   // @"YYYY-MM-dd hh:mm"
@property (nonatomic, strong) NSString *money;
@property (nonatomic, assign) BillType billType;
@property (nonatomic, assign) BillConcreteType billConcreteType;
@property (nonatomic, assign) BillFlowType billFlowType;

- (instancetype)initWithBelong:(NSString *)belong andBelongUserId:(NSInteger)belongUserId andDetails:(NSString *)details andRealTime:(nullable NSString *)realTime andMoney:(NSString *)money andBillType:(BillType)billType andBillConcreteType:(BillConcreteType)billConcreteType andBillFlowType:(BillFlowType)billFlowType;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (NSDictionary *)billToDict:(Bill *)bill;

@end

NS_ASSUME_NONNULL_END

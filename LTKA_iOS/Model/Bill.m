//
//  Bill.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/26.
//

#import "Bill.h"
#import "TimeGetter.h"

@interface Bill ()

@end

@implementation Bill

- (instancetype)initWithBelong:(NSString *)belong andBelongUserId:(NSInteger)belongUserId andDetails:(NSString *)details andRealTime:(nullable NSString *)realTime andMoney:(NSString *)money andBillType:(BillType)billType andBillConcreteType:(BillConcreteType)billConcreteType andBillFlowType:(BillFlowType)billFlowType {
    if(self=[super init]){
        _belong = belong;
        _belongUserId = belongUserId;
        _details = details;
        _createTime = [[TimeGetter shareInstance] currentDateStrWithDateFormat:@"YYYY-MM-dd hh:mm"];
        _realTime = realTime ?: [[TimeGetter shareInstance] currentDateStrWithDateFormat:@"YYYY-MM-dd hh:mm"];
        _money = money;
        _billType = billType;
        _billConcreteType = billConcreteType;
        _billFlowType = billFlowType;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.billId = ((NSNumber *)dict[@"billId"]).integerValue;
        self.belong = dict[@"belong"];
        self.belongUserId = ((NSNumber *)dict[@"belongUserId"]).integerValue;
        self.details = dict[@"details"];
        self.createTime = dict[@"createTime"];
        self.realTime = dict[@"realTime"];
        self.money = dict[@"money"];
        self.billType = ((NSNumber *)dict[@"billType"]).integerValue;
        self.billConcreteType = ((NSNumber *)dict[@"billConcreteType"]).integerValue;
        self.billFlowType = ((NSNumber *)dict[@"billFlowType"]).integerValue;
    }
    return self;
}

+ (NSDictionary *)billToDict:(Bill *)bill {
    NSDictionary *dict = @{
        @"billId":@(bill.billId),
        @"belong":bill.belong,
        @"belongUserId":@(bill.belongUserId),
        @"details":bill.details,
        @"money":bill.money,
        @"billType":@(bill.billType),
        @"billConcreteType":@(bill.billConcreteType),
        @"billFlowType":@(bill.billFlowType),
        @"createTime":bill.createTime,
        @"realTime":bill.realTime
    };
    return dict;
}

@end

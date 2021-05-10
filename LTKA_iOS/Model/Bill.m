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

- (Bill *)initWithBelong:(NSString *)belong andDetails:(NSString *)details andRealTime:(nullable NSString *)realTime andMoney:(NSString *)money andBillType:(BillType)billType andBillConcreteType:(BillConcreteType)billConcreteType andBillFlowType:(BillFlowType)billFlowType {
    if(self=[super init]){
        _belong = belong;
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

@end

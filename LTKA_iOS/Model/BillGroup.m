//
//  BillGroup.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/4/8.
//

#import "BillGroup.h"
#import "Bill.h"

@implementation BillGroup

- (BillGroup *)initWithDate:(NSString *)date andBills:(NSMutableArray *)bills {
    if (self=[super init]) {
        self.date = date;
        self.bills = bills;
    }
    return self;
}

@end

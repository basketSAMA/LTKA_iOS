//
//  DataArrayGetter.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/4.
//

#import "DataArrayGetter.h"

@implementation DataArrayGetter

+ (instancetype)shareInstance {
    static DataArrayGetter *dag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dag = [[DataArrayGetter alloc] init];
    });
    return dag;
}

- (NSArray *) billTypeArray {
    if(_billTypeArray == nil) {
        _billTypeArray = @[@"收入", @"支出"];
    }
    return _billTypeArray;
}

- (NSArray *) billConcreteTypeArray {
    if(_billConcreteTypeArray == nil) {
        _billConcreteTypeArray = @[@"食物", @"衣服", @"住宿", @"旅行", @"红包", @"工资", @"奖金", @"人情", @"医疗", @"教学", @"娱乐", @"杂物", @"健康"];
    }
    return _billConcreteTypeArray;
}

- (NSArray *) billConcreteTypeImageNameArray {
    if(_billConcreteTypeImageNameArray == nil) {
        _billConcreteTypeImageNameArray = @[@"n-1", @"n-2", @"n-3", @"n-4", @"n-5", @"n-6", @"n-7", @"n-8", @"n-9", @"n-10", @"n-11", @"n-12", @"n-13"];
    }
    return _billConcreteTypeImageNameArray;
}

- (NSArray *) billFlowTypeArray {
    if(_billFlowTypeArray == nil) {
        _billFlowTypeArray = @[@"现金", @"支付宝", @"微信", @"网银"];
    }
    return _billFlowTypeArray;
}

@end

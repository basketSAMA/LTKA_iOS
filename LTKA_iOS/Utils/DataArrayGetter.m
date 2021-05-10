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

- (NSArray *) billConcreteTypeArray {
    if(_billConcreteTypeArray == nil) {
        _billConcreteTypeArray = @[@"食物", @"衣服"];
    }
    return _billConcreteTypeArray;
}

- (NSArray *) billConcreteTypeImageNameArray {
    if(_billConcreteTypeImageNameArray == nil) {
        _billConcreteTypeImageNameArray = @[@"img1", @"img2"];
    }
    return _billConcreteTypeImageNameArray;
}

@end

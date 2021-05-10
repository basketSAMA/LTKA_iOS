//
//  DataArrayGetter.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataArrayGetter : NSObject

@property (nonatomic, strong) NSArray *billConcreteTypeArray;
@property (nonatomic, strong) NSArray *billConcreteTypeImageNameArray;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END

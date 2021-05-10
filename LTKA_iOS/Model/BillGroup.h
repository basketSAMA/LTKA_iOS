//
//  BillGroup.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillGroup : NSObject

@property (nonatomic, copy) NSString *date; // @"YYYY-MM-dd"
@property (nonatomic, strong) NSMutableArray *bills;

- (BillGroup *)initWithDate:(NSString *)date andBills:(NSMutableArray *)bills;

@end

NS_ASSUME_NONNULL_END

//
//  TimeGetter.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeGetter : NSObject

+ (instancetype)shareInstance;

// 获取当前时间
- (NSString *)currentDateStrWithDateFormat:(NSString *)format;
// 获取时间
- (NSString *)dateStrWithDateFormat:(NSString *)format andDate:(NSDate *)date;
// 获取当前时间戳
- (NSString *)currentTimeStr;
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str andDateFormat:(NSString *)format;
// 字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END

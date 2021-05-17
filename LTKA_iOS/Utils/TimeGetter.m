//
//  TimeGetter.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/4/8.
//

#import "TimeGetter.h"

@implementation TimeGetter

+ (instancetype)shareInstance {
    static TimeGetter *tg;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tg = [[TimeGetter alloc] init];
    });
    return tg;
}

// 获取当前时间
- (NSString *)currentDateStrWithDateFormat:(NSString *)format {
    if (format == nil) format = @"YYYY-MM-dd hh:mm:ss";
    NSDate *currentDate = [NSDate date];// 获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:format];// 设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];// 将时间转化成字符串
    return dateString;
}

// 获取时间
- (NSString *)dateStrWithDateFormat:(NSString *)format andDate:(NSDate *)date {
    if (format == nil) format = @"YYYY-MM-dd hh:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:format];// 设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:date];// 将时间转化成字符串
    return dateString;
}

// 获取当前时间戳
- (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];// 获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str andDateFormat:(NSString *)format {
    if (format == nil) format = @"YYYY-MM-dd hh:mm:ss";
    NSTimeInterval time=[str doubleValue]/1000;// 传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

// 字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"]; // 设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];// 将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];// 字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

@end

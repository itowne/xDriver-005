//
//  DateUtil.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/8.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)getCurrentDate{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)getDateByString:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter dateFromString:dateStr];
}

/**
 * 用固定格式格式化成Date类型
 **/
+ (NSDate *) getDateyString:(NSString *)dateStr withFormatter:(NSString *)dateFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    return [formatter dateFromString:dateStr];
}

+ (NSString *)getStringByDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

/**
 * 是否是同一天， 单单指是否是同一天
 **/
+ (BOOL) isSameDay:(NSDate *)fromDate withDate:(NSDate *)toDate {
    NSDateComponents *fromComp = [self getDateComponentByDate:fromDate];
    NSDateComponents *toComp = [self getDateComponentByDate:toDate];
    
    if (fromComp.year == toComp.year && fromComp.month == toComp.month && fromComp.day == toComp.day) {
        return YES;
    }
    return NO;
}

+ (NSDateComponents *)getDateComponentByDate:(NSDate *)date{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
    | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    return [cal components:unitFlags fromDate:date];
}

/**
 * 获取单天的日期
 **/
+ (NSString *) getDayStringByDate:(NSDate *)date {
    NSDateComponents *comp = [self getDateComponentByDate:date];
    return [NSString stringWithFormat:@"%ld-%ld-%ld", comp.year, comp.month, comp.day];
}

/**
 * 获取星期几
 **/
+ (NSString *) getWeekByDate:(NSDate *)date{
    NSDateComponents *comp = [self getDateComponentByDate:date];
//    NSLog(@"weekday is %ld", comp.weekday);
    switch (comp.weekday) {
        case 1:
            return @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"获取失败";
    }
}

+ (double) currentTimeIntervalFrom1970{
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

@end

//
//  DateUtil.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/8.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *) getCurrentDate;

/**
 * 根据时间字符串转成NSDate类型
 **/
+ (NSDate *) getDateByString:(NSString *)dateStr;

/**
 * 用固定格式格式化成Date类型
 **/
+ (NSDate *) getDateyString:(NSString *)dateStr withFormatter:(NSString *)dateFormatter;

/**
 * 从字符串获取时间
 **/
+ (NSString *) getStringByDate:(NSDate *)date;

/**
 * 是否是同一天， 单单指是否是同一天
 **/
+ (BOOL) isSameDay:(NSDate *)fromDate withDate:(NSDate *)toDate;

/**
 * 获取单天的日期
 **/
+ (NSString *) getDayStringByDate:(NSDate *)date;

/**
 * 获取星期几
 **/
+ (NSString *) getWeekByDate:(NSDate *)date;

+ (double) currentTimeIntervalFrom1970;

@end

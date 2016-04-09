//
//  MileSql.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/13.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MileModel;

@interface MileSql : NSObject

/**
 * 保存数据
 **/
+ (BOOL) saveMileModel:(MileModel *)mileModel;

/**
 * 查询全部数据
 **/
+(NSMutableArray *)miles;

/**
 * 查询单个数据
 **/
+ (MileModel *)selectMileModel:(NSInteger) mileId;

/**
 * 删除数据, 需要传入mileId
 **/
+ (void) deleteMileModel:(NSInteger) mileId;

/**
 * 修改数据
 **/
+ (void) updateMileModel:(MileModel *)mileModel;

/**
 * 将数据按日分组，
 **/
+ (NSMutableArray *) selectMilesByDayGroup;

/**
 * 按天统计公里数
 **/
+ (NSDictionary *) groupByDay;

@end

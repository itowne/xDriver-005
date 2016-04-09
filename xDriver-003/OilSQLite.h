//
//  OilSQLite.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/14.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OilModel;

@interface OilSQLite : NSObject

/**
 * 保存数据
 **/
+ (BOOL) saveOilModel:(OilModel *)oilModel;

/**
 * 查询全部数据
 **/
+(NSMutableArray *)oils;

/**
 * 查询单个数据
 **/
+ (OilModel *)selectOilModel:(NSInteger) oilId;

/**
 * 删除数据, 需要传入mileId
 **/
+ (void) deleteOilModel:(NSInteger) oilId;

/**
 * 修改数据
 **/
+ (void) updateOilModel:(OilModel *)oilModel;

@end

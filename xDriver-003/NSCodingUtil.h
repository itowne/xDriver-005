//
//  NSCodingUtil.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/9.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MileModel, OilModel;
@interface NSCodingUtil : NSObject

/**
 * 新增MileModel
 **/
//+ (void)saveMileModels:(NSMutableArray *)miles;
//+ (NSMutableArray *)selectMileModels;

/**
 * 新增OilModel
 **/
//+ (void)saveOilModels:(NSMutableArray *)oils;
//+ (NSMutableArray *)selectOilModels;

/**
 * 是否正在行驶
 **/
+ (BOOL) isOnDriving;

+(void) setIsOnDriving:(BOOL)isOnDriving;

+(MileModel *)isOnDrivingMileModel;
+(void)setIsOnDrivingMileModel:(MileModel *)mileModel;

@end

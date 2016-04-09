//
//  NSCodingUtil.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/9.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "NSCodingUtil.h"
#import "CommonUtil.h"
#import "MileModel.h"

@implementation NSCodingUtil

/**
 * 保存MileModel数据
 **/
//+ (void)saveMileModels:(NSMutableArray *)miles{
//    NSLog(@"saveMileModels");
//    [NSKeyedArchiver archiveRootObject:miles toFile:[CommonUtil getMileDataFilePath]];
//}
//+ (NSMutableArray *)selectMileModels{
//    NSLog(@"selectMileModels");
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:[CommonUtil getMileDataFilePath]];
//}

/**
 * OilModel
 **/
+ (void)saveOilModels:(NSMutableArray *)oils{
    [NSKeyedArchiver archiveRootObject:oils toFile:[CommonUtil getOilDataFilePath]];
}

+ (NSMutableArray *)selectOilModels{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[CommonUtil getOilDataFilePath]];
}

+ (BOOL)isOnDriving{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isOnDriving"];
}

+ (void)setIsOnDriving:(BOOL)isOnDriving{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isOnDriving forKey:@"isOnDriving"];
}

+ (MileModel *)isOnDrivingMileModel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //获取数据
    NSString *startMile = [defaults stringForKey:@"startMile"];
    NSString *startTime = [defaults stringForKey:@"startTime"];
    
    //设置MileModel
    MileModel *mile = [[MileModel alloc]init];
    mile.startMile = startMile;
    mile.startTime = startTime;
    
    return mile;
}

+ (void)setIsOnDrivingMileModel:(MileModel *)mileModel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存数据
    [defaults setValue:mileModel.startMile forKey:@"startMile"];
    [defaults setValue:mileModel.startTime forKey:@"startTime"];
}

@end

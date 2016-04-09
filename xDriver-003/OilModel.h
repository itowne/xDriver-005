//
//  OilModel.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OilModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger oilId;//oil唯一标识
@property (copy, nonatomic) NSString *sinceLastDay;//距离上次加油天数
@property (copy, nonatomic) NSString *oilPlace;//加油地点
@property (copy, nonatomic) NSString *oilTime;//加油时间
@property (copy, nonatomic) NSString *oilPrice;//加油金额
@property (copy, nonatomic) NSString *leftMile;//剩余里程数
@property (copy, nonatomic) NSString *currentMile;//本次加油时的里程
@property (copy, nonatomic) NSString *oilMile;//本次加油行驶的公里数



@end

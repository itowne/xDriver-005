//
//  MileModel.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MileModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger mileId;//唯一标识
@property (nonatomic, copy) NSString *startMile;//开始里程
@property (nonatomic, copy) NSString *endMile;//结束里程
@property (nonatomic, copy) NSString *startTime;//开始时间
@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *startAddress;//出发地点
@property (nonatomic, copy) NSString *endAddress;//到达地点
@property (nonatomic, copy) NSString *beginLatitude;//出发地经度
@property (nonatomic, copy) NSString *endLatitude;//目的地经度
@property (nonatomic, copy) NSString *beginLongitude;//出发地纬度
@property (nonatomic, copy) NSString *endLongitude;//目的地纬度

@end

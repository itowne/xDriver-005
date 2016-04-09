//
//  OilModel.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "OilModel.h"

@implementation OilModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.currentMile forKey:@"currentMile"];
    [aCoder encodeObject:self.leftMile forKey:@"leftMile"];
    [aCoder encodeObject:self.oilPrice forKey:@"oilPrice"];
    [aCoder encodeObject:self.oilTime forKey:@"oilTime"];
    [aCoder encodeObject:self.oilPlace forKey:@"oilPlace"];
    [aCoder encodeObject:self.sinceLastDay forKey:@"sinceLastDay"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.currentMile = [aDecoder decodeObjectForKey:@"currentMile"];
        self.leftMile = [aDecoder decodeObjectForKey:@"leftMile"];
        self.oilPrice = [aDecoder decodeObjectForKey:@"oilPrice"];
        self.oilTime = [aDecoder decodeObjectForKey:@"oilTime"];
        self.oilPlace = [aDecoder decodeObjectForKey:@"oilPlace"];
        self.sinceLastDay = [aDecoder decodeObjectForKey:@"sinceLastDay"];
    }
    return self;
}

@end

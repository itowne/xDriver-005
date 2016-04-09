//
//  MileModel.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "MileModel.h"

@implementation MileModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.startMile forKey:@"startMile"];
    [aCoder encodeObject:self.endMile forKey:@"endMile"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.startMile = [aDecoder decodeObjectForKey:@"startMile"];
        self.endMile = [aDecoder decodeObjectForKey:@"endMile"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
    }
    return self;
}

@end

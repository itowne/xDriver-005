//
//  CommonUtil.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/9.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "CommonUtil.h"


@implementation CommonUtil

+ (NSString *)getDocumentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)getMileDataFilePath{
    return [[self getDocumentFilePath] stringByAppendingPathComponent:@"xDriver_mile.data"];
}

+ (NSString *)getOilDataFilePath{
    return [[self getDocumentFilePath] stringByAppendingPathComponent:@"xDriver_oil.data"];
}

@end

//
//  RequestUtil.h
//  xDriver-003
//
//  Created by 林国强 on 15/7/16.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MileModel.h"
#import "OilModel.h"

@interface RequestUtil : NSObject

+(void) saveMileToServer:(MileModel *)model;

+(void) didOilToServer:(OilModel *)model;

@end

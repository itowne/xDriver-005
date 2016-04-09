//
//  CommonUtil.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/9.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (NSString *)getDocumentFilePath;
/**
 * 获取Mile文件路径
 **/
+ (NSString *)getMileDataFilePath;

/**
 * 获取Oil data文件路径
 **/
+ (NSString *)getOilDataFilePath;

@end

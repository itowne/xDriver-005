//
//  OilSQLite.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/14.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "OilSQLite.h"
#import <sqlite3.h>
#import "OilModel.h"

@implementation OilSQLite

static sqlite3 *_db;

+ (void)initialize{
    //获取沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"xDriver.sqlite"];
    
    
    //创建(打开)数据库，如果不存在则自动创建
    int result = sqlite3_open(filename.UTF8String, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        
        //创建表
        const char *sql = "create table t_oil(id integer not null primary key autoincrement, currentMile text, leftMile text, oilPrice text, oilTime  text, oilPlace text, sinceLastDay text);";
        
        char *errorMsg = NULL;
        int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMsg);
        if (result == SQLITE_OK) {
            NSLog(@"成功创建表t_oil");
        }else {
            NSLog(@"创建表失败%s", errorMsg);
        }
    }else {
        NSLog(@"打开数据库失败");
    }
}

/**
 * 保存数据
 **/
+ (BOOL) saveOilModel:(OilModel *)oilModel{
    //insert 语句
    NSString *sql = [NSString stringWithFormat:@"insert into t_oil(currentMile, leftMile, oilPlace, OilPrice, oiltime, sinceLastDay) values('%@','%@','%@','%@','%@','%@');", oilModel.currentMile, oilModel.leftMile, oilModel.oilPlace, oilModel.oilPrice, oilModel.oilTime, oilModel.sinceLastDay];
    //执行
//    char *errorMsg = NULL;
//    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
//    if (result == SQLITE_OK) {
//        NSLog(@"插入数据成功%@", sql);
//        return YES;
//    }else {
//       NSLog(@"插入数据失败%@, 失败原因：%s", sql, errorMsg);
//        return NO;
//    }
    char *errorMsg = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
    if (result != SQLITE_OK) {
        NSLog(@"%@ 插入数据失败, 失败原因：%s", sql, errorMsg);
    }
    return result == SQLITE_OK;
}

/**
 * 查询全部数据
 **/
+(NSMutableArray *)oils{
    //查询语句
    const char *sql = "select id,currentMile, leftMile, oilPlace, OilPrice, oiltime, sinceLastDay from t_oil order by oiltime desc;";
    
    //定义一个数组存放结果
    NSMutableArray *oils = [NSMutableArray array];
    
    //定义一个结果集
    sqlite3_stmt *stmt = NULL;
    
    //预编译
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"执行查询成功%s", sql);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获取单个记录
            OilModel *oil = [[OilModel alloc] init];
            oil.oilId = sqlite3_column_int(stmt, 0);
            oil.currentMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            oil.leftMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            oil.oilPlace = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            oil.oilPrice = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            oil.oilTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            oil.sinceLastDay = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
//            oil.oilMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            [oils addObject:oil];
        }
    }else {
        NSLog(@"执行查询失败%s", sql);
    }
    return oils;
}

/**
 * 查询单个数据
 **/
+ (OilModel *)selectOilModel:(NSInteger) oilId{
    //sql 语句
    NSString *sql = [NSString stringWithFormat:@"select id,currentMile, leftMile, oilPlace, OilPrice, oiltime, sinceLastDay from t_oil where id=%ld;", oilId];
    //返回结果
    OilModel *oil = [[OilModel alloc] init];
    
    //定义一个结果集
    sqlite3_stmt *stmt = NULL;
    
    //预编译
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"执行查询成功%@", sql);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            oil.oilId = sqlite3_column_int(stmt, 0);
            oil.currentMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            oil.leftMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            oil.oilPlace = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            oil.oilPrice = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            oil.oilTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            oil.sinceLastDay = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
        }
    }else {
        NSLog(@"执行查询失败%@", sql);
    }
    return oil;
}

/**
 * 删除数据, 需要传入mileId
 **/
+ (void) deleteOilModel:(NSInteger) oilId{
    //删除语句
    NSString *sql = [NSString stringWithFormat:@"delete from t_oil where id=%ld", oilId];
    
    char *errorMsg = NULL;
    
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
    if (result == SQLITE_OK) {
        NSLog(@"删除%ld成功%@", oilId, sql);
    }else {
        NSLog(@"删除%ld成功%@, 失败原因:%s", oilId, sql, errorMsg);
    }
}


/**
 * 修改数据
 **/
+ (void) updateOilModel:(OilModel *)oilModel{
    //更新语句
    NSString *sql = [NSString stringWithFormat:@"update t_oil set currentMile='%@', leftMile='%@', oilPlace='%@', OilPrice='%@', oiltime='%@', sinceLastDay='%@' where id=%ld;", oilModel.currentMile, oilModel.leftMile, oilModel.oilPlace, oilModel.oilPrice, oilModel.oilTime, oilModel.sinceLastDay, oilModel.oilId];
    
    char *errorMsg = NULL;
    
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
    if (result == SQLITE_OK) {
        NSLog(@"更新%ld成功%@", oilModel.oilId, sql);
    }else {
        NSLog(@"更新%ld成功%@, 失败原因:%s", oilModel.oilId, sql, errorMsg);
    }
}

@end

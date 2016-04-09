//
//  MileSql.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/13.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "MileSql.h"
#import <sqlite3.h>
#import "MileModel.h"
#import "DateUtil.h"
#import "RequestUtil.h"

@implementation MileSql

// static的作用：能保证_db这个变量只被IWStudentTool.m直接访问
static sqlite3 *_db;

+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"xDriver.sqlite"];
    
    // 1.创建(打开)数据库（如果数据库文件不存在，会自动创建）
    int result = sqlite3_open(filename.UTF8String, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"成功打开数据库");
        
        // 2.创表
        const char *sql = "CREATE TABLE t_mile( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,start_time text NOT NULL,end_time text NOT NULL,start_mile text NOT NULL,end_mile text NOT NULL,begin_address text,end_address text,begin_latitude text,begin_longitude text,end_latitude text,end_longitude text);";
        
//        sql = "drop table t_mile";
        
        char *errorMesg = NULL;
        int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMesg);
        if (result == SQLITE_OK) {
            NSLog(@"成功创建t_mile表");
        } else {
            NSLog(@"创建t_mile表失败:%s", errorMesg);
        }
    } else {
        NSLog(@"打开数据库失败");
    }
}

/**
 * 创建模型
 **/
+ (BOOL) saveMileModel:(MileModel *)mileModel{
    NSString *insertSql = [NSString stringWithFormat:@"insert into t_mile(start_time, end_time,start_mile,end_mile,begin_address,end_address,begin_latitude,begin_longitude,end_latitude,end_longitude) values('%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@');", mileModel.startTime, mileModel.endTime, mileModel.startMile, mileModel.endMile,mileModel.startAddress, mileModel.endAddress,mileModel.beginLatitude, mileModel.beginLongitude, mileModel.endLatitude, mileModel.endLongitude];
    
    char *errorMsg = NULL;
    int result = sqlite3_exec(_db, insertSql.UTF8String, NULL, NULL, &errorMsg);
    if (result != SQLITE_OK) {
        NSLog(@"%@ 插入数据失败, 失败原因：%s", insertSql, errorMsg);
    }else {
        [RequestUtil saveMileToServer:mileModel];
    }
    return result == SQLITE_OK;
}

+(NSMutableArray *)miles{
    //定义数组
    NSMutableArray *miles = [NSMutableArray array];
    
    //查询语句
    const char *sql = "select id, start_time, end_time, start_mile, end_mile, begin_address,begin_address,begin_latitude,begin_longitude,end_latitude,end_longitude from t_mile order by start_time desc;";
    
    //定义一个stmt存放结果集
    sqlite3_stmt *stmt = NULL;
    //检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"%s查询语句是合法的", sql);
        
        //执行SQL语句，从结果集中取出结果
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获取该行数据，新增对象MileModel， 并赋值
            MileModel *mile = [[MileModel alloc] init];
            
            mile.mileId = sqlite3_column_int(stmt, 0);
            mile.startTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            mile.endTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            mile.startMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            mile.endMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            mile.startAddress = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            mile.endAddress = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            mile.beginLatitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            mile.beginLongitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            mile.endLatitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            mile.endLongitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
            
            [miles addObject:mile];
        }
    }else {
        NSLog(@"%s查询语句非法", sql);
    }
    return miles;
}

+ (MileModel *)selectMileModel:(NSInteger)mileId{
    //定义SQL语句
    NSString *sql = [NSString stringWithFormat:@"select id,start_time, end_time, start_mile, end_mile, begin_address,begin_address,begin_latitude,begin_longitude,end_latitude,end_longitude from t_mile where id=%ld;", mileId];
    
    //定义一个返回的MileModel
    MileModel *mile = [[MileModel alloc] init];
    
    //定义一个结果集
    sqlite3_stmt *stmt = NULL;
    
    //预编译
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            mile.mileId = sqlite3_column_int(stmt, 0);
            mile.startTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            mile.endTime = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            mile.startMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            mile.endMile = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            mile.startAddress = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            mile.endAddress = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            mile.beginLatitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            mile.beginLongitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            mile.endLatitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            mile.endLongitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
        }
    }else {
        NSLog(@"SQL语句不合法");
    }
    return mile;
    
}

/**
 * 删除数据, 需要传入mileId
 **/
+ (void)deleteMileModel:(NSInteger)mileId{
    //删除的SQL语句
    NSString *sql = [NSString stringWithFormat:@"delete from t_mile where id=%ld;", mileId];
    
    char *errorMsg = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
    if (result != SQLITE_OK) {
        NSLog(@"删除%ld失败", mileId);
    }
}

/**
 * 修改数据
 **/
+ (void)updateMileModel:(MileModel *)mileModel{
    //update sql 语句
    NSString *sql = [NSString stringWithFormat:@"update t_mile set start_time='%@', end_time='%@',start_mile='%@',end_mile='%@',begin_address='%@',begin_address='%@',begin_latitude='%@',begin_longitude='%@',end_latitude='%@',end_longitude='%@' where id=%ld;", mileModel.startTime, mileModel.endTime, mileModel.startMile, mileModel.endMile,mileModel.startAddress, mileModel.endAddress,mileModel.beginLatitude, mileModel.beginLongitude, mileModel.endLatitude, mileModel.endLongitude,mileModel.mileId];
    
    char *errorMsg = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg);
    if (result == SQLITE_OK) {
        NSLog(@"更新%ld成功,%@", mileModel.mileId, sql);
    }else {
        NSLog(@"更新%ld失败,%@,失败原因:%s", mileModel.mileId, sql, errorMsg);
    }
}

+ (NSMutableArray *) selectMilesByDayGroup{
    NSLog(@"***************selectMilesByDayGroup*********************");
    NSMutableArray *reArray = [NSMutableArray array];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *totalMiles = [self miles];
    
    //遍历每条数据，按天进行分组
    NSDate *lastDate = nil;//记录上一条记录的日期
    NSMutableArray *days = [NSMutableArray array];
    for (int i = 0; i < totalMiles.count; i++) {
        MileModel *mile = totalMiles[i];
        //定义时间格式器类
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        //将记录的日期转成date类型
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [formatter1 dateFromString:mile.startTime];
        if (lastDate == nil) {
            //第一个分组，加入
            [days addObject:mile];
        }else {//上一组的时间不为空，则进行判断
            if ([DateUtil isSameDay:date withDate:lastDate]) {
                //如果是同一天，加入到现有的分组
                [days addObject:mile];
            }else {
                //不是同一天，说明是新的分组开始
                //将这一天的数据加入到字典中
                [dict setObject:days forKey:[DateUtil getDayStringByDate:lastDate]];
                [reArray addObject:dict];
                
                //重置中间变量
                days = nil;
                days = [NSMutableArray array];
                dict = nil;
                dict = [[NSMutableDictionary alloc] init];
                
                //将最新的这个MileModel加入
                [days addObject:mile];
            }
            //判断当前是不是最后一个数据，如果是，则直接加入字典
            if (i == (totalMiles.count-1)) {
                [dict setObject:days forKey:[DateUtil getDayStringByDate:date]];
                [reArray addObject:dict];
            }
        }
        //将当前的日期赋值给前一个保存的日期
        lastDate = date;
    }
    return reArray;
}

/**
 * 按天统计公里数
 **/
+ (NSDictionary *) groupByDay{
    NSMutableArray *groupMile = [self selectMilesByDayGroup];
    NSMutableDictionary *groupByDay = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in groupMile) {
        NSArray *array = nil;
        NSString *day = nil;
        for (NSString *key in dict) {
            day = key;
            array = [dict objectForKey:key];
        }
        int totalMile = 0;
        for (MileModel *mile in array) {
            totalMile += ([mile.endMile intValue] - [mile.startMile intValue]);
        }
        [groupByDay setObject:[NSString stringWithFormat:@"%d", totalMile] forKey:day];
    }
    return groupByDay;
}

@end

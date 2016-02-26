//
//  WeatherTool.m
//  SimpleWeather
//
//  Created by SilentWalker on 16/2/22.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "WeatherTool.h"
static sqlite3 *_db;
@implementation WeatherTool
/**
 *  重载初始化，建立数据库与表
 */
+ (void)initialize
{
    //拼接SQL语句，创建数据库
    NSString *cachepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fullpath = [cachepath stringByAppendingPathComponent:@"weather.sqlite"];
//    NSLog(@"%@",fullpath);
    const char *path = fullpath.UTF8String;
    if (sqlite3_open(path, &_db) == SQLITE_OK) {
        //NSLog(@"打开数据库成功");
        //创建表
        //拼接sql语句,执行
        NSString *creatTable = @"CREATE TABLE IF NOT EXISTS t_weather (id integer PRIMARY KEY NOT NULL, weatherdic blob); ";
        char *errorMsg = NULL;
        if (sqlite3_exec(_db, creatTable.UTF8String, NULL, NULL, &errorMsg) == SQLITE_OK) {
            //NSLog(@"创建成功");
        }else{
            //NSLog(@"创建失败--%s--%d",errorMsg,__LINE__);
        }
        
    }else{
        //NSLog(@"打开数据库失败");
    }
    
}
/**
 *  保存数据，若weatherdic为空则建立仅id记录
 *
 *  @param cityid     id
 *  @param weatherdic NSDictionary
 */
+ (void)saveWeatherData:(NSInteger)cityid :(NSDictionary *)weatherdic
{
   if (weatherdic) {
       //反解析JSON，绑定blob实现插入
       NSData *data = [NSJSONSerialization dataWithJSONObject:weatherdic options:NSJSONWritingPrettyPrinted error:nil];
       NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_weather VALUES (%ld,?);",cityid];
       sqlite3_stmt *savestmt;
       if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &savestmt, NULL) == SQLITE_OK) {
           sqlite3_bind_blob(savestmt, 1, [data bytes], (int)[data length], NULL);
           if (sqlite3_step(savestmt) == SQLITE_DONE) {
               //NSLog(@"保存成功");
           }
           sqlite3_finalize(savestmt);
       } else {
           //NSLog(@"保存失败");
       }

    } else {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_weather (id) VALUES (%ld);",cityid];
        sqlite3_stmt *savestmt;
        if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &savestmt, NULL) == SQLITE_OK) {
            if (sqlite3_step(savestmt) == SQLITE_DONE) {
                //NSLog(@"保存成功");
            }
            sqlite3_finalize(savestmt);
        } else {
            //NSLog(@"保存失败");
        }

    }
}

+ (NSMutableArray *)queryWeatherData
{
    NSMutableArray *cityinfo = [NSMutableArray array];
    const char *sql = "SELECT weatherdic FROM t_weather;";
    sqlite3_stmt *stmt;
    //准备查询
    if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        //NSLog(@"查询成功");
        //stmt步进
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //取出位于第0列存储的blob长度
            int length = sqlite3_column_bytes(stmt, 0);
            //取出位于第0列存储的blob数据
            const void *bytes = sqlite3_column_blob(stmt, 0);
            //重新组合为NSData
            NSData *data = [[NSData alloc]initWithBytes:bytes length:length];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            if (dic) {
                [cityinfo addObject:dic];
            }else{break;}
            
        }
        
    } else {
        //NSLog(@"查询失败");
    }
    return cityinfo;
}

+ (void)deleteWeatherData:(NSInteger)cityid
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_weather WHERE id = %ld;",cityid];
    char *errorMsg = NULL;
    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg) == SQLITE_OK) {
        //NSLog(@"删除成功");
    } else {
        //NSLog(@"删除失败--%s--%d",errorMsg,__LINE__);
    }
}

+ (void)updateWeatherData:(NSInteger)cityid :(NSDictionary *)weatherdic
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_weather SET weatherdic = ? WHERE id = %ld;",cityid];
    sqlite3_stmt *stmt;
    NSData *data = [NSJSONSerialization dataWithJSONObject:weatherdic options:NSJSONWritingPrettyPrinted error:nil];
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_blob(stmt, 1, [data bytes], (int)[data length], NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            //NSLog(@"更新成功");
        }
    }
    else {
        //NSLog(@"更新失败");
    }

}
+ (void)moveWeatherData:(NSInteger)cityid
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_weather SET id = %ld WHERE id = %ld;",(cityid - 1),cityid];
    sqlite3_stmt *stmt;
 
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_DONE) {
        //NSLog(@"移动成功");
        }
    }
    else {
        //NSLog(@"移动失败");
    }

}
@end

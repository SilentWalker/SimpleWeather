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
    NSLog(@"%@",fullpath);
    const char *path = fullpath.UTF8String;
    if (sqlite3_open(path, &_db) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        //创建表
        //拼接sql语句,执行
        NSString *creatTable = @"CREATE TABLE IF NOT EXISTS t_weather (id integer PRIMARY KEY AUTOINCREMENT, weatherjson text NOT NULL); ";
        char *errorMsg = NULL;
        if (sqlite3_exec(_db, creatTable.UTF8String, NULL, NULL, &errorMsg) == SQLITE_OK) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败--%s--%d",errorMsg,__LINE__);
        }
        
    }else{
        NSLog(@"打开数据库失败");
    }
    
}
+ (void)saveWeatherData:(NSString *)weatherjson
{
    //insert语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_weather (weatherjson) VALUES ('%@');",weatherjson];
    char *errorMsg = NULL;
    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败--%s--%d",errorMsg,__LINE__);
    }
}

+ (NSArray *)queryWeatherData
{
    NSMutableArray *cityinfo = [NSMutableArray array];
    const char *sql = "SELECT weatherjson FROM t_weather;";
    sqlite3_stmt *stmt = NULL;
    NSString *temp = @"";
    //准备查询
    if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询成功");
        //stmt步进
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityjson = sqlite3_column_text(stmt, 0);
            temp = [temp initWithUTF8String:(const char*)cityjson];
            [cityinfo addObject:temp];
        }
        
    } else {
        NSLog(@"查询失败");
    }
    return cityinfo;
}

+ (void)deleteWeatherData:(NSInteger)cityid
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_weather WHERE id = %ld",cityid];
    char *errorMsg = NULL;
    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg)) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败--%s--%d",errorMsg,__LINE__);
    }
}

+ (void)updataWeatherData:(NSInteger)cityid :(NSString *)weatherjson
{
    NSString *sql = [NSString stringWithFormat:@"UPDATA t_weather SET weatherjson = '%@' WHERE id = %ld",weatherjson,cityid];
    char *errorMsg = NULL;
    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMsg)) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败--%s--%d",errorMsg,__LINE__);
    }
    
}
@end

//
//  WeatherTool.h
//  SimpleWeather
//
//  Created by SilentWalker on 16/2/22.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "WeatherData.h"
@interface WeatherTool : NSObject
+ (void)saveWeatherData :(NSInteger)cityid :(NSDictionary *)weatherdic;
+ (NSMutableArray *)queryWeatherData;
+ (void)deleteWeatherData :(NSInteger)cityid;
+ (void)updateWeatherData :(NSInteger)cityid :(NSDictionary *)weatherdic;
+ (void)moveWeatherData :(NSInteger)cityid;
@end

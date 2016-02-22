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
+ (void)saveWeatherData :(NSString *)weatherjson;
+ (NSArray *)queryWeatherData;
+ (void)deleteWeatherData :(NSInteger)cityid;
+ (void)updataWeatherData :(NSInteger)cityid :(NSString *)weatherjson;
@end

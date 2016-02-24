//
//  WeatherData.m
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        NSMutableString *temp = [[NSMutableString alloc]initWithString:dict[@"date"]];
        [temp deleteCharactersInRange:NSMakeRange(0, 5)];
        NSString *date = [NSString stringWithString:temp];
        date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        self.date = date;
        self.dayCond = dict[@"cond"][@"txt_d"];
        self.nightCond = dict[@"cond"][@"txt_n"];
        self.maxTmp = [NSString stringWithFormat:@"%@℃",dict[@"tmp"][@"max"]];
        self.minTmp = [NSString stringWithFormat:@"%@℃",dict[@"tmp"][@"min"]];
    }
    return self;
}

+ (NSMutableArray *)weatherWithArray:(NSArray *)data
{
    NSMutableArray *wData = [NSMutableArray array];
    
    NSArray *tempArray = data[0][@"daily_forecast"];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WeatherData *weatherData = [[WeatherData alloc]initWithDict:obj];
        if (idx == 0) {
            weatherData.cityName = data[0][@"basic"][@"city"];
            weatherData.nowCond = data[0][@"now"][@"cond"][@"txt"];
            weatherData.nowTmp = [NSString stringWithFormat:@"%@℃",data[0][@"now"][@"tmp"]];
            weatherData.winddir = [NSString stringWithFormat:@"%@%@级",data[0][@"now"][@"wind"][@"dir"],data[0][@"now"][@"wind"][@"sc"]];
        }
        [wData addObject:weatherData];
    }];
    return wData;
}

@end

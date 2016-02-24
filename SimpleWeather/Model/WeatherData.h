//
//  WeatherData.h
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *nowCond;
@property (nonatomic, strong) NSString *nowTmp;
@property (nonatomic, strong) NSString *winddir;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *maxTmp;
@property (nonatomic, strong) NSString *minTmp;
@property (nonatomic, strong) NSString *dayCond;
@property (nonatomic, strong) NSString *nightCond;

- (instancetype)initWithDict: (NSDictionary *)dict;

+ (NSMutableArray *)weatherWithArray: (NSArray *)data;

@end

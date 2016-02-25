
//
//  WeatherView.m
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherData.h"
@implementation WeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setWeatherConditionWithData:(NSArray *)data
{
    self.wData = data;
    WeatherData *weather = data[0];
    self.nowCond.text = weather.nowCond;
    self.nowTmp.text = weather.nowTmp;
    self.winddir.text = weather.winddir;
    self.cityLable.text = weather.cityName;
    self.weatherImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.weatherImg setImage:[WeatherView stringWithWeather:weather.nowCond]];
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.scrollView.frame.size.height * 2);
    
    //根据tag取出对应的天气格子，赋予属性
    for (int i = 100; i<106; i++) {
        WeeklyForecast *view = [self viewWithTag:i];
        weather = data[i-99];
        
        view.date.text = weather.date;
        view.maxTmp.text = weather.maxTmp;
        view.minTmp.text = weather.minTmp;
        view.dayCond.text = weather.dayCond;
        view.nightCond.text = weather.nightCond;
        
    }
    [self drawLine:data];
}

- (void)drawLine: (NSArray *)data
{
    WeatherData *weather;
    NSMutableArray *maxTmp = [NSMutableArray array];
    NSMutableArray *minTmp = [NSMutableArray array];
    NSMutableArray *maxPoints = [NSMutableArray array];
    NSMutableArray *minPoints = [NSMutableArray array];
    for (int i = 1; i< 7; i++) {
        weather = data[i];
        [maxTmp addObject:weather.maxTmp];
        [minTmp addObject:weather.minTmp];
    }
    NSInteger max = [[maxTmp valueForKeyPath:@"@max.intValue"]integerValue];
    NSInteger min = [[minTmp valueForKeyPath:@"@min.intValue"]integerValue];
    double firstX = self.pathView.frame.size.width / 12;
    double xLenth = firstX * 2;
    double yLenth = self.pathView.frame.size.height;
    double gap = yLenth / (max - min);
    CGPoint point;
    for (int i = 0; i<6; i++) {
        NSString *maxtemp = maxTmp[i];
        NSInteger maxi = maxtemp.intValue;
        NSString *mintemp = minTmp[i];
        NSInteger mini = mintemp.intValue;
        point = CGPointMake(firstX + i * xLenth, (max - maxi) * gap);
        [maxPoints addObject:[NSValue valueWithCGPoint:point]];
        point = CGPointMake(firstX + i * xLenth, (max - mini) * gap);
        [minPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    
       [maxPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [obj CGPointValue];
        
        if (idx == 0) {
            [bezier moveToPoint:point];
        } else {
            [bezier addLineToPoint:point];
        }
        
        
        CGRect rect;
        rect.origin.x = point.x - 1.5;
        rect.origin.y = point.y - 1.5;
        rect.size.width = 4;
        rect.size.height = 4;

        UIBezierPath *arc= [UIBezierPath bezierPathWithOvalInRect:rect];
        [bezier appendPath:arc];

        
    }];
    
    [minPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [obj CGPointValue];
        
        if (idx == 0) {
            [bezier moveToPoint:point];
        } else {
            [bezier addLineToPoint:point];
        }
        
        
        CGRect rect;
        rect.origin.x = point.x - 1.5;
        rect.origin.y = point.y - 1.5;
        rect.size.width = 4;
        rect.size.height = 4;
        
        UIBezierPath *linePoint= [UIBezierPath bezierPathWithOvalInRect:rect];
        [bezier appendPath:linePoint];
        
        
    }];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.frame = CGRectMake(0, 0 , xLenth, yLenth);
    lineLayer.fillColor = [UIColor whiteColor].CGColor;
    lineLayer.path = bezier.CGPath;
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.lineWidth = 2;

    [self.pathView.layer addSublayer:lineLayer];
    
}






+ (UIImage *)stringWithWeather:(NSString *)weatherName
{
    UIImage *weatherImage;
    if ([weatherName isEqualToString:@"晴"]) {
        weatherImage = [UIImage imageNamed:@"qing"];
    }else if ([weatherName isEqualToString:@"多云"]){
        weatherImage = [UIImage imageNamed:@"duoyun"];
    }else if ([weatherName isEqualToString:@"晴间多云"]){
        weatherImage = [UIImage imageNamed:@"qingjianduoyuan"];
    }else if ([weatherName isEqualToString:@"阴"] || [weatherName isEqualToString:@"雾霾"]){
        weatherImage = [UIImage imageNamed:@"yin"];
    }else if ([weatherName isEqualToString:@"小雪"] || [weatherName isEqualToString:@"阵雪"]){
        weatherImage = [UIImage imageNamed:@"xiaoxue"];
    }else if ([weatherName isEqualToString:@"阴转晴"]){
        weatherImage = [UIImage imageNamed:@"yinzhuanqing"];
    }else if([weatherName isEqualToString:@"小雨"]){
        weatherImage = [UIImage imageNamed:@"xiaoyu"];
    }else if ([weatherName isEqualToString:@"大雨"] || [weatherName isEqualToString:@"中雨"]){
        weatherImage = [UIImage imageNamed:@"dayu"];
    }else if([weatherName isEqualToString:@"雨转晴"]){
        weatherImage = [UIImage imageNamed:@"yuzhuanqing"];
    }else if([weatherName isEqualToString:@"阵雨"]){
        weatherImage = [UIImage imageNamed:@"zhenyu"];
    }else if ([weatherName isEqualToString:@"暴雨"]){
        weatherImage = [UIImage imageNamed:@"baoyu"];
    }else if ([weatherName isEqualToString:@"雨夹雪"]){
        weatherImage = [UIImage imageNamed:@"yujiaxue"];
    }else if ([weatherName isEqualToString:@"冰雹"]){
        weatherImage = [UIImage imageNamed:@"bingbao"];
    }else{
        weatherImage = [UIImage imageNamed:@"qing"];
    }
    
    
    return weatherImage;
}

@end

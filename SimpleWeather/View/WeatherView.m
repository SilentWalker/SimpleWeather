
//
//  WeatherView.m
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherData.h"
#import "Cell.h"
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
//    UINavigationBar *navi = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
//    UINavigationItem *naviIten = [[UINavigationItem alloc]initWithTitle:weather.cityName];
//    [navi pushNavigationItem:naviIten animated:NO];
//    [self addSubview:navi];
    self.weatherImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.weatherImg setImage:[WeatherView stringWithWeather:weather.nowCond]];
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.scrollView.frame.size.height * 2);
//    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView reloadData];
}

+ (UIImage *)stringWithWeather:(NSString *)weatherName
{
    UIImage *weatherImage;
    if ([weatherName isEqualToString:@"晴"]) {
        weatherImage = [UIImage imageNamed:@"qing"];
    }else if ([weatherName isEqualToString:@"多云"])
    {
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
    }else if ([weatherName isEqualToString:@"冰雹"])
    {
        weatherImage = [UIImage imageNamed:@"bingbao"];
    }
    else
    {
        weatherImage = [UIImage imageNamed:@"qing"];
    }
    
    
    return weatherImage;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = [indexPath row];
    static NSString *ID = @"cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"Cell" owner:nil options:nil]firstObject];
    }
    WeatherData *weather = self.wData[i];
    cell.date.text = weather.date;
    cell.cond.text = weather.condition;
    cell.tmp.text = weather.tmp;
    
    
    tableView.separatorStyle = UITableViewCellSelectionStyleNone; //无边框
    tableView.scrollEnabled = NO; //不可滚动
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //不可选中
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

@end

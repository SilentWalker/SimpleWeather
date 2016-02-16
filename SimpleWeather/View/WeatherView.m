
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
    self.city.text = weather.cityName;
//    UINavigationBar *navi = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
//    UINavigationItem *naviIten = [[UINavigationItem alloc]initWithTitle:weather.cityName];
//    [navi pushNavigationItem:naviIten animated:NO];
//    [self addSubview:navi];
    
    
    [self.tableView reloadData];
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

    
    return cell;
}
@end

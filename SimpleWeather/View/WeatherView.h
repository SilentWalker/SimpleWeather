//
//  WeatherView.h
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
@interface WeatherView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *nowTmp;
@property (strong, nonatomic) IBOutlet UILabel *winddir;
@property (strong, nonatomic) IBOutlet UILabel *nowCond;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImg;
@property (strong, nonatomic) IBOutlet UILabel *cityLable;

@property (nonatomic, strong) NSArray *wData;

- (void)setWeatherConditionWithData: (NSArray *)data;

@end

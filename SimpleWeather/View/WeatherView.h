//
//  WeatherView.h
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeeklyForecast.h"
@interface WeatherView : UIView
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *nowTmp;
@property (strong, nonatomic) IBOutlet UILabel *winddir;
@property (strong, nonatomic) IBOutlet UILabel *nowCond;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImg;
@property (strong, nonatomic) IBOutlet UILabel *cityLable;
@property (weak, nonatomic) IBOutlet UIView *pathView;


- (void)setWeatherConditionWithData: (NSArray *)data;

@end

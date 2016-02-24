//
//  WeeklyForecast.h
//  SimpleWeather
//
//  Created by SilentWalker on 16/2/24.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyForecast : UIView
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *dayCond;
@property (weak, nonatomic) IBOutlet UILabel *maxTmp;
@property (weak, nonatomic) IBOutlet UILabel *nightCond;
@property (weak, nonatomic) IBOutlet UILabel *minTmp;
@property (strong, nonatomic) IBOutlet UIView *view;

@end

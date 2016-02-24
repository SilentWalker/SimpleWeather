//
//  WeeklyForecast.m
//  SimpleWeather
//
//  Created by SilentWalker on 16/2/24.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "WeeklyForecast.h"

@implementation WeeklyForecast

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [[NSBundle mainBundle]loadNibNamed:@"WeeklyForecast" owner:self options:nil];
    [self addSubview:self.view];
}

@end

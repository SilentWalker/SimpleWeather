//
//  SearchBarViewController.h
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cityName)(NSString *city);
@interface SearchBarViewController : UIViewController

@property(nonatomic,strong) cityName cityName;

- (void)searchCityName:(cityName)cityName;

@end

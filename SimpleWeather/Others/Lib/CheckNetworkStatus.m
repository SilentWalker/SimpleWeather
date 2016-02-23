//
//  CheckNetworkStatus.m
//  SimpleWeather
//
//  Created by SilentWalker on 16/2/23.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "CheckNetworkStatus.h"

@implementation CheckNetworkStatus

+ (NSInteger)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.heweather.com"];
    return [reachability currentReachabilityStatus];
}
@end

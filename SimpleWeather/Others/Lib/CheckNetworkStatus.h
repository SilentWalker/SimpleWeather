//
//  CheckNetworkStatus.h
//  SimpleWeather
//
//  Created by SilentWalker on 16/2/23.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface CheckNetworkStatus : NSObject
+ (NSInteger)networkStatus;
@end

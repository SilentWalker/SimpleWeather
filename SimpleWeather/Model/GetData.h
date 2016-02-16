//
//  GetData.h
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^succeed) (id responseObject);
typedef void(^failed) (NSError *error);
@interface GetData : NSObject

+ (void)request: (NSString *)requestUrl andSussecs: (succeed)result andFailed: (failed)fail;

@end

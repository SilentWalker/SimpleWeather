//
//  Cell.h
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *cond;
@property (strong, nonatomic) IBOutlet UILabel *tmp;

@end

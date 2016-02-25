//
//  SearchBarViewController.m
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "SearchBarViewController.h"

@interface SearchBarViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    self.view.backgroundColor = [UIColor darkGrayColor];
    // Do any additional setup after loading the view.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self returnCityName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnCityName
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.searchBar.text.length == 0) {
            return;
        }
        self.cityName(self.searchBar.text);
    }];
}

- (void)searchCityName:(cityName)cityName
{
    self.cityName = cityName;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width , 50)];
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchBar.barStyle = UIBarStyleBlackOpaque;
        _searchBar.delegate = self;
 
        
          }
    return _searchBar;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self returnCityName];
}
//修改CancleButton
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    for (UIView *canclebtns in [[[searchBar subviews]objectAtIndex:0]subviews]) {
//        NSLog(@"%@",canclebtns);
        if ([canclebtns isKindOfClass:[UIButton class]]) {
            UIButton *cancleBtn = (UIButton*)canclebtns;
          
            [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//            [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        
    }
}
@end

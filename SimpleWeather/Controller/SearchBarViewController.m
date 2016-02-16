//
//  SearchBarViewController.m
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "SearchBarViewController.h"

@interface SearchBarViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
        [self.searchBar resignFirstResponder];
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
- (void)setCityName:(cityName)cityName
{
    //如果为空就拷贝
    if (_cityName != cityName) {
        _cityName = [cityName copy];
    }
}- (void)cancle
{
    [self returnCityName];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width - 60, 50)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_searchBtn setFrame:CGRectMake(self.searchBar.frame.size.width + 5, self.searchBar.frame.origin.y + 5, 40, 40)];
        [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
@end

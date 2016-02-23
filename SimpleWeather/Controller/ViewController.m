//
//  ViewController.m
//  SimpleWeather
//
//  Created by silentwalker on 16/2/15.
//  Copyright © 2016年 silentwalker. All rights reserved.
//

#import "ViewController.h"
#import "GetData.h"
#import "MJRefresh.h"
#import "SearchBarViewController.h"
#define kWeatherOf(city) [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?city=%@&key=1f5b5d067d7a47999cc549a90c7ef7c6",(city)]
#define kKey @"city"
@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *localCache;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainScrollView];
    //取出本地缓存
    self.cityArray = [[WeatherTool queryWeatherData]mutableCopy];
    
    if (self.cityArray.count != 0) {
        [self.cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self drawWeatherViewOfWidth:self.view.frame.size.width * (idx + 1)];
            WeatherView *weatherview = [self.mainScrollView viewWithTag:(idx + 1)];
            [weatherview setWeatherConditionWithData:[WeatherData weatherWithArray:self.cityArray[idx][@"HeWeather data service 3.0"]]];
        }];
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    }else{
        [self drawWeatherViewOfWidth:self.view.frame.size.width];
    }
    [self addBtn];
    [self.view addSubview:self.pageControl];
#pragma mark - 暂存

//    self.cityArray = [[[NSUserDefaults standardUserDefaults]objectForKey:kKey]mutableCopy];
//    if (self.cityArray.count != 0) {
//        [self.cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%@",obj);
//            [self drawWeatherViewOfWidth:self.view.frame.size.width * (idx + 1)];
//            [self getWeatherDataOfCity:obj andTag:idx + 1];
//            
//        }];
//        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//        
//        
//        
//    }else{
//        //设置默认城市为北京
//        [self.cityArray addObject:@"北京"];
//        [self drawWeatherViewOfWidth:self.view.frame.size.width];
//        [self getWeatherDataOfCity:[self.cityArray objectAtIndex:0] andTag:1];
//
//    }
////    [self getWeatherDataOfCity:@"yuyao" andTag:1];
//   
//    [self addBtn];
//    [self.view addSubview:self.pageControl];
    
#pragma mark - test field
//    NSArray *queryArray = [WeatherTool queryWeatherData];
//    if (queryArray.count != 0) {
//        [queryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%@",queryArray[idx]);
//            
//        }];
//    }
    

}
#pragma mark - 方法

//绘制页面
- (void)drawWeatherViewOfWidth: (CGFloat)width
{
    self.mainScrollView.contentSize = CGSizeMake(width, 0);
    
    [self.mainScrollView setContentOffset:CGPointMake(width - self.view.frame.size.width, 0) animated:YES];
    self.pageControl.numberOfPages = width / self.view.frame.size.width;

    WeatherView *weatherView = [[[NSBundle mainBundle]loadNibNamed:@"WeatherView" owner:nil options:nil]firstObject];
    
    [weatherView setFrame:CGRectMake(width - self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    weatherView.tag = self.pageControl.numberOfPages;
//下拉刷新
    weatherView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getWeatherDataOfCity:weatherView.cityLable.text andTag:self.pageControl.currentPage + 1];
        [weatherView.scrollView.mj_header endRefreshing];
    }];
    
    
    // 以3张图片轮流设置背景
    UIImage *backImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(weatherView.tag  % 3)]];
    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:backImage];
    backgroundImage.frame = weatherView.bounds;
    [weatherView insertSubview:backgroundImage atIndex:0];
    [self.mainScrollView addSubview:weatherView];
}

- (void)getWeatherDataOfCity: (NSString *)city andTag: (NSInteger)tag
{
    [GetData request:kWeatherOf([city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]) andSussecs:^(id responseObject) {
        
        WeatherView *weatherView = [self.mainScrollView viewWithTag:tag];
        if ([responseObject[@"HeWeather data service 3.0"][0][@"status"] isEqualToString:@"unknown city"]) {
            //消息框提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"未找到可用城市", @"HUD message title");
            hud.offset = CGPointMake(0, 0);
            [hud hideAnimated:YES afterDelay:2.f];
            
            [self.cityArray removeObject:city];
            [weatherView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setObject:self.cityArray forKey:kKey];
            
            self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.contentSize.width - self.view.frame.size.width, 0);
            self.pageControl.numberOfPages = self.mainScrollView.contentSize.width / self.view.frame.size.width;
            [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            return ;
        }
      //添加天气数据
        [WeatherTool saveWeatherData:tag :responseObject];
        [WeatherTool updataWeatherData:tag :responseObject];
        [weatherView setWeatherConditionWithData:[WeatherData weatherWithArray:responseObject[@"HeWeather data service 3.0"]]];
        } andFailed:^(NSError *error) {
        
    }];
}

//添加增减按钮
- (void)addBtn
{
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [plusBtn setTitle:@"＋" forState:UIControlStateNormal];
    [plusBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36 ]];
    [plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [plusBtn setFrame:CGRectMake(self.view.frame.size.width - 44, self.view.frame.size.height - 44, 44, 44)];
    [plusBtn addTarget:self action:@selector(plusView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteBtn setTitle:@"－" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36]];
    [deleteBtn setFrame:CGRectMake(0, self.view.frame.size.height - 44, 44, 44)];
    [deleteBtn addTarget:self action:@selector(deleteView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
     
    
}

- (void)plusView
{
    SearchBarViewController *searchView = [[SearchBarViewController alloc]init];
    [self presentViewController:searchView animated:YES completion:^{
       [searchView searchCityName:^(NSString *city) {
           [self.cityArray addObject:city];
           NSLog(@"%@",self.cityArray);
           [self drawWeatherViewOfWidth:self.mainScrollView.contentSize.width + self.view.frame.size.width];
           [self getWeatherDataOfCity:city andTag:self.cityArray.count];
           [[NSUserDefaults standardUserDefaults]setValue:self.cityArray forKey:kKey];
       }];
    }];

}
- (void)deleteView
{
    if (self.cityArray.count == 0) {
        return;
    }else{
    [self.cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.pageControl.currentPage) {
            WeatherView *view = [self.mainScrollView viewWithTag:idx +1];
            [view removeFromSuperview];
        }else if (idx > self.pageControl.currentPage)
        {
            WeatherView *view = [self.mainScrollView viewWithTag:idx +1];
            [view setFrame:CGRectMake(view.frame.origin.x - view.frame.size.width, 0, view.frame.size.width, view.frame.size.height)];
            view.tag = idx;
        }
    }];
        [self.cityArray removeObjectAtIndex:self.pageControl.currentPage];
//从数据库删除
        [WeatherTool deleteWeatherData:self.pageControl.currentPage + 1];

        NSLog(@"%@",self.cityArray);
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.contentSize.width - self.view.frame.size.width, 0);
        self.pageControl.numberOfPages = self.mainScrollView.contentSize.width / self.view.frame.size.width;
        [[NSUserDefaults standardUserDefaults]setObject:self.cityArray forKey:kKey];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.mainScrollView.contentOffset.x / self.view.frame.size.width;
    
}
#pragma mark - 懒加载


- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,0);
    }
    
    return _mainScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.mainScrollView.contentSize.width/self.view.frame.size.width;
        _pageControl.backgroundColor = [UIColor whiteColor];
        [_pageControl setCenter:CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 22)];
    }
    return _pageControl;
}


- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _cityArray;
}
@end

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
#import "CheckNetworkStatus.h"
#define kWeatherOf(city) [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?city=%@&key=1f5b5d067d7a47999cc549a90c7ef7c6",(city)]
#define kKey @"city"
@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, assign) NSInteger tagNum;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CheckNetworkStatus networkStatus];
    [self.view addSubview:self.mainScrollView];
    [self loadInitialView];
    [self addBtn];
    [self.view addSubview:self.pageControl];

}
#pragma mark - 方法
//加载初始页面
- (void)loadInitialView
{
    //取出本地缓存
    self.cityArray = [[WeatherTool queryWeatherData]mutableCopy];
    self.tagNum = self.cityArray.count;
    if (self.cityArray.count != 0) {
        [self.cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self drawWeatherViewOfWidth:self.view.frame.size.width * (idx + 1)];
            WeatherView *weatherview = [self.mainScrollView viewWithTag:(idx + 1)];
            [weatherview setWeatherConditionWithData:[WeatherData weatherWithArray:self.cityArray[idx][@"HeWeather data service 3.0"]]];
        }];
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
        //检测时间以决定刷新
        [self timecheck];
    }else{
        //默认页面为北京天气
        [self drawWeatherViewOfWidth:self.view.frame.size.width];
        [self getWeatherDataOfCity:@"beijing" andTag:1];
        self.tagNum = 1;

    }

}
//绘制页面
- (void)drawWeatherViewOfWidth: (CGFloat)width
{
    self.mainScrollView.contentSize = CGSizeMake(width, 0);
    
    [self.mainScrollView setContentOffset:CGPointMake(width - self.view.frame.size.width, 0) animated:YES];
    self.pageControl.numberOfPages = width / self.view.frame.size.width;

    WeatherView *weatherView = [[[NSBundle mainBundle]loadNibNamed:@"WeatherView" owner:nil options:nil]firstObject];
    
    [weatherView setFrame:CGRectMake(width - self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    weatherView.tag = self.pageControl.numberOfPages;
    //添加下拉刷新方法
    weatherView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getWeatherDataOfCity:weatherView.cityLable.text andTag:self.pageControl.currentPage + 1];
        [weatherView.scrollView.mj_header endRefreshing];
    }];
    
    
    // 以3张图片轮流设置背景
//    UIImage *backImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(weatherView.tag  % 3)]];
//    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:backImage];
//    backgroundImage.frame = weatherView.bounds;
//    [weatherView insertSubview:backgroundImage atIndex:0];
    weatherView.backgroundColor = [UIColor blackColor];
    [self.mainScrollView addSubview:weatherView];
}

- (void)getWeatherDataOfCity: (NSString *)city andTag: (NSInteger)tag
{
    //检测网络状态，有则访问，否则提示
    if ([CheckNetworkStatus networkStatus]) {
        [GetData request:kWeatherOf([city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]) andSussecs:^(id responseObject) {
            
            WeatherView *weatherView = [self.mainScrollView viewWithTag:tag];
            if ([responseObject[@"HeWeather data service 3.0"][0][@"status"] isEqualToString:@"unknown city"]) {
                //消息框提示
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"未找到可用城市", @"HUD message title");
                hud.offset = CGPointMake(0, 0);
                [hud hideAnimated:YES afterDelay:2.f];
                
                //清理错误数据
                [WeatherTool deleteWeatherData:tag];
                self.tagNum -= 1;
                [weatherView removeFromSuperview];
                
                self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.contentSize.width - self.view.frame.size.width, 0);
                self.pageControl.numberOfPages = self.mainScrollView.contentSize.width / self.view.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                
                return ;
            }
            //添加天气数据,若存在则更新
            [WeatherTool updateWeatherData:tag :responseObject];
            [WeatherTool saveWeatherData:tag :responseObject];
            
            [weatherView setWeatherConditionWithData:[WeatherData weatherWithArray:responseObject[@"HeWeather data service 3.0"]]];
            
        } andFailed:^(NSError *error) {
            
        }];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"无网络连接", @"HUD message title");
        hud.offset = CGPointMake(0, 0);
        [hud hideAnimated:YES afterDelay:2.f];
    }
    
    
    
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
           //tag数量加一，创建对应记录，等待传入数据更新
           self.tagNum += 1;

           [self drawWeatherViewOfWidth:self.mainScrollView.contentSize.width + self.view.frame.size.width];
           [self getWeatherDataOfCity:city andTag:self.tagNum];
           [WeatherTool saveWeatherData:self.tagNum :nil];

       }];
    }];

}
/**
 *  删除页面，同时删除数据库对应数据
 */
- (void)deleteView
{

    if (self.tagNum == 0) {
        return;
    }else{
        NSInteger i;
        for (i = 0; i < self.tagNum; i++) {
            //删除页面及数据
            if (i == self.pageControl.currentPage) {
                WeatherView *view = [self.mainScrollView viewWithTag:i + 1];
                [view removeFromSuperview];
                [WeatherTool deleteWeatherData:i + 1];
            //移动后续页面tag及数据库记录
            }else if (i > self.pageControl.currentPage)
            {
                WeatherView *view = [self.mainScrollView viewWithTag:i +1];
                [view setFrame:CGRectMake(view.frame.origin.x - view.frame.size.width, 0, view.frame.size.width, view.frame.size.height)];
                view.tag = i;
                [WeatherTool moveWeatherData:i + 1];
            }
    }
    self.tagNum -= 1;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.contentSize.width - self.view.frame.size.width, 0);
    self.pageControl.numberOfPages = self.mainScrollView.contentSize.width / self.view.frame.size.width;
    }
    
}

- (void)timecheck
{
    //若有网络则检测
    if ([CheckNetworkStatus networkStatus]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *str = self.cityArray[0][@"HeWeather data service 3.0"][0][@"basic"][@"update"][@"loc"];
        NSDate *upDate = [dateformatter dateFromString:str];
        //获取当前时间与上次更新时间的时间差
        NSTimeInterval nowtime = [date timeIntervalSince1970];
        NSTimeInterval uptime = [upDate timeIntervalSince1970];
        
        double timeGap = (nowtime - uptime) / 60;
        //若大于70分钟则刷新
        if (timeGap > 70) {
            //消息框提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"数据更新中", @"HUD message title");
            hud.offset = CGPointMake(0, 0);
            [hud hideAnimated:YES afterDelay:1.f];

             
            for (int i = 0; i < self.cityArray.count; i++) {
                WeatherView *view = [self.mainScrollView viewWithTag:i + 1];
                [self getWeatherDataOfCity:view.cityLable.text andTag:i + 1];
            }
            
            [self.cityArray removeAllObjects];
            self.cityArray = [[WeatherTool queryWeatherData]mutableCopy];
            
        }

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//滚动视图
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
-(NSInteger)tagNum
{
    if (!_tagNum) {
        _tagNum = 1;
    }
    return _tagNum;
}
@end

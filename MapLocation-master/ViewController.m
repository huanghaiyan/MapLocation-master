//
//  ViewController.m
//  MapLocation-master
//
//  Created by 黄海燕 on 16/8/22.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.使用定位服务
    //设置app有访问定位服务的权限
    //在使用应用期间 / 始终(app在后台)
    //info.plist文件添加以下两条(或者其中一条):
    //NSLocationWhenInUseUsageDescription 在使用应用期间
    //NSLocationAlwaysUsageDescription 始终
    //2.LocationManager 对象管理相关的定位服务
    _manager = [[CLLocationManager alloc] init];
    //manager判断: 手机是否开启定位 / app是否有访问定位的权限
    //[CLLocationManager locationServicesEnabled]; //手机是否开启定位
    //[CLLocationManager authorizationStatus]; //app访问定位的权限的状态
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_manager requestWhenInUseAuthorization]; //向用户请求访问定位服务的权限
    }
     //设置代理
    _manager.delegate = self;
    //设置定位精度
    _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //定位频率,每隔多少米定位一次
    _manager.distanceFilter = 10.0f;
    //启动跟踪定位
    [_manager startUpdatingLocation];
}

#pragma mark 跟踪定位代理方法,每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //如果不需要实时定位，使用完即使关闭定位服务
    [_manager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *location = [placemark addressDictionary];
            // Country(国家) State(城市) SubLocality(区) Name全称
            NSLog(@"%@", [location objectForKey:@"State"]);
            _cityLabel.text = [location objectForKey:@"State"];
        }
    }];
}

@end

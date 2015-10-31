//
//  NearByViewController.m
//  XS27Weibo
//
//  Created by gj on 15/10/20.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//


/**
 *  1 定义(遵循MKAnnotation协议 )annotation类-->MODEL
 2 创建 annotation对象，并且把对象加到mapView;
 3 实现mapView 的协议方法 ,创建标注视图
 */
#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"

@interface NearByViewController ()

@end

@implementation NearByViewController{
//    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViews];

    CLLocationCoordinate2D coordinate = {30.326943,120.368069};
//
//    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
//    annotation.coordinate = coordinate;
//    annotation.title = @"天堂";
//    annotation.subtitle = @"Feyddy&Janie";
//    [_mapView addAnnotation:annotation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)_createViews{
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图种类 卫星  标准  混合
    _mapView.mapType = MKMapTypeStandard;
    //用户跟踪模式
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    //代理
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark - mapView 代理 
//位置更新后被调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 %lf 纬度 %lf",coordinate.longitude,coordinate.latitude);
    
    CLLocationCoordinate2D  center = coordinate;
    
    //02 设置span ,数值越小,精度越高，范围越小
    
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    [_mapView setRegion:region];

    //网络获取附近微博
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [self _loadNearByData:lon lat:lat];
}

////标注视图获取
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    
//    //    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
//    //  处理用户当前位置
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        
//        return nil;
//    }
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//        //颜色
//        pin.pinColor = MKPinAnnotationColorPurple;
//        //从天而降
//        pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        
//        pin.rightCalloutAccessoryView = [UIButton  buttonWithType:UIButtonTypeContactAdd];
//        
//        
//    }
//    return pin;
//    
//    
//}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if (view == nil) {
            view = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        }
        view.annotation = annotation;
        [view setNeedsLayout];
        return view;
    }
    return nil;
}

//获取附近微博
- (void)_loadNearByData:(NSString *)lon lat:(NSString *)lat{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[ NSMutableArray alloc] initWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses) {
            
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            
            //  [_mapView addAnnotation:annotation]
            
            [annotationArray addObject:annotation];
            
        }
        
        [_mapView addAnnotations:annotationArray];
        
        
        
        
    }];
}


@end

//
//  NearByViewController.h
//  XS27Weibo
//
//  Created by gj on 15/10/20.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@end

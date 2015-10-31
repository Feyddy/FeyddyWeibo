//
//  LocationViewController.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/19.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PoiModel.h"

@interface LocationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
}
@property (nonatomic ,strong) NSArray *dataList;//用来存放 服务器返回的地理位置信息


@end

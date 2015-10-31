//
//  WeiboAnnotation.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/20.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


- (void)setModel:(WeiboModel *)model
{
    if (_model != model) {
        _model = model;
        NSDictionary *geo = model.geo;
        
        NSArray *coordinates = [geo objectForKey:@"coordinates"];
        if (coordinates.count > 1) {
            NSString *longitude = coordinates[0];
            NSString *latitude = coordinates[1];
            //坐标一定要设置
            
            
        //坐标一定要设置
        //CLLocationCoordinate2D
        //    _coordinate = {[longitude floatValue],[latitude floatValue]};
        self.coordinate = CLLocationCoordinate2DMake([longitude floatValue], [latitude floatValue]);
        }
    }
}

@end

//
//  SendViewController.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/19.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
@interface SendViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,ZoomImageViewDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
{
    UITextView *_textView;
    UIView *_editView;
    
    //3 显示缩略图
    ZoomImageView *_zoomImageView;
    //4 位置管理器
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
}

@end

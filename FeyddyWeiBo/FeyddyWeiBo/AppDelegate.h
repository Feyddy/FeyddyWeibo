//
//  AppDelegate.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SinaWeibo *sinaWeiBo;


@end


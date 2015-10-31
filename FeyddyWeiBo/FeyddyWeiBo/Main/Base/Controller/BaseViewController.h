//
//  BaseViewController.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"

@interface BaseViewController : UIViewController


- (void)setNavItem;
-(void)_loadImage;



-(void)showHUD:(NSString *)title;


-(void)hideHUD;


-(void)completeHUD:(NSString *)title;


-(void)showLoading:(BOOL )show;

- (void)shouTipWindow:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation;
@end

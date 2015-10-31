//
//  ProfileViewController.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SinaWeibo.h"
#import "WeiboViewFrameLayout.h"

@interface ProfileViewController : BaseViewController<SinaWeiboRequestDelegate>
@property (nonatomic,strong) WeiboViewFrameLayout *layout;

@end

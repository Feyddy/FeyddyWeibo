//
//  AppDelegate.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "Common.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //01 左 中 右 控制器
    
    LeftViewController *leftVc = [[LeftViewController alloc] init];
    
    BaseTabBarController *tabController = [[BaseTabBarController alloc] init];
    
    RightViewController *rightVc = [[RightViewController alloc] init];
    
    
    //02 创建 MMDrawerController容器控制器
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:tabController leftDrawerViewController:leftVc rightDrawerViewController:rightVc];
    
    //设置 左边 右边 宽度
    [drawerController setMaximumRightDrawerWidth:75.0];
    [drawerController setMaximumLeftDrawerWidth:150];
    
    //设置手势有效区域
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置动画类型
    
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState swingingDoorVisualStateBlock];
    [drawerController setDrawerVisualStateBlock:block];
    
    //设置动画效果,当左右侧边栏打开或者关闭的时候执行该block内的代码

    
    //初始化窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window .backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    BaseTabBarController *baseTabBarC = [[BaseTabBarController alloc] init];
//    self.window.rootViewController = baseTabBarC;
    self.window.rootViewController = drawerController;
    
    
    //设置微博的登录信息
    self.sinaWeiBo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    
    //NSLog(NSHomeDirectory());//沙盒路径
    //如果本地存储过 令牌信息，则读取出来，代表已经登陆过
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"FeyddySinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaWeiBo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaWeiBo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaWeiBo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    
    return YES;
}


- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FeyddySinaWeiboAuthData"];
}

//微博登录认证到plist文件
- (void)storeAuthData
{
    SinaWeibo *sinaweibo = self.sinaWeiBo;
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"FeyddySinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    //登陆过后把令牌等信息存储到本地
    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    
    [self removeAuthData];
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

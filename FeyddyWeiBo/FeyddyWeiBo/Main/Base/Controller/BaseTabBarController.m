//
//  BaseTabBarController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "Common.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"

@interface BaseTabBarController ()<SinaWeiboRequestDelegate>
{
    ThemeImageView *_selectedImageView;//TabBar按钮选中图片
    ThemeImageView *_badgeImageView;
    ThemeLabel *_badgeLabel;
}
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Warnning:下面两个的调用顺序不能改变
    
    //1.加载子视图控制器
    [self _createSubControllers];
    
    //2.设置Tabbar
    [self _setTabBar];
    
    //开启定时器,请求unread_count接口 获取未读微博、新粉丝数量、新评论。。。
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
}

#pragma mark - 加载子视图控制器
- (void)_createSubControllers
{
    NSArray *names = @[@"HomeViewController",@"MessageViewController",@"DiscoverViewController",@"ProfileViewController",@"MoreViewController"];
    NSMutableArray *navArray = [NSMutableArray array];
    
    //循环加载子视图控制器
    for (int i = 0; i < names.count; i++) {
        //通过storyBoard来加载子视图控制器的方法
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        
        BaseNavigationController *navigationC = [storyBoard instantiateInitialViewController];
        [navArray addObject:navigationC];
    }
    self.viewControllers = navArray;
    
}

#pragma mark - 设置Tabbar
- (void)_setTabBar
{
    //01移除TabBar上面的UITabBarButton子视图
    for (UIView *view in self.tabBar.subviews) {
        //UITabBarButton这个类是内部封装的，无法直接使用，但是可以查找到对应的类
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
    
    //02设置TabBar背景图片
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , 49)];
    bgImageView.imageName = @"mask_navbar.png";
    //bgImageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    [self.tabBar addSubview:bgImageView];
    
    //03选中图片
    CGFloat width = kScreenWidth / 5;
    _selectedImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, width, 49)];
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
//    _selectedImageView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    [self.tabBar addSubview:_selectedImageView];
    
    //04创建TabBar按钮
//    NSArray *names = @[@"Skins/cat/home_tab_icon_1.png",
//                       @"Skins/cat/home_tab_icon_2.png",
//                       @"Skins/cat/home_tab_icon_3.png",
//                       @"Skins/cat/home_tab_icon_4.png",
//                       @"Skins/cat/home_tab_icon_5.png",
//                       ];
    
    NSArray *names = @[@"home_tab_icon_1.png",
                       @"home_tab_icon_2.png",
                       @"home_tab_icon_3.png",
                       @"home_tab_icon_4.png",
                       @"home_tab_icon_5.png",
                       ];
    //循环创建标签栏上面的按钮
    for (int i = 0; i < names.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i * width, 0, width, 49)];
//        [button setImage:[UIImage imageNamed:names[i]] forState:UIControlStateNormal];
        button.normalImageName = names[i];
        button.tag = i;
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
    
    
    
}

#pragma mark - TabBar按钮方法
-(void)selectedAction:(UIButton *)button
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _selectedImageView.center = button.center;
    }];
    
    //selectedIndex属性用来，点击对应的按钮显示对应的视图
    self.selectedIndex = button.tag;
}



#pragma mark - 未读系消息个数获取
- (void)timerAction{
    
    //请求数据
    AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeiBo;
    
    [sinaWeibo requestWithURL:@"remind/unread_count.json" params:nil httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    //number_notify_9.png
    //Timeline_Notice_color
    //未读微博
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    CGFloat tabBarButtonWidth = kScreenWidth/5;
    
    if (_badgeImageView == nil) {
        _badgeImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(tabBarButtonWidth-32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeImageView];
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font =[UIFont systemFontOfSize:13];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        [_badgeImageView addSubview:_badgeLabel];
        
    }
    if (count > 0) {
        _badgeImageView.hidden = NO;
        if (count > 99) {
            count = 99;
        }
        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
    }else{
        
        _badgeImageView.hidden = YES;
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end

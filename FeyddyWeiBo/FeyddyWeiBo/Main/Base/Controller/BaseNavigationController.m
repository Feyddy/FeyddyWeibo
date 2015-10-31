//
//  BaseNavigationController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}

-(void)_loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:@"mask_titlebar64"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏的主体颜色
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    NSDictionary *attrDic = @{NSForegroundColorAttributeName:color};
    self.navigationBar.titleTextAttributes = attrDic ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

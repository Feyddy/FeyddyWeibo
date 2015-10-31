//
//  RightViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/10.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SendViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavigationController.h"
#import "LocationViewController.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self _createButton];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self _loadImage];
}

- (void)_createButton
{
    
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    
    for (int i = 0; i < imageNames.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(5, i * 40+100 , 40, 40)];
        button.normalImageName = imageNames[i];
        button.tag = i;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)buttonAction:(ThemeButton *)button
{
    if (button.tag == 0) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
            
            SendViewController *sendVC = [[SendViewController alloc] init];

            sendVC.title = @"写微博";
            BaseNavigationController *baseNavC = [[BaseNavigationController alloc] initWithRootViewController:sendVC];
            [self.mm_drawerController presentViewController:baseNavC animated:YES completion:nil];
            
            
        }];
    }
    else if (button.tag == 4)
    {
        // 附近地点
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            
            LocationViewController *vc = [[LocationViewController alloc] init];
            vc.title = @"附近商圈";
            
            // 创建导航控制器
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];

    }
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

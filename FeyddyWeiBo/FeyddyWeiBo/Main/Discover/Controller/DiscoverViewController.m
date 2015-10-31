//
//  DiscoverViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController
- (IBAction)nearByWeiboAction:(UIButton *)sender {
    
    NearByViewController *nb = [[NearByViewController alloc ]init];
    [self.navigationController pushViewController:nb animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

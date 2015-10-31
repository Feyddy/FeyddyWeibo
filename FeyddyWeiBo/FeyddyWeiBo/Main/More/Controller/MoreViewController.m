//
//  MoreViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ThemeTableViewController.h"
#import "ThemeManager.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建表示图
    [self _createTableView];
}
//- (IBAction)weiboLoginAction:(UIButton *)sender {
//    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//    SinaWeibo *sinaWeiBo = appDelegate.sinaWeiBo;
//    
//    if ([sinaWeiBo isLoggedIn]) {
//        NSLog(@"已经登录");
//    }
//    else
//    {
//        [sinaWeiBo logIn];
//    }
//}

//每次出现的时候重新刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    [_tableView reloadData];
    
}
#pragma mark - 创建表示图
-(void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.view addSubview:_tableView];
    
    //注册单元格类
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:@"MoreCell"];
    
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, kScreenHeight-200, 60, 40)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTintColor:[UIColor blueColor]];
    [self.view addSubview:loginButton];
    loginButton.backgroundColor = [UIColor clearColor];
    
}

-(void)login
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeiBo = appDelegate.sinaWeiBo;
    
    if ([sinaWeiBo isLoggedIn]) {
        NSLog(@"已经登录");
    }
    else
    {
        [sinaWeiBo logIn];
    }
}

#pragma mark - UITableViewDataSource协议方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.themeTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.themeTextLabel.center = cell.contentView.center;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.themeImageView.imageName = @"more_icon_theme.png";
            cell.themeTextLabel.text = @"主题选择";
            cell.themeNameLabel.text = [ThemeManager shareInstance].themeName;
            
        }
        else if(indexPath.row == 1) {
            cell.themeImageView.imageName = @"more_icon_account.png";
            cell.themeTextLabel.text = @"账户管理";
        }
    }
    else if(indexPath.section == 1) {
        cell.themeImageView.imageName = @"more_icon_feedback.png";
        cell.themeTextLabel.text = @"意见反馈";
    }
    else if(indexPath.section == 2) {
        cell.themeTextLabel.text = @"登出当前账号";
        
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0) {
        ThemeTableViewController *themeC = [[ThemeTableViewController alloc] init];
        [self.navigationController pushViewController:themeC animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认登出么?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alert show];
    }
}



#pragma mark - 登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.sinaWeiBo logOut];
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

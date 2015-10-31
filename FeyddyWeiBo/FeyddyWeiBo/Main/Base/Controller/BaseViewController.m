//
//  BaseViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeButton.h"
#import "MBProgressHUD.h"
#import "UIProgressView+AFNetworking.h"

@interface BaseViewController ()
{
    MBProgressHUD *_hud;
    UIView *_tipView;
    UIWindow *_tipWindow;
//    UIProgressView *progress;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadImage];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    UIImage *image = [manager getThemeImage:@"bg_home.jpg"];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
}


-(void)setNavItem
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    leftButton.bgNormalImageName = @"button_title.png";
    leftButton.normalImageName = @"group_btn_all_on_title.png";
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    //转换成UIBarButtonItem
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    
    
    //button_icon_plus.png   button图片
//    button_m.png  button背景图片
    
    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
    rightButton.bgNormalImageName = @"button_m.png";
    rightButton.normalImageName = @"button_icon_plus.png";
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    //转换成UIBarButtonItem
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
}

-(void)editAction
{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)setAction
{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)showHUD:(NSString *)title
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;
}


-(void)hideHUD
{
    [_hud hide:YES];
}


-(void)completeHUD:(NSString *)title
{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1.5];
}




-(void)showLoading:(BOOL )show
{
    
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-30, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        
        //01 activity
        UIActivityIndicatorView *activiyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activiyView.tag = 100;
        [_tipView addSubview:activiyView];
        
        
        //02 label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在加载。。。";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        
        
        [_tipView addSubview:label];
        
        
        label.left = (kScreenWidth-label.width)/2;
        activiyView.right = label.left-5;
        
    }
    if (show) {
        UIActivityIndicatorView *activiyView = [_tipView viewWithTag:100];
        [activiyView startAnimating];
        [self.view addSubview:_tipView];
    }else{
        if (_tipView.superview) {
            UIActivityIndicatorView *activiyView = [_tipView viewWithTag:100];
            [activiyView stopAnimating];
            [_tipView removeFromSuperview];
        }
    }

   
}


-(void)shouTipWindow:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation
{
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        label.backgroundColor = [UIColor grayColor];
        label.text = title;
        label.tag = 100;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [_tipWindow addSubview:label];
        
        //实现进度条
        UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 0)];
        progress.progress = 0.0;
        progress.tag = 101;
        [_tipWindow addSubview:progress];
        
        
    }
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:100];
    label.text = title;
    
    UIProgressView *progress = (UIProgressView *)[_tipWindow viewWithTag:101];
    
//    [_tipWindow addSubview:label];
    
    if (show) {
        [_tipWindow setHidden:NO];
        
        if (operation != nil) {
        
            //[progress setHidden:NO];
            progress.hidden = NO;
            [progress setProgressWithDownloadProgressOfOperation:operation animated:YES];
        }else{
            [progress setHidden:YES];
        }
        
    }
    else
    {
//        [progress setHidden:YES];
//        [_tipWindow setHidden:NO];
//        [_tipWindow setHidden:NO];
        [self performSelector:@selector(showTipwindow) withObject:nil afterDelay:1];
    }
}


- (void)showTipwindow
{
//    UIProgressView *progress = (UIProgressView *)[_tipWindow viewWithTag:101];
//    progress.hidden = YES;
    [_tipWindow setHidden:YES];
    
    _tipWindow = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self setNavItem];
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

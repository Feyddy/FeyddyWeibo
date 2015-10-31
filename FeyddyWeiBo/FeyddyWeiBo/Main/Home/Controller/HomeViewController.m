//
//  HomeViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "HomeViewController.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLayout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeViewController ()
{
    NSMutableArray *_data;
    
    ThemeImageView *_barImageView;//弹出微博条数提示
    ThemeLabel *_barLabel;//提示文字
}

@end

@implementation HomeViewController
{
    WeiBoTableView *_weiBoTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [NSMutableArray array];

    [self _createTableView];
    [self setNavItem];
    [self _loadData];
    
    
    // Do any additional setup after loading the view.
}

- (void)_createTableView
{
    _weiBoTableView = [[WeiBoTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _weiBoTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_weiBoTableView];
    
    _weiBoTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    
    _weiBoTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}


#pragma mark - 微博请求
- (void)_loadData{
    
    //测试 获取微博
    
    [self showHUD:@"loading..."];
//    [self showLoading:YES];
    
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeiBo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    
    SinaWeiboRequest * request =     [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    
    request.tag = 100;
}


//上拉加载更多
- (void)_loadMoreData{
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //如果已经登陆则获取微博数据
//    if (appDelegate.sinaWeiBo.isLoggedIn) {
    
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        //设置maxId
        
        if (_data.count > 0) {
            WeiboViewFrameLayout *layoutFrame = [_data lastObject];
            WeiboModel *model = layoutFrame.model;
            NSString *maxId = model.weiboIdStr;
            [params setObject:maxId forKey:@"max_id"];
        }
        
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeiBo requestWithURL:@"statuses/home_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        
        request.tag = 102;
        
        
//        return;
//    }
//    [appDelegate.sinaWeiBo logIn];
    
}

//下拉刷新

- (void)_loadNewData{
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (appDelegate.sinaWeiBo.isLoggedIn) {
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        //设置 sinceId
        if (_data.count > 0) {
            WeiboViewFrameLayout *layoutFrame = _data[0];
            WeiboModel *model = layoutFrame.model;
            NSString *sinceId = model.weiboIdStr;
            [params setObject:sinceId forKey:@"since_id"];
        }
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeiBo requestWithURL:@"statuses/home_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        request.tag = 101;
       
        
//        return;
//    }
    
//    [self showNewWeiboCount:_data.count];
    
//    [appDelegate.sinaWeiBo logIn];
    
    
}


- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSLog(@"%@",result);
    //解析数据
    
    NSArray *statusesArray = [result objectForKey:@"statuses"];
    
    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    // _weiBoTableView.data = dicArray;
    
    for (NSDictionary *dataDic in statusesArray) {
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dataDic];
        
        //        [modelArray addObject:model];
        
        WeiboViewFrameLayout *layout = [[WeiboViewFrameLayout alloc] init];
        layout.model = model;
        
        [layoutFrameArray addObject:layout];
    }
    
    if (request.tag == 100) {//普通加载微博
        _data = layoutFrameArray;
        [self completeHUD:@"complete..."];
//        [self showLoading:NO];
        
    }else if(request.tag == 101){//更多微博
        
//        if (layoutFrameArray.count > 1) {
//            [layoutFrameArray removeObjectAtIndex:0];
//            [_data addObjectsFromArray:layoutFrameArray];
//        }
        if (_data == nil) {
            _data = layoutFrameArray;
        }else
        {
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            [self showNewWeiboCount:layoutFrameArray.count];
        }
        
        
    }else if(request.tag == 102){//最新微博
        
        
//        if (layoutFrameArray.count > 0) {
//            
//            NSRange range = NSMakeRange(0, layoutFrameArray.count);
//            
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//            
//            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
//            
//            [self showNewWeiboCount:layoutFrameArray.count];
//        }
        
        
        //更多
        if (_data == nil) {
            _data = layoutFrameArray;
        }else{
            [_data removeLastObject];
            [_data addObjectsFromArray:layoutFrameArray];
        }
    }
    
    if (_data.count != 0) {
        _weiBoTableView.data = _data;
        [_weiBoTableView reloadData];
    }
    
    
    [_weiBoTableView.header endRefreshing];
    [_weiBoTableView.footer endRefreshing];
    
    
    //    _weiBoTableView.data = modelArray;
//    _weiBoTableView.data = layoutFrameArray;
////
//    [_weiBoTableView reloadData];
    
}


- (void)showNewWeiboCount:(NSInteger)count{
    if (_barImageView == nil) {
        
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        
        [_barImageView addSubview:_barLabel];
        
    }
    
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64+5+40);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationDelay:1];//让提示消息停留一秒
                _barImageView.transform = CGAffineTransformIdentity;
            }];
            
        }];
        
        
        //播放声音
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        SystemSoundID soundID;
    
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);

    
        AudioServicesPlaySystemSound(soundID);
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        
//        //注册系统声音
//        SystemSoundID soundId;// 0
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
//        AudioServicesPlaySystemSound(soundId);
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

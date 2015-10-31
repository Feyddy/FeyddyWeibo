//
//  ProfileViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/8.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "ProfileViewController.h"
#import "WeiBoTableView.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLayout.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"


@interface ProfileViewController ()
{
    WeiBoTableView *_PersonalWeiBoTableView;
    UIView *_headerView;
    NSMutableArray *_data;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [NSMutableArray array];
    [self _loadData];
    [self setNavItem];
    [self _createView];
    [self _createSubview];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)_createView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, kScreenWidth-40, 200)];
    _headerView.layer.borderWidth = 0.5;
    _headerView.layer.borderColor = [[UIColor grayColor]CGColor];
    _headerView.backgroundColor = [UIColor clearColor];
    
    _PersonalWeiBoTableView = [[WeiBoTableView alloc] initWithFrame:self.view.bounds];
    _PersonalWeiBoTableView.backgroundColor = [UIColor clearColor];
    _PersonalWeiBoTableView.tableHeaderView = _headerView;
//    _PersonalWeiBoTableView.delegate = self;
//    _PersonalWeiBoTableView.dataSource = self;
    [self.view addSubview:_PersonalWeiBoTableView];
    
    _PersonalWeiBoTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    
    _PersonalWeiBoTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
    
    
}

-(void)_createSubview
{
    
    
    //用户名
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 200, 40)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont systemFontOfSize:20];
    userNameLabel.text = @"Feyddy";
    [_headerView addSubview:userNameLabel];
    
    //用户信息
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 200, 40)];
    userInfoLabel.backgroundColor = [UIColor clearColor];
    userInfoLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"男",@"浙江",@"杭州"];
    [_headerView addSubview:userInfoLabel];
    
    
    //用户简介
    UILabel *userDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 200, 40)];
    userDescriptionLabel.backgroundColor = [UIColor clearColor];
    userDescriptionLabel.text = [NSString stringWithFormat:@"简介:%@",@"另类的人"];
    [_headerView addSubview:userDescriptionLabel];
    

    //创建四个button。
    NSArray *titles =@[
                       @"关注",
                       @"粉丝",
                       @"资料",
                       @"更多",
                       ];
    CGFloat buttonWidth = (kScreenWidth - 60)/titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+i*buttonWidth, 130, buttonWidth-5, buttonWidth-5)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.backgroundColor = [UIColor purpleColor];
        [button addSubview:label];
        [_headerView addSubview:button];
    }
}

- (void)_loadData{
    
    //测试 获取微博
    
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeiBo;
    [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    
}


#pragma mark - 微博请求

- (void)_loadWeiboData{
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    
    //如果已经登陆则获取微博数据
    if (appDelegate.sinaWeiBo.isLoggedIn) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        SinaWeiboRequest *request =  [appDelegate.sinaWeiBo requestWithURL:@"statuses/home_timeline.json"
                                                                    params:params
                                                                httpMethod:@"GET"
                                                                  delegate:self];
        
        
        request.tag = 100;
        
        return;
    }
    [appDelegate.sinaWeiBo logIn];
    
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
        
        // [modelArray addObject:model];
        
        _layout = [[WeiboViewFrameLayout alloc] init];
        _layout.model = model;
        
        //用户头像
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 120)];
        [userImageView sd_setImageWithURL:[NSURL URLWithString:_layout.model.userModel.profile_image_url]];
        
        [_headerView addSubview:userImageView];

        
        
        [layoutFrameArray addObject:_layout];
    }
    
    if (request.tag == 100) {//普通加载微博
        _data = layoutFrameArray;
        
    }else if(request.tag == 101){//更多微博
        
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];
        }
        
        
    }else if(request.tag == 102){//最新微博
        if (layoutFrameArray.count > 0) {
            
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            
            
        }
        
    }
    
    if (_data.count != 0) {
        _PersonalWeiBoTableView.data = _data;
        [_PersonalWeiBoTableView reloadData];
    }
    
    
    [_PersonalWeiBoTableView.header endRefreshing];
    [_PersonalWeiBoTableView.footer endRefreshing];
    
    
    //    _weiBoTableView.data = modelArray;
    _PersonalWeiBoTableView.data = layoutFrameArray;
    
//    [_PersonalWeiBoTableView reloadData];

    //    _weiBoTableView.data = modelArray;
    //_PersonalWeiBoTableView.data = layoutFrameArray;
    
    
    //    userImageView.backgroundColor = [UIColor orangeColor];
    
//    WeiboModel *weiBoModel = _layout.model;
    
    
    
    
    
    
    
    [_PersonalWeiBoTableView reloadData];
    
}


//上拉加载更多
- (void)_loadMoreData{
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //如果已经登陆则获取微博数据
    if (appDelegate.sinaWeiBo.isLoggedIn) {
        
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        //设置maxId
        
        if (_data.count != 0) {
            WeiboViewFrameLayout *layoutFrame = [_data lastObject];
            WeiboModel *model = layoutFrame.model;
            NSString *maxId = model.weiboIdStr;
            [params setObject:maxId forKey:@"max_id"];
        }
        
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeiBo requestWithURL:@"statuses/home_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        
        request.tag = 101;
        
        
        return;
    }
    [appDelegate.sinaWeiBo logIn];
    
}

//下拉刷新

- (void)_loadNewData{
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.sinaWeiBo.isLoggedIn) {
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        //设置 sinceId
        if (_data.count != 0) {
            WeiboViewFrameLayout *layoutFrame = _data[0];
            WeiboModel *model = layoutFrame.model;
            NSString *sinceId = model.weiboIdStr;
            [params setObject:sinceId forKey:@"since_id"];
        }
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeiBo requestWithURL:@"statuses/home_timeline.json"
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        request.tag = 102;
        
        
        return;
    }
    [appDelegate.sinaWeiBo logIn];
    
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

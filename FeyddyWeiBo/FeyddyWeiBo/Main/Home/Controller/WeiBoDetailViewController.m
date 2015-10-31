//
//  WeiBoDetailViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "WeiBoDetailViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "CommentModel.h"
#import "SinaWeibo.h"
#import "CommentTableView.h"
#import "Common.h"
@interface WeiBoDetailViewController ()<SinaWeiboRequestDelegate>
{

    SinaWeiboRequest *_request;
    CommentTableView *_tableView;
}

@end

@implementation WeiBoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建列表
    [self _createTableView];
    [self _loadData];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
    
    
}

//
//- (void)viewDidAppear:(BOOL)animated{
//    self.view.backgroundColor = [UIColor clearColor];
//    
//}

- (void)viewWillDisappear:(BOOL)animated{
    //当界面弹出的时候，断开网络链接
    [_request disconnect];
    
}




- (void)_createTableView{
    
    _tableView = [[CommentTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.weiboModel = self.model;
    //NSLog(@"%@",_tableView.weiboModel.text);
    
    //上拉加载
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
    [_tableView reloadData];
    
}

//加载数据
- (void)_loadData{
    
    NSString *weiboId = [self.model.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request =  [sinaWeibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
    _request.tag = 100;
    
}

//加载更多数据
- (void)_loadMoreData{
    NSString *weiboId = [self.model.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    
    //设置max_id 分页加载
    CommentModel *cm = [self.data lastObject];
    if (cm == nil) {
        return;
    }
    NSString *lastID = cm.idstr;
    [params setObject:lastID forKey:@"max_id"];
    
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request =  [sinaWeibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
    _request.tag = 102;
    
    
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeiBo;
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"网络接口 请求成功");
    
    NSArray *array = [result objectForKey:@"comments"];
    
    NSMutableArray *comentModelArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *dataDic in array) {
        CommentModel *commentModel = [[CommentModel alloc]initWithDataDic:dataDic];
        [comentModelArray addObject:commentModel];
    }
    
    
    if (request.tag == 100) {
        self.data = comentModelArray;
        
    }else if(request.tag ==102){//更多数据
        [_tableView.footer endRefreshing];
        if (comentModelArray.count > 1) {
            [comentModelArray removeObjectAtIndex:0];
            [self.data addObjectsFromArray:comentModelArray];
        }else{
            return;
        }
    }
    
    _tableView.commentDataArray = self.data;
    _tableView.commentDic = result;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  WeiBoDetailViewController.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/16.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "BaseViewController.h"
@interface WeiBoDetailViewController : BaseViewController

//评论的微博Model
@property (nonatomic,strong) WeiboModel *model;


//评论列表数据
@property(nonatomic,strong)NSMutableArray *data;
@end

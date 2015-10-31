//
//  WeiBoTableView.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/12.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface WeiBoTableView : UITableView<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) NSArray *data;

@end

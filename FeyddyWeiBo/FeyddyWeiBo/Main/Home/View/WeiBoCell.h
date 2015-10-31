//
//  WeiBoCell.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/12.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiboViewFrameLayout.h"

@interface WeiBoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *rePostLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property (nonatomic,strong) WeiboView *weiBoView;

//@property (nonatomic,strong) WeiboModel *weiBoModel;
@property (nonatomic,strong) WeiboViewFrameLayout *layout;
@end

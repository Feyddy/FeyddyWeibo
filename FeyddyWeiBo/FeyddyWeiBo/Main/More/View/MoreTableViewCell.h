//
//  MoreTableViewCell.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"
@interface MoreTableViewCell : UITableViewCell

@property(nonatomic,strong)ThemeImageView *themeImageView;
@property(nonatomic,strong)ThemeLabel *themeTextLabel;
@property(nonatomic,strong)ThemeLabel *themeNameLabel;

@end

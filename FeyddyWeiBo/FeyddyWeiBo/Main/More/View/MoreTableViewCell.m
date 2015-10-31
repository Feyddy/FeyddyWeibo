//
//  MoreTableViewCell.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "ThemeManager.h"

@implementation MoreTableViewCell

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _createSubTableView];
        [self themeChangeAction];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}


#pragma mark - 自定义cell上面的子视图
-(void)_createSubTableView
{
    _themeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    
    _themeTextLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(_themeImageView.bounds.size.width+5, 10, 200, 20)];
    _themeTextLabel.backgroundColor = [UIColor clearColor];
    _themeTextLabel.colorName = @"More_Item_Text_color";
    
    _themeNameLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(self.bounds.size.width -120, 10, 110, 20)];
    _themeNameLabel.backgroundColor = [UIColor clearColor];
    _themeNameLabel.colorName = @"More_Item_Text_color";
    _themeNameLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_themeImageView];
    [self.contentView addSubview:_themeTextLabel];
    [self.contentView addSubview:_themeNameLabel];
}

- (void)themeChangeAction {
    //接收到通知 改变cell背景颜色
    self.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
    
}


@end

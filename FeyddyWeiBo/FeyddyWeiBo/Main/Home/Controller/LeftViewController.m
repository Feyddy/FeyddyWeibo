//
//  LeftViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/10.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "LeftViewController.h"
#import "ThemeLabel.h"
#import "ThemeImageView.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_leftTableView;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建表视图
    [self _createTableView];
    
}

//每次出现的时候重新刷新数据
- (void)viewWillAppear:(BOOL)animated{
    [self _loadImage];
    [_leftTableView reloadData];
    
}

#pragma mark - 创建表视图
- (void)_createTableView
{
    _leftTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _leftTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_leftTableView];
    
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 60;
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    else if(section == 0)
    {
        return 0;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0,100, cell.bounds.size.height)];
            label.text = @"无";
            label.colorName = @"More_Item_Text_color";
            [cell.contentView addSubview:label];

            
        }
        else if(indexPath.row == 1) {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0, 100, cell.bounds.size.height)];
            label.text = @"偏移";
            label.colorName = @"More_Item_Text_color";

            [cell.contentView addSubview:label];

        }
        else if (indexPath.row == 2)
        {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0, 100, cell.bounds.size.height)];
            label.text = @"偏移&缩放";
            label.colorName = @"More_Item_Text_color";

            [cell.contentView addSubview:label];
        }
        else if (indexPath.row == 3)
        {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0, 100, cell.bounds.size.height)];
            label.text = @"旋转";
            label.colorName = @"More_Item_Text_color";

            [cell.contentView addSubview:label];
        }
        else if (indexPath.row == 4)
        {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0, 100, cell.bounds.size.height)];
            label.text = @"视差";
            label.colorName = @"More_Item_Text_color";

            [cell.contentView addSubview:label];
        }
    }
    else if(indexPath.section == 2) {
        
        if (indexPath.row == 0)
        {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0, cell.bounds.size.width-50, cell.bounds.size.height)];
            label.text = @"小图";
            label.colorName = @"More_Item_Text_color";

            [cell.contentView addSubview:label];
        }
        else if (indexPath.row == 1)
        {
            ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(5, 0, cell.bounds.size.width-50, cell.bounds.size.height)];
            label.text = @"大图";
            label.colorName = @"More_Item_Text_color";

            [cell.contentView addSubview:label];
        }
        
    }

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 80)];
        label.text = @"界面切换效果";
        label.font = [UIFont systemFontOfSize:20];
        label.colorName = @"More_Item_Text_color";

        return label;
    }
    else if (section == 2)
    {
    ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 40)];
    label.text = @"图片浏览模式";
    label.font = [UIFont systemFontOfSize:20];
    label.colorName = @"More_Item_Text_color";

    return label;
    }
    return nil;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 100;
    }
    return 0;
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

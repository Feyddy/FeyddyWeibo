//
//  WeiBoTableView.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/12.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "WeiBoTableView.h"
#import "WeiBoCell.h"
#import "WeiboViewFrameLayout.h"
#import "WeiBoDetailViewController.h"
#import "UIView+UIViewController.h"


@implementation WeiBoTableView



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
//        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        UINib *nib = [UINib nibWithNibName:@"WeiBoCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"WeiBoCell"];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiBoCell *cell = (WeiBoCell *)[tableView dequeueReusableCellWithIdentifier:@"WeiBoCell"forIndexPath:indexPath];
//    WeiboModel *model = _data[indexPath.row];
    
//    cell.textLabel.text = model.text;
    
    
//    cell.commentLabel.text = [model.commentsCount stringValue];
    
//    cell.weiBoModel = model;
    
//    cell.backgroundColor = [UIColor clearColor];
    WeiboViewFrameLayout *layout =  _data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layout = layout;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboViewFrameLayout *layout =  _data[indexPath.row];
    
    return layout.frame.size.height + 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiBoDetailViewController *detailVC = [[WeiBoDetailViewController alloc] init];
    WeiboViewFrameLayout *layout = _data[indexPath.row];
    WeiboModel *model = layout.model;
    detailVC.model = model;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
    
}






@end

//
//  WeiBoCell.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/12.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "WeiBoCell.h"
#import "UIImageView+WebCache.h"

@implementation WeiBoCell

- (void)awakeFromNib {
    // Initialization code
    [self _createSubView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setWeiBoModel:(WeiboModel *)weiBoModel
//{
//    if (_weiBoModel != weiBoModel) {
//        _weiBoModel = weiBoModel;
//        
//        [self setNeedsLayout];
//    }
//}


- (void)_createSubView{
    
    _weiBoView = [[WeiboView alloc] init];
    [self.contentView addSubview:_weiBoView];
    
}

- (void)setLayout:(WeiboViewFrameLayout *)layout{
    if (_layout  != layout) {
        _layout = layout;
        _weiBoView.layout = _layout;
        
        [self setNeedsLayout];
        
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
     WeiboModel *_weiBoModel = _layout.model;
    //01 头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_weiBoModel.userModel.profile_image_url]];
    //02 昵称
    _nickNameLabel.text = _weiBoModel.userModel.screen_name;
    //03 评论
    NSString *commentCount = [_weiBoModel.commentsCount stringValue];
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",commentCount];
    
    //04 转发
    NSString *repostCount = [_weiBoModel.repostsCount stringValue];
    _rePostLabel.text = [NSString stringWithFormat:@"转发:%@",repostCount];
    
    //05 来源
    _sourceLabel.text = _weiBoModel.source;
    
    //06 对weiboView 进行布局 显示
    _weiBoView.frame = _layout.frame;
    
}



@end

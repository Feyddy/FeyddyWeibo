//
//  ThemeImageView.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"
@implementation ThemeImageView

//手动销毁观察者对象
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //注册通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
        }
    return self;
}

//当图片名字 切换的时候 重新向主题管家获取图片
-(void)setImageName:(NSString *)imageName
{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self _loadImage];
    }
}

//接收到通知
-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}

-(void)_loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:_imageName];
    UIImage *tempImage =  [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapWidth];
    if (image != nil) {
        self.image = tempImage;
    }
    
    //image = []

}


@end

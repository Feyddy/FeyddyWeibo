//
//  ThemeButton.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton


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



//接收到通知
-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}


-(void)setNormalImageName:(NSString *)normalImageName
{
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = normalImageName;
        [self _loadImage];
    }
}

-(void)setBgNormalImageName:(NSString *)bgNormalImageName
{
    if (![_bgNormalImageName isEqualToString:bgNormalImageName]) {
        _bgNormalImageName = bgNormalImageName;
        [self _loadImage];
    }
}

-(void)setHighLightImageName:(NSString *)highLightImageName
{
    if (![_highLightImageName isEqualToString:highLightImageName]) {
        _highLightImageName = highLightImageName;
        [self _loadImage];
    }
}

-(void)_loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    if (_normalImageName != nil) {
        UIImage *image = [manager getThemeImage:_normalImageName];
        if (image != nil) {
            
            [self setImage:image forState:UIControlStateNormal];
        }
    }
    if (_bgNormalImageName != nil) {
        UIImage *image = [manager getThemeImage:_bgNormalImageName];
        if (image != nil) {
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    
    if (_highLightImageName != nil) {
        UIImage *image = [manager getThemeImage:_highLightImageName];
        if (image != nil) {
            
            [self setImage:image forState:UIControlStateHighlighted];
        }
    }

    
}



@end

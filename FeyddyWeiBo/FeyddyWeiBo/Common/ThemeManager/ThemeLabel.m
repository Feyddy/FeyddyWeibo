//
//  ThemeLabel.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"
@implementation ThemeLabel

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotification object:nil];
}

-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadColor];
}

-(void)setColorName:(NSString *)colorName
{
    if (![_colorName isEqualToString:colorName]) {
        _colorName = colorName;
        [self _loadColor];
    }
}


-(void)_loadColor
{
    ThemeManager *manager = [ThemeManager shareInstance];
    
    self.textColor = [manager getThemeColor:_colorName];
}
@end

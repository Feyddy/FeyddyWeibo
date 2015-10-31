//
//  ThemeManager.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
{
    NSDictionary *_themeConfig;//theme.plist文件内容
    NSDictionary *_colorConfig;//每个主题目录下 config.plist内容（颜色值）
}

//只创建一个管理对象
+ (ThemeManager *)shareInstance
{
    static ThemeManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
    
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

//初始化的时候读取plist文件内容
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        //设置默认主题名，有优先从本地文件读取
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        
        if (_themeName.length == 0) {
    
            //设置默认的主题包名
            _themeName = @"Cat";
        }
        
        
        //_themeConfig 字典存储 主题名 与主题包 路径的对应关系
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        
        //读取颜色配置
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
    }
    return self;
}

//当主题名修改时发送通知
-(void)setThemeName:(NSString *)themeName
{
    if (![_themeName isEqualToString:themeName])
    {
        _themeName = [themeName copy];
        
        //把主题数据保存到持久化文件中
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //重新读取颜色配置文件
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        
        //当主题名字改变时，发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
    }
    
}

//获取主题图片的图片名
- (UIImage *)getThemeImage:(NSString *)imageName
{
    //01得到主题包的路径
    NSString *themePath = [self themePath];
    
    //02拼接主题路径+imageName
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    
    //03得到UIImage
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

- (UIColor *)getThemeColor:(NSString *)colorName
{
    if (colorName.length == 0) {
        return  nil;
    }
    //获取 配置文件中  rgb值
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    CGFloat r  = [rgbDic[@"R"] floatValue];
    CGFloat g  = [rgbDic[@"G"] floatValue];
    CGFloat b  = [rgbDic[@"B"] floatValue];
    
    CGFloat alpha = 1;

    if (rgbDic[@"alpha"] != nil) {
        alpha = [rgbDic[@"alpha"] floatValue];
    }
    //通过rgb值创建UIColor对象
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    
    return color;

}

//拼接主题包的路径
-(NSString *)themePath
{
    //bundle主题包的资源根路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    //在_themeConfig字典中 获取主题名字 对应的主题包路径后缀
    NSString *suffixPath = [_themeConfig objectForKey:_themeName];
    
    //最终的完整路径
    NSString *filePath = [resourcePath stringByAppendingPathComponent:suffixPath];
    
    return filePath;
}

@end

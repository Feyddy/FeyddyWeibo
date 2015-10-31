//
//  ThemeManager.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/9.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotification @"kThemeDidChangeNotification"
#define kThemeName @"kThemeName"
@interface ThemeManager : NSObject

@property (nonatomic,copy) NSString *themeName;//主题名称

+ (ThemeManager *)shareInstance;//单例

- (UIImage *)getThemeImage:(NSString *)imageName;
- (UIColor *)getThemeColor:(NSString *)colorName;


@end

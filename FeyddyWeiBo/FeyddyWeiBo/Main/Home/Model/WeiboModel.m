//
//  WeiboModel.m
//  XSWeibo
//
//  Created by gj on 15/9/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel


- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    return mapAtt;
}

- (void)setAttributes:(NSDictionary*)dataDic{
    
    [super setAttributes:dataDic];
    
    
    
    //01 微博来源处理
    //<a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
    if (_source != nil) {
        NSString *str = @">.+<";
        NSArray *array = [_source componentsMatchedByRegex:str];
        
        if (array.count != 0) {
            NSString *string = array[0];
            string = [string substringWithRange:NSMakeRange(1, string.length - 2)];
            
            _source = [NSString stringWithFormat:@"来源:%@",string];
        }
    }
    
    
    //用户信息解析
    NSDictionary *userDic  = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
            _userModel = [[UserModel alloc] initWithDataDic:userDic];
    }
    
    //被转发的微博
    NSDictionary *reWeiBoDic = [dataDic objectForKey:@"retweeted_status"];
    if (reWeiBoDic != nil) {
         _reWeiboModel = [[WeiboModel alloc] initWithDataDic:reWeiBoDic];
        //02 转发微博的用户的名字处理,拼接字符串
        NSString *name =  _reWeiboModel.userModel.name;
        _reWeiboModel.text = [NSString stringWithFormat:@"@%@:%@",name,_reWeiboModel.text];
    }
    
    // 表情处理
    // 03 -----表情处理---------
    //我喜欢哈哈[兔子]----》我喜欢哈哈<image usl = '1.png'>
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceItems =  [_text componentsMatchedByRegex:regex];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray  *faceConfigArray = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString *faceName in faceItems) {
        //faceName '兔子'
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        
        NSArray *items = [faceConfigArray filteredArrayUsingPredicate:predicate];
        if (items.count > 0) {
            NSString *imageName = [items[0] objectForKey:@"png"];
            
            // <image usl = '1.png'>
            
            NSString *urlStr = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            
            _text =  [_text stringByReplacingOccurrencesOfString:faceName withString:urlStr];
            
        }
        
    }

   
    
}


@end

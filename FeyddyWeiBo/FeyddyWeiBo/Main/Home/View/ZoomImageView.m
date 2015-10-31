//
//  ZoomImageView.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/17.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
@implementation ZoomImageView
{
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_data;
    MBProgressHUD *_hud;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        //添加手势
        [self tapAction];
        
        //创建GIF
        [self createGif];
        
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        //添加手势
        [self tapAction];
        
        //创建GIF
        [self createGif];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //01   添加手势
        [self tapAction];
        //02  gif图片
        [self createGif];
    }
    return  self;
    
    
}

- (void)tapAction
{
//    self.hidden = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    
    [self addGestureRecognizer:tap];
}


- (void)createGif
{
    _iconView = [[UIImageView alloc ]init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif.png"];
    _iconView.hidden = YES;
    [self addSubview:_iconView];
}

- (void)zoomIn
{
    
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    //创建视图
    [self createView];
    
    //计算
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _imageView.frame = frame;
    
    //动画效果
    [UIView animateWithDuration:0.3
                     animations:^{
                         _imageView.frame = _scrollView.frame;
                     } completion:^(BOOL finished) {
                         _scrollView.backgroundColor = [UIColor blackColor];
                         _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
                         _hud.mode = MBProgressHUDModeDeterminate;
                         _hud.progress = 0.0;
                         [self downloadImage];
                     }];
}

- (void)createView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = self.image;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
    _scrollView.userInteractionEnabled = YES;
    [_scrollView addGestureRecognizer:tap2];
}

- (void)zoomOut
{
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    [_connection cancel];
    _scrollView.backgroundColor = [UIColor clearColor];
    //计算
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    //动画效果
    [UIView animateWithDuration:0.3
                     animations:^{
                         _imageView.frame = frame;
                         
                         _imageView.top += _scrollView.contentOffset.y;
                     } completion:^(BOOL finished) {
                         [_scrollView removeFromSuperview];
                         _scrollView = nil;
                         _imageView = nil;
                         self.hidden = NO;
                     }];
}

-(void)downloadImage
{
    if (_imageUrlString.length != 0) {
        NSURL *url = [NSURL URLWithString:_imageUrlString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //获取响应头
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSDictionary *headFileds = [httpResponse allHeaderFields];
   // NSLog(@"%@",headFileds);
    NSString *length = [headFileds objectForKey:@"Content-Length"];
    _length = [length doubleValue];
    
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    CGFloat progress = _data.length/_length;
    _hud.progress = progress;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完成");
    UIImage *image = [UIImage imageWithData:_data];
    _imageView.image = image;
    [_hud hide:YES];
    
    //尺寸处理
    // kScreenWidth/length = image.size.width/image.size.height
    
    CGFloat length = image.size.height/image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
        }];
        
    }
    
    
    if (self.isGif) {
        [self gifImageShow];
    }
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    [_scrollView addGestureRecognizer:tap];

}
#pragma mark - 保存图片到相册
-(void)longTapAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        //弹出提示框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        UIImage *img = _imageView.image;
        //  将大图图片保存到相册
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}
//保存成功调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];

}



- (void)gifImageShow{
    //1. ----------------webview播放-------------------------
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
    //
    //    webView.userInteractionEnabled = NO;
    //    webView.scalesPageToFit = YES;
    //
    //    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //    [_scrollView addSubview:webView];
    
    
    
    
    //2. ---------使用ImageIO 提取GIF中所有帧的图片进行播放---------------
    //#import <ImageIO/ImageIO.h>
    //>> 01创建图片源
    
    //    CGImageSourceRef source  =  CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    //    //>> 02 获取图片源中的图片个数
    //    size_t  count =  CGImageSourceGetCount(source);
    //
    //    NSMutableArray *images = [[NSMutableArray alloc] init];
    //
    //
    //    for (size_t i = 0; i<count; i++) {
    //
    //        //03 获取每一张图片
    //        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
    //        UIImage *uiImage = [UIImage imageWithCGImage:image];
    //        [images addObject:uiImage];
    //        CGImageRelease(image);
    //
    //    }
    
    //04 imageView 播放图片数组
    
    //>>04-1 第一种方式播放图片
    //    _fullImageView.animationImages = images;
    //    _fullImageView.animationDuration = images.count*0.1;
    //    [_fullImageView startAnimating];
    //>>04-2 第二种播放方式
    //    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:images.count*0.1];
    //    _fullImageView.image = animatedImage;
    
    
    
    //3. ---------三方框架如 SDWebImage 封装的GIF播放------------------
    //#import "UIImage+GIF.h"
    //+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;
    
    _imageView.image = [UIImage sd_animatedGIFWithData:_data];
    
}

@end

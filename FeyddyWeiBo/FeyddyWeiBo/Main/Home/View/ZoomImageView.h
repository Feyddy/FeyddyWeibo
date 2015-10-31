//
//  ZoomImageView.h
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/17.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>

@optional

//图片将要放大

- (void)imageWillZoomIn:(ZoomImageView *)imageView;

//将要缩小
- (void)imageWillZoomOut:(ZoomImageView *)imageView;
//已经放大
//已经缩小
//....
@end
@interface ZoomImageView : UIImageView<NSURLConnectionDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}
@property (nonatomic,weak) id<ZoomImageViewDelegate> delegate;
@property (nonatomic,copy) NSString *imageUrlString;

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,assign) BOOL isGif;
@end

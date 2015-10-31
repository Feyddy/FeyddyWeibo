//
//  SendViewController.m
//  FeyddyWeiBo
//
//  Created by Mac on 15/10/19.
//  Copyright (c) 2015年 Feyddy. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#include "DataService.h"
#import "AFHTTPRequestOperation.h"


@interface SendViewController ()
@end
@implementation SendViewController
{
UIImage *_sendImage;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}



- (void)keyBoardWillShow:(NSNotification *)notification
{
    //取出键盘的frame，这个frame是相对window的
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [bounsValue CGRectValue];
    
    //键盘的高度
    CGFloat height = frame.size.height;
    
    //调整编辑栏的高度
    _editView.bottom = kScreenHeight - height- 64;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createNavItem];
    [self _createEditView];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated ];
    //弹出键盘
    [_textView becomeFirstResponder];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航栏不透明，当导航栏不透明的时候 ，子视图的y的0位置在导航栏下面
    self.navigationController.navigationBar.translucent = NO;
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    //设置textView 内容偏移
    //   _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
}

#pragma mark - createView

-(void)_createNavItem
{
    //关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    closeButton.normalImageName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    
    //发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    sendButton.normalImageName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)_createEditView
{
    //创建文本视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [[UIColor grayColor]CGColor];
    _textView.layer.cornerRadius = 10;
    [self.view addSubview:_textView];
    
    //编辑工具
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editView];
    
    //循环创建五个button
    NSArray *buttonImages = @[@"compose_toolbar_1.png",
                              @"compose_toolbar_4.png",
                              @"compose_toolbar_3.png",
                              @"compose_toolbar_5.png",
                              @"compose_toolbar_6.png"];
    //计算按钮的宽度
    CGFloat buttonWidth = kScreenWidth / buttonImages.count;
    
    for (int i = 0; i < buttonImages.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+i * buttonWidth, 20, 40, 33)];
        button.normalImageName = buttonImages[i];
        button.tag = i;
        [button addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:button];
    }
    
    //创建label显示位置信息
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _locationLabel.hidden = YES;
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.backgroundColor = [UIColor grayColor];
    [_editView addSubview:_locationLabel];
    
}

#pragma mark - buttonAction 
- (void)closeButtonAction:(ThemeButton *)button
{
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendButtonAction:(ThemeButton *)button
{
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }
    else if(text.length > 140) {
        error = @"微博内容大于140字符";
    }
    //弹出提示错误信息
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    
    
   AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
        NSLog(@"%@",result);
//        [self shouTipWindow:@"发送成功" show:NO];
       [self shouTipWindow:@"发送成功" show:NO operation:nil];
    }];
    
    [self shouTipWindow:@"发送中。。。" show:YES operation:operation];
//    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)editButtonAction:(ThemeButton *)button
{
    if (button.tag == 0) {

        //选择照片
        [self _selectedPhoto];
    }else if (button.tag == 3){
        //显示位置
        [self _location];
        
    }else if(button.tag == 4) {  //显示、隐藏表情
        
        
    }
}


- (void)_selectedPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerControllerSourceType sourceType;
    //选择相机 或者 相册
    if (buttonIndex == 0) {//拍照
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        
    }else if(buttonIndex == 1){ //选择相册
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else{
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}


//照片选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //2 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //3 显示缩略图
    
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc] init];
        // _zoomImageView = [[ZoomImageView alloc] initWithImage:image];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView];
        
        _zoomImageView.delegate = self;
        
        
    }
    _zoomImageView.image = image;
    _sendImage = image;
    
}



#pragma mark - 图片放大缩小通知
- (void)imageWillZoomOut:(ZoomImageView *)imageView{
    [_textView becomeFirstResponder];
    
}

- (void)imageWillZoomIn:(ZoomImageView *)imageView{
    
    [_textView resignFirstResponder];
}

#pragma mark - 地理位置

- (void)_location{
    /*
     修改 info.plist 增加以下两项
     NSLocationWhenInUseUsageDescription  BOOL YES
     NSLocationAlwaysUsageDescription         string “提示描述”
     */
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        //判断系统版本信息 ，如果大于8.0 则调用以下方法获取授权
        if (kVersion > 8.0) {
            
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //停止定位
    [manager stopUpdatingLocation];
    //取得地理位置信息
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D  coordinate =  location.coordinate;//获取经纬度
    
    NSLog(@"经度 ：%lf,纬度： %lf",coordinate.longitude,coordinate.latitude);
    
    
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:coordinateStr forKey:@"coordinate"];

    __weak SendViewController *weakSelf = self;
    
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *geos = [result objectForKey:@"geos"];
        if (geos.count > 0) {
            NSDictionary *geoDic = [geos lastObject];
            
            NSString *addr = [geoDic objectForKey:@"address"];
            NSLog(@"地址 %@",addr);
//            NSLog(@"")
            
            
            __strong SendViewController *strongSelf = weakSelf;
            
            strongSelf->_locationLabel.hidden = NO;
            
            strongSelf->_locationLabel.text = addr;
        }
        
    }];
    
    
    //二 iOS内置 反编码
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *place = [placemarks lastObject];
        NSLog(@"%@",place.name);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

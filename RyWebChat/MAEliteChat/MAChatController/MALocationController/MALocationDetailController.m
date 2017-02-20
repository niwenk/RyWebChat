//
//  MALocationDetailController.m
//  MAWebChat
//
//  Created by nwk on 2017/1/16.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MALocationDetailController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Masonry.h"
#import "MAConfig.h"


@interface MALocationDetailController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKPoiSearch *_poiSearch;    //poi搜索
}
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locService;

@property(nonatomic,assign)CLLocationCoordinate2D currentCoordinate;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) UILabel *addressLabel;

@end

@implementation MALocationDetailController

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title address:(NSString *)address {
    self = [super init];
    if (self) {
        self.currentCoordinate = coordinate;
        self.titleStr = title;
        self.address = address;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    [self configUI];
    [self startLocation];
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.backgroundColor = [UIColor whiteColor];
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.numberOfLines = 0;
        
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
        paraStyle01.headIndent = 0.0f;//行首缩进
        //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
        CGFloat emptylen = _addressLabel.font.pointSize * 1;
        paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
        paraStyle01.tailIndent = 0.0f;//行尾缩进
        paraStyle01.lineSpacing = 2.0f;//行间距
        
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.address attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        
        _addressLabel.attributedText = attrText;
    }
    
    return _addressLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate =self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate =nil;// 不用时，置nil
    self.locService.delegate =nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)configUI
{
    WS(ws);
    
    [self.view addSubview:self.addressLabel];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.bottom.equalTo(ws.view.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    
    [self.view addSubview:self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.top.equalTo(ws.view.mas_top);
        make.bottom.equalTo(ws.addressLabel.mas_top);
    }];
    
    [self startLocation];
}

-(void)startLocation
{
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation =NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode =BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation =YES;//显示定位图层
}

- (void)addAnnotation {
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc]init];
    
    point.coordinate = self.currentCoordinate;
    point.title = self.titleStr;
    
    [self.mapView addAnnotation:point];
    
    [self showCenterMap:self.currentCoordinate];
}
//显示大头针范围 -》》》》》》》》》》经纬度需判断
-(void) showCenterMap:(CLLocationCoordinate2D)coordinate {
    BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(coordinate,0.3, 0.3);//范围
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}
BMKCoordinateRegion BMKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D coordinate,int latitudeDelta,int longitudeDelta)
{
    BMKCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    
    BMKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    
    return region;
}
#pragma mark - BMKMapViewDelegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
    [self.mapView updateLocationData:userLocation];
    [self.locService stopUserLocationService];
    
    [self addAnnotation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"1111");
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"map view: click blank");
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"2222");
}
- (void)mapStatusDidChanged:(BMKMapView *)mapView {
    NSLog(@"3333");
}

#pragma mark - InitMethod

-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
        _mapView.zoomEnabled=YES;
        _mapView.zoomEnabledWithTap=NO;
        _mapView.zoomLevel=17;
    }
    return _mapView;
}

-(BMKLocationService*)locService
{
    if (_locService==nil)
    {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}
@end

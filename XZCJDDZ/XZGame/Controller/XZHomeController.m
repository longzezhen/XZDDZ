//
//  XZHomeController.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZHomeController.h"
#import "XZGameViewController.h"
#import "XZTongView.h"
#import "XZPpView.h"

@interface XZHomeController ()
{
    NSInteger textInt;
}
@property (nonatomic, strong) UIButton *home_set;
@property (nonatomic, strong) XZTongView *mapView;
@property (nonatomic, strong) XZPpView *ppView;

@end

@implementation XZHomeController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //通过后刷新当前的位置
    [self.mapView refreshCurrent];
}

-(void)refresh
{
    [[TimeDownObj shareClient] jsStarCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [XZZN_C addObserver:self selector:@selector(refresh) name:@"refreshEnterForeground" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self initData];

}

-(void)initUI
{
    [self.mapView initMapViewFrom:self.view block:^(NSInteger currentNum, BOOL isPass, BOOL isCurrent) {
        
        XZWeakSelf
        //已经通关
        if (isPass) {
            [self.ppView AddRemindTest:@"Has passed this level,re-entering\ndoes not consume physical strength" titleStr:@"Remind" block:^(BOOL isSuc) {
                weakSelf.ppView = nil;
                if (isSuc) {
                    #pragma mark - 已经通关 不消耗能量
                    //开始游戏
                    [AppDelegate shareDelegate].paipuNumber = currentNum;
                    XZGameViewController *gCon = [[XZGameViewController alloc] init];
                    [self presentViewController:gCon animated:YES completion:nil];
                }
            }];
            
        }else{
            //当前关卡
            if (isCurrent) {
                NSString *titleS = @"";
                if (currentNum < 12) {
                    titleS = [NSString stringWithFormat:@"Gemini-%ld",currentNum+1];
                }else{
                    titleS = [NSString stringWithFormat:@"Taurus-%ld",currentNum+1];
                }
                [self.ppView AddStarViewWithTitle:titleS block:^(BOOL isSuc) {
                    weakSelf.ppView = nil;
                    if (isSuc) {
                        if ([[TimeDownObj shareClient] counDownStars] <= 0) {
                            [MBProgressHUD showText:@"There's no energy!" toView:self.view];
                        }else{
                            #pragma mark - 前往通关 消耗一个能量 开始计时
                            [[TimeDownObj shareClient] startCountDown];
                            //开始游戏
                            [AppDelegate shareDelegate].paipuNumber = currentNum;
                            XZGameViewController *gCon = [[XZGameViewController alloc] init];
                            [self presentViewController:gCon animated:YES completion:nil];
            
                            
                        }
                        
                    }
                }];
                
            }else{
                [MBProgressHUD showText:@"Pass the current level first" toView:self.view];
            }
            
        }
    }];
    
    [self.view addSubview:self.home_set];
    [[TimeDownObj shareClient] setStarWithView:self.view];
    
}

-(void)initData
{
    
}

#pragma mark - Click
-(void)homeSetClick
{
    [[XZMusicNSObject initClient] playBgMusic];
    [[XZClassView shareClient] showSetViewBlock:^{

    }];
}


#pragma mark - lazy
#pragma mark -
-(UIButton *)home_set
{
    if (!_home_set) {
        _home_set = [[UIButton alloc] initWithFrame:CGRectMake(XZWidth(self.view)-Auto_Width(20)/2-Auto_Width(100)/2, XZNavigation_TopHeight+Auto_Height(16)/2, Auto_Width(100)/2, Auto_Width(74)/2)];
        [_home_set setBackgroundImage:XZImageName(@"home_set") forState:0];
        [_home_set addTarget:self action:@selector(homeSetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _home_set;
}

-(XZTongView *)mapView
{
    if (!_mapView) {
        _mapView = [[XZTongView alloc] init];
        
    }
    return _mapView;
}

-(XZPpView *)ppView
{
    if (!_ppView) {
        _ppView = [[XZPpView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_ppView];
    }
    return _ppView;
}


@end

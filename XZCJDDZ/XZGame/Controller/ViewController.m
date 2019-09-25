//
//  ViewController.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import "ViewController.h"
#import "XZHomeController.h"

@interface ViewController ()
{
    NSTimer *_downTimer;
    CGFloat countD;
}
@property (nonatomic, strong) UIImageView *pBgImgV;

@end

@implementation ViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (_downTimer) {
        [_downTimer invalidate];
        _downTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self initData];

}


-(void)initUI
{
    [self.view addSubview:self.pBgImgV];
}

-(void)initData
{
    countD = 0;
    if (!_downTimer) {
        _downTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(downCount)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_downTimer forMode:NSRunLoopCommonModes];
        [_downTimer fire];
    }
}

#pragma mark - 加载
-(void)downCount
{
    countD = countD + 1;
    
    if (countD >= 2) {
        if (_downTimer) {
            [_downTimer invalidate];
            _downTimer = nil;
        }


        XZHomeController * vc = [XZHomeController new];
        [self presentViewController:vc animated:YES completion:nil];

    }
}

#pragma mark - lazy
#pragma mark -
-(UIImageView *)pBgImgV
{
    if (!_pBgImgV) {
        _pBgImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_pBgImgV setImage:IS_IPhoneX_All?XZImageName(@"XZStartBG_X"):XZImageName(@"XZStartBG")];
    }
    return _pBgImgV;
}

@end

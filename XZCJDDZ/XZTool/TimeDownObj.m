//
//  TimeDownObj.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#define BtnTag 10290

#import "TimeDownObj.h"

@interface TimeDownObj ()
{
    NSInteger countss;
    UIView *_selfView;
}
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) TimeDownBlock block;

@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation TimeDownObj

+(TimeDownObj *)shareClient
{
    static TimeDownObj *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[TimeDownObj alloc] init];
        
        [client initCustom];
    });
    
    return client;
}

-(void)initCustom
{

}


-(void)downCount
{

    [AppDelegate shareDelegate].currentCount --;
//
//    NSLog(@"  -- %ld",(long)[AppDelegate shareDelegate].currentCount);
    countss = [AppDelegate shareDelegate].currentCount;

    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(countss%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",countss%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    self.timeLbl.text = [NSString stringWithFormat:@"%@",format_time];
    
    //保存当前倒计时秒数
    NSString *countssStr = [NSString stringWithFormat:@"%ld",countss];
    XZSET_CACHE(countssStr, XZ_Save_CurrentSec);
    
    if (countss <= 0) {
        //当前如果有不足的就补充能量
        if ([self counDownStars] < XZ_StarCount) {
            [self FullCurrentStar];
            //保存当前有多少个星星能量
            NSString *csStr = [NSString stringWithFormat:@"%ld",[self counDownStars]];
            XZSET_CACHE(csStr, XZ_Save_StarCount);
            
            if ([self counDownStars] == XZ_StarCount) {
                [self stopTimer];
                self.timeLbl.text = [NSString stringWithFormat:@"FULL"];
            }
            [AppDelegate shareDelegate].currentCount = XZ_CountSec;
            
        }else{
            [self stopTimer];
            self.timeLbl.text = [NSString stringWithFormat:@"FULL"];
        }
        
        [XZZN_C postNotificationName:XZ_Noti_Star object:nil];
        
    }
}

//填满当前星星
-(void)FullCurrentStar
{
    for (int i = 0; i < XZ_StarCount; i++) {
        UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
        if (!btn.selected) {
            btn.selected = YES;
            break;
        }
    }
}


//计算还有多少星星没有填满
-(NSInteger)counDownNoStars
{
    NSInteger count = 0;
    for (int i = 0; i < XZ_StarCount; i++) {
        UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
        if (!btn.selected) {
            count ++;
        }
    }
    return count;
}


//计算填满星的数量
-(NSInteger)counDownStars
{
    NSInteger count = 0;
    for (int i = 0; i < XZ_StarCount; i++) {
        UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
        if (btn.selected) {
            count ++;
        }
    }
    return count;
}

//消耗当前能量值
-(void)consumeStar
{
    if ([self counDownStars] <= 0) {
        [MBProgressHUD showText:@"There's no energy!" toView:_selfView];
        return;
    }
    
    for (int i = XZ_StarCount-1; i >= 0; i--) {
        UIButton *btn = (UIButton *)[self.timeView viewWithTag:i+BtnTag];
        if (btn.selected){
            btn.selected = NO;
            break;
        }
    }
}

//开始初始化
-(void)setStarWithView:(UIView *)selfView
{
//    self.block = block;
    _selfView = selfView;
    [selfView bringSubviewToFront:self.timeView];
    [self jsStarCount];
}

-(void)startCountDown
{
    if ([self counDownStars] <= 0) {
        [MBProgressHUD showText:@"There's no energy!" toView:_selfView];
        return;
    }
    
    //消耗当前一个能量
    [self consumeStar];
    //保存当前有多少个星星能量
    NSString *csStr = [NSString stringWithFormat:@"%ld",[self counDownStars]];
    XZSET_CACHE(csStr, XZ_Save_StarCount);
    
    if (![self.timer isValid]) {
        [self.timer fire];
    }
}

//
-(void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}



-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(downCount)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    return _timer;
}

-(UIView *)timeView
{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(Auto_Width(20)/2, XZNavigation_TopHeight+Auto_Height(16)/2, Auto_Width(480)/2, Auto_Width(74)/2)];
        _timeView.backgroundColor = [UIColor clearColor];
        [_selfView addSubview:_timeView];
        
        UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:_timeView.bounds];
        [bgImgV setImage:XZImageName(@"home_star_bg")];
        [_timeView addSubview:bgImgV];
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.frame = CGRectMake(XZWidth(_timeView)-Auto_Width(30)/2-Auto_Width(110)/2, (XZHeight(_timeView)-(Auto_Width(33)/2))/2, Auto_Width(110)/2, Auto_Width(33)/2);
//        _timeLbl.textAlignment = NSTextAlignmentCenter;
        _timeLbl.text = @"FULL";
//        _timeLbl.backgroundColor = [UIColor redColor];
        _timeLbl.textColor = [UIColor whiteColor];
        _timeLbl.font = [UIFont boldSystemFontOfSize:18.];
        [_timeView addSubview:_timeLbl];
        
        CGFloat space_w = Auto_Width(10)/2;
        CGFloat left_x = Auto_Width(30)/2;
//        CGFloat xz_w = XZWidth(_timeView) - (left_x*2) - XZWidth(_timeLbl) - 10;
        CGFloat btn_w = Auto_Width(51)/2;
        CGFloat btn_h = Auto_Width(52)/2;
        for (int i = 0; i < XZ_StarCount; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left_x + (i*(btn_w+space_w)), (XZHeight(_timeView)-(btn_w))/2, btn_w, btn_h)];
            [btn setBackgroundImage:XZImageName(@"home_star_empty") forState:UIControlStateNormal];
            [btn setBackgroundImage:XZImageName(@"home_star_full") forState:UIControlStateSelected];
            btn.selected = YES;
            btn.tag = BtnTag + i;
            [_timeView addSubview:btn];
        }
    }
    return _timeView;
}

//计算时间差还有多少秒
-(void)jsStarCount
{
    //获取上次退出前的星星数量
    NSInteger starCount = [XZGET_CACHE(XZ_Save_StarCount) integerValue];
    if (starCount < 5) {
        
        //获取上次退出的时间
        NSDate *agoDate = XZGET_CACHE(XZ_Save_CurrentTime);
        //获取时间差秒数
        NSInteger cur_count = [[XZTimeManager shareClient] nowTimeAgo:agoDate];
//        NSLog(@"走了%ld秒",cur_count);
        //获取上次保存剩余的秒数
        NSInteger y_count = [XZGET_CACHE(XZ_Save_CurrentSec) integerValue];
        
        NSInteger j_c = (cur_count/XZ_CountSec);//载了多少星
        starCount = starCount + j_c;
        
        if (starCount >= 5) {
            starCount = 5;
            NSString *csStr = [NSString stringWithFormat:@"%ld",starCount];
            XZSET_CACHE(csStr, XZ_Save_StarCount);
            
            for (int i = 0; i < XZ_StarCount; i++) {
                UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
                if (i < starCount) {
                    btn.selected = YES;
                }else{
                    btn.selected = NO;
                }
            }

            self.timeLbl.text = [NSString stringWithFormat:@"FULL"];
            
            return;
        }else{
            NSString *csStr = [NSString stringWithFormat:@"%ld",starCount];
            XZSET_CACHE(csStr, XZ_Save_StarCount);
            
            //当前剩余的秒数
            NSInteger cur_sec = cur_count - (XZ_CountSec * j_c);
            
            NSInteger ii = y_count - cur_sec;
            //判断时间在倒数
            if (ii > 0) {
                //赋给当前倒计时的秒数
                [AppDelegate shareDelegate].currentCount = ii;
                
                for (int i = 0; i < XZ_StarCount; i++) {
                    UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
                    if (i < starCount) {
                        btn.selected = YES;
                    }else{
                        btn.selected = NO;
                    }
                }
                
                
                NSString *str_minute = [NSString stringWithFormat:@"%02ld",(ii%3600)/60];//分
                NSString *str_second = [NSString stringWithFormat:@"%02ld",ii%60];//秒
                NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
                
                self.timeLbl.text = [NSString stringWithFormat:@"%@",format_time];
                
                //开始倒计时
                if (![self.timer isValid]) {
                    [self.timer fire];
                }
                
            }else{
                starCount = starCount + 1;
                NSString *csStr = [NSString stringWithFormat:@"%ld",starCount];//23
                XZSET_CACHE(csStr, XZ_Save_StarCount);

                if (starCount <= 4) {
                    
                    for (int i = 0; i < XZ_StarCount; i++) {
                        UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
                        if (i < starCount) {
                            btn.selected = YES;
                        }else{
                            btn.selected = NO;
                        }
                    }
                    
                    //当前的秒数
                    NSInteger cur_sec = XZ_CountSec-labs(ii);
                    //赋给当前倒计时的秒数
                    [AppDelegate shareDelegate].currentCount = cur_sec;
                    
                    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(cur_sec%3600)/60];//分
                    NSString *str_second = [NSString stringWithFormat:@"%02ld",cur_sec%60];//秒
                    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
                    
                    self.timeLbl.text = [NSString stringWithFormat:@"%@",format_time];

                    //开始倒计时
                    if (![self.timer isValid]) {
                        [self.timer fire];
                    }
                }else{
                    
                    for (int i = 0; i < XZ_StarCount; i++) {
                        UIButton *btn = (UIButton *)[self.timeView viewWithTag:BtnTag+i];
                        if (i < starCount) {
                            btn.selected = YES;
                        }else{
                            btn.selected = NO;
                        }
                    }
                    
                    self.timeLbl.text = [NSString stringWithFormat:@"FULL"];
                    
                }
            }
        }
    }
    
}


@end

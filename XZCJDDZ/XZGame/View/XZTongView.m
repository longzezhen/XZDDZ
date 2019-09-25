//
//  XZTongView.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/23.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZTongView.h"
#import "XZMapButton.h"
#import "XZHomeModel.h"
#import "XZLine.h"

#define MAPTAG 12080

@interface XZTongView ()<UIScrollViewDelegate>
{
    NSInteger curNum;
    UIView *_selfView;
}
@property (nonatomic, copy) XZTongViewBlock block;

@property (nonatomic, strong) NSMutableArray *sourceArrayM;

@property (nonatomic, strong) NSMutableArray <XZMapButton *> *mapBtnArrayM;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *XZBgImgV;
@property (nonatomic, strong) UIImageView *XZBgImgV2;

@property (nonatomic, strong) UIImageView *home_line;
@property (nonatomic, strong) UIImageView *home_line2;

@property (nonatomic, strong) UIButton *home_left;
@property (nonatomic, strong) UIButton *home_right;

@property (nonatomic, strong) UILabel *home_name;
@property (nonatomic, strong) UILabel *home_name2;

@property (nonatomic, strong) XZLine *lineV;

@end

@implementation XZTongView

-(void)initMapViewFrom:(UIView *)selfView block:(XZTongViewBlock)block
{
    _selfView = selfView;
    
    self.block = block;
    
    [selfView addSubview:self.scrollView];
    [self.scrollView addSubview:self.XZBgImgV];
    [self.scrollView addSubview:self.XZBgImgV2];

    [self.scrollView addSubview:self.home_name];
    [self.scrollView addSubview:self.home_name2];
    
    [selfView addSubview:self.home_right];
    [selfView addSubview:self.home_left];
    
    if (self.mapBtnArrayM.count > 0) {
        [self.mapBtnArrayM removeAllObjects];
    }
    
    for (int i = 0; i < [self postionArray].count; i++) {

        CGPoint p = [[self postionArray][i] CGPointValue];

        XZMapButton *mBtn = [[XZMapButton alloc] init];
        [self.scrollView addSubview:mBtn];
        [self.scrollView bringSubviewToFront:mBtn];
        mBtn.tag = MAPTAG + i;
        [mBtn addTarget:self action:@selector(mBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        if (i > 11) {
            mBtn.frame = CGRectMake(p.x+KScreenWidth, p.y, Auto_Width(124)/2, Auto_Width(124)/2);
        }else{
            mBtn.frame = CGRectMake(p.x, p.y, Auto_Width(124)/2, Auto_Width(124)/2);
        }
        
        [self.mapBtnArrayM addObject:mBtn];
    }

}

#pragma mark - 刷新 当前状态
-(void)refreshCurrent
{
    curNum = [XZGET_CACHE(XZ_CURRENT_NUMBER) integerValue] ? : 0;
    if (self.sourceArrayM.count > 0) {
        [self.sourceArrayM removeAllObjects];
    }
    for (int i = 0; i < XZ_TongGuan_Count; i++) {
        XZHomeModel *model = [[XZHomeModel alloc] init];
        model.isCurrentPosition = NO;
        model.isSecond = NO;
        if (i < curNum) {
            model.isPass = YES;
        }else{
            model.isPass = NO;
        }
        if (i == curNum) {
            model.isCurrentPosition = YES;
        }
        if (i > 11) {
            model.isSecond = YES;
        }
        
        [self.sourceArrayM addObject:model];
    }
    
    if (self.mapBtnArrayM.count > 0) {
        [self.mapBtnArrayM enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XZMapButton *btn = (XZMapButton *)obj;
            [btn initHomeModel:self.sourceArrayM[idx]];
        }];
    }
    
//    [self refreshWeizhi:curNum];
    [self.lineV DrawDottedLineWithCurNum:curNum fromView:self.scrollView everyPArrayM:self.mapBtnArrayM];
    
}

-(void)refreshWeizhi:(NSInteger)curNum
{
    if (curNum < 12) {
        self.home_left.hidden = YES;
        self.home_right.hidden = NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        self.home_left.hidden = NO;
        self.home_right.hidden = YES;
        [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
    }
}

#pragma mark - 通关click
-(void)mBtnClick:(XZMapButton *)btn
{
    [[XZMusicNSObject initClient] playBgMusic];
    if (self.block) {
        self.block(btn.tag-MAPTAG, btn.isPass, btn.isCurrentPosition);
    }
}

-(void)fanyeClick:(UIButton *)btn
{
    [[XZMusicNSObject initClient] playBgMusic];
    if (btn.tag == 100) {
        [MBProgressHUD showText:@"Developing, please wait!" toView:_selfView];
//        [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
//        self.home_left.hidden = NO;
//        self.home_right.hidden = YES;
    }else{
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        self.home_left.hidden = YES;
//        self.home_right.hidden = NO;
    }
}

#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        self.home_left.hidden = YES;
        self.home_right.hidden = NO;
    }else if (scrollView.contentOffset.x == KScreenWidth){
        self.home_left.hidden = NO;
        self.home_right.hidden = YES;
    }
}


#pragma mark - laijiazai
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_scrollView setContentSize:CGSizeMake(KScreenWidth*2, KScreenHeight)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delaysContentTouches = NO;
        _scrollView.delegate = self;
        [_scrollView setBounces:NO];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

-(UIImageView *)XZBgImgV
{
    if (!_XZBgImgV) {
        _XZBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_XZBgImgV setImage:IS_IPhoneX_All?XZImageName(@"home_bg_X"):XZImageName(@"home_bg")];
    }
    return _XZBgImgV;
}

-(UIImageView *)XZBgImgV2
{
    if (!_XZBgImgV2) {
        _XZBgImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        [_XZBgImgV2 setImage:IS_IPhoneX_All?XZImageName(@"home_bg2_X"):XZImageName(@"home_bg2")];
    }
    return _XZBgImgV2;
}

-(UIButton *)home_left
{
    if (!_home_left) {
        _home_left = [[UIButton alloc] initWithFrame:CGRectMake(Auto_Width(20)/2,(KScreenHeight-Auto_Width(71)/2)/2, Auto_Width(53)/2, Auto_Width(71)/2)];
        [_home_left setBackgroundImage:XZImageName(@"home_fanye2") forState:0];
        [_home_left addTarget:self action:@selector(fanyeClick:) forControlEvents:UIControlEventTouchUpInside];
        _home_left.tag = 101;
        _home_left.hidden = YES;
    }
    return _home_left;
}

-(UIButton *)home_right
{
    if (!_home_right) {
        _home_right = [[UIButton alloc] initWithFrame:CGRectMake(XZWidth(_selfView)-Auto_Width(12)/2-Auto_Width(53)/2,(KScreenHeight-Auto_Width(71)/2)/2, Auto_Width(53)/2, Auto_Width(71)/2)];
        [_home_right setBackgroundImage:XZImageName(@"home_fanye") forState:0];
        [_home_right addTarget:self action:@selector(fanyeClick:) forControlEvents:UIControlEventTouchUpInside];
        _home_right.tag = 100;
    }
    return _home_right;
}

-(UIImageView *)home_line
{
    if (!_home_line) {
        _home_line = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth-Auto_Width(446)/2)/2, Auto_Height(326)/2, Auto_Width(446)/2, Auto_Width(733)/2)];
        [_home_line setImage:XZImageName(@"home_passLine")];
    }
    return _home_line;
}

-(UIImageView *)home_line2
{
    if (!_home_line2) {
        _home_line2 = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth+(KScreenWidth-Auto_Width(507)/2)/2, Auto_Height(419)/2, Auto_Width(507)/2, Auto_Width(467)/2)];
        [_home_line2 setImage:XZImageName(@"home_passLine2")];
    }
    return _home_line2;
}

-(UILabel *)home_name
{
    if (!_home_name) {
        _home_name = [[UILabel alloc] initWithFrame:CGRectMake(0, XZNavigation_TopHeight+Auto_Height(152)/2, KScreenWidth, Auto_Width(40)/2)];
        _home_name.font = IS_IPAD ? kBoldFont(35) : kBoldFont(25);
        _home_name.textColor = UIColorFromRGB(0xffffff);
        _home_name.textAlignment = NSTextAlignmentCenter;
        _home_name.text = @"Gemini";
    }
    return _home_name;
}

-(UILabel *)home_name2
{
    if (!_home_name2) {
        _home_name2 = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth, XZNavigation_TopHeight+Auto_Height(152)/2, KScreenWidth, Auto_Width(40)/2)];
        _home_name2.font = IS_IPAD ? kBoldFont(35) : kBoldFont(25);
        _home_name2.textColor = UIColorFromRGB(0xffffff);
        _home_name2.textAlignment = NSTextAlignmentCenter;
        _home_name2.text = @"Taurus";
    }
    return _home_name2;
}

-(XZLine *)lineV
{
    if (!_lineV) {
        _lineV = [[XZLine alloc] init];
    }
    return _lineV;
}

-(NSMutableArray *)sourceArrayM
{
    if (!_sourceArrayM) {
        _sourceArrayM = [NSMutableArray array];
    }
    return _sourceArrayM;
    
}

-(NSMutableArray *)mapBtnArrayM
{
    if (!_mapBtnArrayM) {
        _mapBtnArrayM = [NSMutableArray array];
    }
    return _mapBtnArrayM;
    
}

#pragma mark - xz位置x，y
-(NSArray *)postionArray
{
    CGPoint point = CGPointMake(Auto_Width(102)/2, Auto_Height(1016)/2);
    NSValue *value = [NSValue valueWithCGPoint:point];
    
    CGPoint point2 = CGPointMake(Auto_Width(252)/2, Auto_Height(885)/2);
    NSValue *value2 = [NSValue valueWithCGPoint:point2];

    CGPoint point3 = CGPointMake(Auto_Width(121)/2, Auto_Height(746)/2);
    NSValue *value3 = [NSValue valueWithCGPoint:point3];
    
    CGPoint point4 = CGPointMake(Auto_Width(172)/2, Auto_Height(561)/2);
    NSValue *value4 = [NSValue valueWithCGPoint:point4];
    
    CGPoint point5 = CGPointMake(Auto_Width(65)/2, Auto_Height(410)/2);
    NSValue *value5 = [NSValue valueWithCGPoint:point5];
    
    CGPoint point6 = CGPointMake(Auto_Width(168)/2, Auto_Height(241)/2);
    NSValue *value6 = [NSValue valueWithCGPoint:point6];
    
    CGPoint point7 = CGPointMake(Auto_Width(389)/2, Auto_Height(260)/2);
    NSValue *value7 = [NSValue valueWithCGPoint:point7];
    
    CGPoint point8 = CGPointMake(Auto_Width(580)/2, Auto_Height(415)/2);
    NSValue *value8 = [NSValue valueWithCGPoint:point8];
    
    CGPoint point9 = CGPointMake(Auto_Width(331)/2, Auto_Height(446)/2);
    NSValue *value9 = [NSValue valueWithCGPoint:point9];
    
    CGPoint point10 = CGPointMake(Auto_Width(402)/2, Auto_Height(659)/2);
    NSValue *value10 = [NSValue valueWithCGPoint:point10];
    
    CGPoint point11 = CGPointMake(Auto_Width(513)/2, Auto_Height(844)/2);
    NSValue *value11 = [NSValue valueWithCGPoint:point11];
    
    CGPoint point12 = CGPointMake(Auto_Width(424)/2, Auto_Height(1044)/2);
    NSValue *value12 = [NSValue valueWithCGPoint:point12];
    
    CGPoint point13 = CGPointMake(Auto_Width(52)/2, Auto_Height(868)/2);
    NSValue *value13 = [NSValue valueWithCGPoint:point13];
    
    CGPoint point14 = CGPointMake(Auto_Width(75)/2, Auto_Height(686)/2);
    NSValue *value14 = [NSValue valueWithCGPoint:point14];
    
    CGPoint point15 = CGPointMake(Auto_Width(266)/2, Auto_Height(605)/2);
    NSValue *value15 = [NSValue valueWithCGPoint:point15];
    
    CGPoint point16 = CGPointMake(Auto_Width(64)/2, Auto_Height(496)/2);
    NSValue *value16 = [NSValue valueWithCGPoint:point16];
    
    CGPoint point17 = CGPointMake(Auto_Width(76)/2, Auto_Height(313)/2);
    NSValue *value17 = [NSValue valueWithCGPoint:point17];
    
    CGPoint point18 = CGPointMake(Auto_Width(280)/2, Auto_Height(399)/2);
    NSValue *value18 = [NSValue valueWithCGPoint:point18];
    
    CGPoint point19 = CGPointMake(Auto_Width(460)/2, Auto_Height(311)/2);
    NSValue *value19 = [NSValue valueWithCGPoint:point19];
    
    CGPoint point20 = CGPointMake(Auto_Width(600)/2, Auto_Height(481)/2);
    NSValue *value20 = [NSValue valueWithCGPoint:point20];
    
    CGPoint point21 = CGPointMake(Auto_Width(465)/2, Auto_Height(644)/2);
    NSValue *value21 = [NSValue valueWithCGPoint:point21];
    
    CGPoint point22 = CGPointMake(Auto_Width(575)/2, Auto_Height(867)/2);
    NSValue *value22 = [NSValue valueWithCGPoint:point22];
    
    
    NSArray *postion = @[value,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20,value21,value22];
    
    return postion;
}

@end

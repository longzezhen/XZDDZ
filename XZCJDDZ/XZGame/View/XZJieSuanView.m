//
//  XZJieSuanView.m
//  XZCJDDZ
//
//  Created by df on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZJieSuanView.h"
@interface XZJieSuanView()

@end
@implementation XZJieSuanView
-(instancetype)init
{
    if (self = [super init]) {
        self.shadowView.hidden = NO;
        self.GYImageView.hidden = NO;
        self.GXOneImageView.hidden = NO;
        self.GXTwoImageView.hidden = NO;
        self.winLoseImgeView.hidden = NO;
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
    }
    return self;
}

#pragma mark - action
-(void)clickLeftButton
{
    self.clickLeftButtonBlock();
}

-(void)clickRightButton
{
    self.clickRightButtonBlock();
}


#pragma mark - get
-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        [self addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _shadowView;
}

-(UIImageView *)GYImageView
{
    if (!_GYImageView) {
        _GYImageView = [[UIImageView alloc] initWithImage:XZImageName(@"GY_lose")];
        [self addSubview:_GYImageView];
        [_GYImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(583/2, 583/2));
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(Auto_Height(-80));
        }];
    }
    return _GYImageView;
}

-(UIImageView *)GXOneImageView{
    if (!_GXOneImageView) {
        _GXOneImageView = [[UIImageView alloc] initWithImage:XZImageName(@"GXOne_lose")];
        [self addSubview:_GXOneImageView];
        [_GXOneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.GYImageView);
        }];
        
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:M_PI*2];
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.duration = 4;
        animation.repeatCount = MAXFLOAT;
        [_GXOneImageView.layer addAnimation:animation forKey:nil];
    }
    return _GXOneImageView;
}

-(UIImageView *)GXTwoImageView{
    if (!_GXTwoImageView) {
        _GXTwoImageView = [[UIImageView alloc] initWithImage:XZImageName(@"GXTwo_lose")];
        [self addSubview:_GXTwoImageView];
        [_GXTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.GYImageView);
        }];
        
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:M_PI*2];
        animation.duration = 4;
        animation.repeatCount = MAXFLOAT;
        [_GXTwoImageView.layer addAnimation:animation forKey:nil];
    }
    return _GXTwoImageView;
}

-(UIImageView *)winLoseImgeView{
    if (!_winLoseImgeView) {
        _winLoseImgeView = [UIImageView new];
        _winLoseImgeView.image = XZImageName(@"YouLose");
        [self addSubview:_winLoseImgeView];
        [_winLoseImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.GYImageView);
            make.size.mas_equalTo(CGSizeMake(523/2, 146/2));
        }];
    }
    return _winLoseImgeView;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:XZImageName(@"game_exit") forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Auto_Height(941/2));
            make.right.mas_equalTo(self.mas_centerX).mas_equalTo(Auto_Width(-20));
        }];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:XZImageName(@"Resume_lose") forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Auto_Height(941/2));
            make.left.mas_equalTo(self.mas_centerX).mas_equalTo(Auto_Width(20));
        }];
    }
    return _rightButton;
}

-(UIImageView *)winStarImageView
{
    if (!_winStarImageView) {
        NSArray * images = @[XZImageName(@"gameStar_1"),XZImageName(@"gameStar_2"),XZImageName(@"gameStar_3"),XZImageName(@"gameStar_4"),XZImageName(@"gameStar_5"),XZImageName(@"gameStar_6"),XZImageName(@"gameStar_7"),XZImageName(@"gameStar_8"),XZImageName(@"gameStar_9"),XZImageName(@"gameStar_10"),XZImageName(@"gameStar_11"),XZImageName(@"gameStar_12"),XZImageName(@"gameStar_13")];
        _winStarImageView = [UIImageView new];
        _winStarImageView.animationImages = images;
        _winStarImageView.animationDuration = 2;
        [_winStarImageView startAnimating];
        [self addSubview:_winStarImageView];
        [_winStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.GYImageView);
            make.size.mas_equalTo(CGSizeMake(750/2, 645.0/2));
        }];
    }
    return _winStarImageView;
}
@end

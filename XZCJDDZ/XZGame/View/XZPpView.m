//
//  XZPpView.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZPpView.h"

@interface XZPpView ()

@property (nonatomic, copy)XZPpViewBlock block;

@end

@implementation XZPpView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {

    }
    return self;
}

- (void)AddRemindTest:(NSString *)textStr titleStr:(NSString *)titleStr block:(XZPpViewBlock)block
{
    self.block = block;
    
    UIView *bgV = [[UIView alloc] initWithFrame:self.bounds];
    bgV.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    [self addSubview:bgV];
    
    UIImageView *imgVBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Auto_Width(590)/2, IS_IPhoneX_All?Auto_Width(452)/2:Auto_Width(452)/2)];
    imgVBg.center = XZWindow.center;
    [imgVBg setImage:XZImageName(@"pop_bg")];
    [self addSubview:imgVBg];
    
    UIImageView *tVBg = [[UIImageView alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-(Auto_Width(494)/2/2), XZMinY(imgVBg)-Auto_Width(81)/2, Auto_Width(494)/2, IS_IPhoneX_All?Auto_Width(164)/2:Auto_Width(164)/2)];
    [tVBg setImage:XZImageName(@"pop_title_bg")];
    [self addSubview:tVBg];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(imgVBg)-Auto_Width(61)/2 +Auto_Width(20)/2, XZMinY(imgVBg)-Auto_Width(18)/2, Auto_Width(61)/2, Auto_Width(62)/2)];
    [closeBtn setBackgroundImage:XZImageName(@"pop_close") forState:0];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, XZMinY(tVBg)+Auto_Width(22)/2, KScreenWidth, Auto_Width(60)/2)];
    nameLab.font = IS_IPAD ? kBoldFont(34) : kBoldFont(24);
    nameLab.textColor = UIColorFromRGB(0xffffff);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = titleStr;
    [self addSubview:nameLab];

    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(XZMinX(imgVBg)+Auto_Width(80)/2, XZMinY(imgVBg)+Auto_Width(145)/2, XZWidth(imgVBg)-Auto_Width(80), Auto_Width(76)/2)];
    tipsLab.numberOfLines = 0;
    tipsLab.font = kBoldFont(12);
    tipsLab.textColor = UIColorFromRGB(0xffffff);
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.text = textStr;
    [self addSubview:tipsLab];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-Auto_Width(20)/2-Auto_Width(230)/2, XZMaxY(imgVBg)-Auto_Width(46)/2- Auto_Width(105)/2, Auto_Width(230)/2, Auto_Width(105)/2)];
    [btnCancel setBackgroundImage:XZImageName(@"pop_cancel") forState:0];
    [btnCancel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setAdjustsImageWhenHighlighted:NO];
    btnCancel.tag = 100;
    [self addSubview:btnCancel];
    
    UIButton *btnSure = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(btnCancel)+Auto_Width(40)/2, XZMinY(btnCancel), Auto_Width(230)/2, Auto_Width(105)/2)];
    [btnSure setBackgroundImage:XZImageName(@"pop_ok") forState:0];
    [btnSure addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnSure setAdjustsImageWhenHighlighted:NO];
    btnSure.tag = 101;
    [self addSubview:btnSure];
    
    
}

- (void)AddStarViewWithTitle:(NSString *)titleStr block:(XZPpViewBlock)block
{
    self.block = block;
    
    UIView *bgV = [[UIView alloc] initWithFrame:self.bounds];
    bgV.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    [self addSubview:bgV];
    
    UIImageView *imgVBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Auto_Width(590)/2, IS_IPhoneX_All?Auto_Width(452)/2:Auto_Width(452)/2)];
    imgVBg.center = XZWindow.center;
    [imgVBg setImage:XZImageName(@"pop_bg")];
    [self addSubview:imgVBg];
    
    UIImageView *tVBg = [[UIImageView alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-(Auto_Width(494)/2/2), XZMinY(imgVBg)-Auto_Width(81)/2, Auto_Width(494)/2, IS_IPhoneX_All?Auto_Width(164)/2:Auto_Width(164)/2)];
    [tVBg setImage:XZImageName(@"pop_title_bg")];
    [self addSubview:tVBg];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(imgVBg)-Auto_Width(61)/2 +Auto_Width(20)/2, XZMinY(imgVBg)-Auto_Width(18)/2, Auto_Width(61)/2, Auto_Width(62)/2)];
    [closeBtn setBackgroundImage:XZImageName(@"pop_close") forState:0];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, XZMinY(tVBg)+Auto_Width(22)/2, KScreenWidth, Auto_Width(60)/2)];
    nameLab.font = kBoldFont(24);
    nameLab.textColor = UIColorFromRGB(0xffffff);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = titleStr;
    [self addSubview:nameLab];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(XZMinX(imgVBg)+Auto_Width(75)/2, XZMinY(tVBg)+Auto_Width(184)/2, XZWidth(imgVBg)-Auto_Width(75), Auto_Width(30)/2)];
    //    tipsLab.backgroundColor = [UIColor redColor];
    tipsLab.font = kBoldFont(14);
    tipsLab.textColor = UIColorFromRGB(0xffffff);
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.text = @"Lighting a planet requires a star";
    [self addSubview:tipsLab];
    
    UIImageView *starBg = [[UIImageView alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-(Auto_Width(500)/2/2), XZMaxY(tipsLab)+Auto_Width(30)/2, Auto_Width(500)/2, Auto_Width(122)/2)];
    [starBg setImage:XZImageName(@"pop_star_bg")];
    [self addSubview:starBg];
    
    UIImageView *starY = [[UIImageView alloc] initWithFrame:CGRectMake(XZMinX(starBg)+(Auto_Width(175)/2), XZMidY(starBg)-(Auto_Width(73)/2/2), Auto_Width(73)/2, Auto_Width(73)/2)];
    [starY setImage:XZImageName(@"pop_star")];
    [self addSubview:starY];
    
    UILabel *c_star = [[UILabel alloc] initWithFrame:CGRectMake(XZMaxX(starY)+Auto_Width(40)/2, XZMidY(starY)-(Auto_Width(35)/2/2), Auto_Width(38)/2, Auto_Width(35)/2)];
    //    tipsLab.backgroundColor = [UIColor redColor];
    c_star.font = kBoldFont(20);
    c_star.textColor = UIColorFromRGB(0xffffff);
    c_star.text = @"-1";
    [self addSubview:c_star];
    
    UIButton *statBtn = [[UIButton alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-(Auto_Width(270)/2/2), XZMaxY(starBg)+Auto_Width(40)/2, Auto_Width(270)/2, Auto_Width(96)/2)];
    [statBtn setBackgroundImage:XZImageName(@"start") forState:0];
    [statBtn addTarget:self action:@selector(starClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:statBtn];
}

#pragma mark - click
-(void)closeClick
{
    [[XZMusicNSObject initClient] playBgMusic];
    if (self.block) {
        self.block(NO);
    }

    [self removeFromSuperview];
}

-(void)btnClick:(UIButton *)btn
{
    [[XZMusicNSObject initClient] playBgMusic];
    if (btn.tag == 101) {
        if (self.block) {
            self.block(YES);
        }
    }else{
        if (self.block) {
            self.block(NO);
        }
    }
    
    [self removeFromSuperview];
}

-(void)starClick
{
    [[XZMusicNSObject initClient] playBgMusic];
    if (self.block) {
        self.block(YES);
    }
    
    [self removeFromSuperview];
}

@end

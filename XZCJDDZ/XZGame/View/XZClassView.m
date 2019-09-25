//
//  XZClassView.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZClassView.h"
#import "XZMusicPlayManager.h"
@interface XZClassView ()

@property (nonatomic, strong) UIView *gView;
@property (nonatomic, strong) UIView *xView;
@property (nonatomic, copy) XZClassViewBlock block;

@end

@implementation XZClassView

+(XZClassView *)shareClient
{
    static XZClassView *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[XZClassView alloc] init];
        [client initUI];
        
    });
    
    return client;
}

-(void) initUI
{
    self.gView = [[UIView alloc] initWithFrame:XZWindow.bounds];
    [XZWindow addSubview:self.gView];
    
    UIView *bgV = [[UIView alloc] initWithFrame:self.gView.bounds];
    bgV.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    [self.gView addSubview:bgV];
    
    UIImageView *imgVBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Auto_Width(590)/2, IS_IPhoneX_All?Auto_Width(452)/2:Auto_Width(452)/2)];
    imgVBg.center = XZWindow.center;
    [imgVBg setImage:XZImageName(@"pop_bg")];
    [self.gView addSubview:imgVBg];
    
    UIImageView *tVBg = [[UIImageView alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-(Auto_Width(494)/2/2), XZMinY(imgVBg)-Auto_Width(81)/2, Auto_Width(494)/2, IS_IPhoneX_All?Auto_Width(164)/2:Auto_Width(164)/2)];
    [tVBg setImage:XZImageName(@"pop_title_bg")];
    [self.gView addSubview:tVBg];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(imgVBg)-Auto_Width(61)/2 +Auto_Width(20)/2, XZMinY(imgVBg)-Auto_Width(18)/2, Auto_Width(61)/2, Auto_Width(62)/2)];
    [closeBtn setBackgroundImage:XZImageName(@"pop_close") forState:0];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.gView addSubview:closeBtn];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, XZMinY(tVBg)+Auto_Width(22)/2, KScreenWidth, Auto_Width(60)/2)];
    nameLab.font = IS_IPAD ? kBoldFont(34) : kBoldFont(24);
    nameLab.textColor = UIColorFromRGB(0xffffff);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = @"Setting";
    [self.gView addSubview:nameLab];
    
    UILabel *bgMLab = [[UILabel alloc] initWithFrame:CGRectMake(XZMinX(imgVBg)+Auto_Width(50)/2, XZMinY(imgVBg)+Auto_Width(149)/2, KScreenWidth/2, Auto_Width(40)/2)];
    bgMLab.font = IS_IPAD ? kBoldFont(25) : kBoldFont(15);
    bgMLab.textColor = UIColorFromRGB(0xffffff);
    bgMLab.text = @"Background music";
    [self.gView addSubview:bgMLab];

    UIButton * sw1 = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(imgVBg)-Auto_Width(50)/2-Auto_Width(140)/2, XZMidY(bgMLab)-(Auto_Width(70)/2/2), Auto_Width(140)/2, Auto_Width(70)/2)];
    [sw1 setBackgroundImage:XZImageName(@"pop_off") forState:0];
    [sw1 setBackgroundImage:XZImageName(@"pop_on") forState:UIControlStateSelected];
    [sw1 addTarget:self action:@selector(bsClick:) forControlEvents:UIControlEventTouchUpInside];
    sw1.selected = YES;
    NSString *isOnG = XZGET_CACHE(XZ_SET_BgMusic);
    if (isOnG) {
        if ([isOnG isEqualToString:XZ_Off]) {
            sw1.selected = NO;
        }else{
            sw1.selected = YES;
        }
    }
    [sw1 setAdjustsImageWhenHighlighted:NO];
    [self.gView addSubview:sw1];
    
    UILabel *gMLab = [[UILabel alloc] initWithFrame:CGRectMake(XZMinX(imgVBg)+Auto_Width(50)/2, XZMaxY(bgMLab)+Auto_Width(90)/2, KScreenWidth/2, Auto_Width(40)/2)];
    gMLab.font = IS_IPAD ? kBoldFont(25) : kBoldFont(15);
    gMLab.textColor = UIColorFromRGB(0xffffff);
    gMLab.text = @"Game sound";
    [self.gView addSubview:gMLab];
    
    UIButton *sw2 = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(imgVBg)-Auto_Width(50)/2-Auto_Width(140)/2, XZMidY(gMLab)-(Auto_Width(70)/2/2), Auto_Width(140)/2, Auto_Width(70)/2)];
    [sw2 setBackgroundImage:XZImageName(@"pop_off") forState:0];
    [sw2 setBackgroundImage:XZImageName(@"pop_on") forState:UIControlStateSelected];
    [sw2 addTarget:self action:@selector(gsClick:) forControlEvents:UIControlEventTouchUpInside];
    sw2.selected = YES;
    NSString *isOn = XZGET_CACHE(XZ_SET_GameMusic);
    if (isOn) {
        if ([isOn isEqualToString:XZ_Off]) {
            sw2.selected = NO;
        }else{
            sw2.selected = YES;
        }
    }
    [sw2 setAdjustsImageWhenHighlighted:NO];
    [self.gView addSubview:sw2];
    
    UIButton *xyBtn = [[UIButton alloc] initWithFrame:CGRectMake((XZWidth(self.gView)-Auto_Width(438)/2)/2, XZMaxY(imgVBg) - Auto_Width(56)/2 - Auto_Width(22)/2, Auto_Width(438)/2, Auto_Width(22)/2)];
    [xyBtn setBackgroundImage:XZImageName(@"pop_xie_btn") forState:0];
    [xyBtn addTarget:self action:@selector(xyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.gView addSubview:xyBtn];
    
    self.xView = [[UIView alloc] initWithFrame:XZWindow.bounds];
    [XZWindow insertSubview:self.xView aboveSubview:self.gView];
    self.xView.hidden = YES;
    [self initXY];
}

-(void)initXY
{
    UIImageView *imgVBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Auto_Width(590)/2, IS_IPhoneX_All?Auto_Width(932)/2:Auto_Width(932)/2)];
    imgVBg.center = XZWindow.center;
    [imgVBg setImage:XZImageName(@"pop_xieyi_bg")];
    [self.xView addSubview:imgVBg];
    
    UIImageView *tVBg = [[UIImageView alloc] initWithFrame:CGRectMake(XZMidX(imgVBg)-(Auto_Width(494)/2/2), XZMinY(imgVBg)-Auto_Width(81)/2, Auto_Width(494)/2, IS_IPhoneX_All?Auto_Width(164)/2:Auto_Width(164)/2)];
    [tVBg setImage:XZImageName(@"pop_title_bg")];
    [self.xView addSubview:tVBg];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XZMaxX(imgVBg)-Auto_Width(61)/2 +Auto_Width(20)/2, XZMinY(imgVBg)-Auto_Width(18)/2, Auto_Width(61)/2, Auto_Width(62)/2)];
    [closeBtn setBackgroundImage:XZImageName(@"pop_close") forState:0];
    [closeBtn addTarget:self action:@selector(cxyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.xView addSubview:closeBtn];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, XZMinY(tVBg)+Auto_Width(22)/2, KScreenWidth, Auto_Height(60)/2)];
    nameLab.font = kBoldFont(24);
    nameLab.textColor = UIColorFromRGB(0xffffff);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = @"Privacy policy";
    [self.xView addSubview:nameLab];
    
    CGFloat x_h = XZHeight(imgVBg) - Auto_Width(113)/2 - Auto_Width(46)/2;
    UITextView *tV = [[UITextView alloc] initWithFrame:CGRectMake(XZMinX(imgVBg)+Auto_Width(40)/2, XZMinY(imgVBg) + Auto_Width(113)/2, XZWidth(imgVBg)-Auto_Width(40), x_h)];
    tV.text = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;bewhat you want to be,because you have only one life and one chance to do all the things you want to do.There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.";
    tV.textColor = [UIColor whiteColor];
    tV.backgroundColor = [UIColor clearColor];
    tV.font = kBoldFont(13);
    tV.editable = NO;
    if (IS_IPAD) {
        tV.font = kBoldFont(16);
    }
    [self.xView addSubview:tV];
    
}

-(void)showSetViewBlock:(XZClassViewBlock)block
{
    self.block = block;
    
    if (self.gView.hidden) {
        self.gView.hidden = NO;
        [XZWindow bringSubviewToFront:self.gView];
    }
}

#pragma mark - click
-(void)closeClick
{
    [[XZMusicNSObject initClient] playBgMusic];
    self.gView.hidden = YES;
    if (self.block) {
        self.block();
    }
}

-(void)bsClick:(UIButton *)btn
{
    [[XZMusicNSObject initClient] playBgMusic];
    
    btn.selected = !btn.selected;
    
    NSString *str = @"";
    if (btn.selected) {
        str = XZ_ON;
        [[XZMusicPlayManager shareManager] backgroundMusicPlay];
    }else{
        str = XZ_Off;
        [[XZMusicPlayManager shareManager] backgroundMusicStop];
    }
    
    XZSET_CACHE(str, XZ_SET_BgMusic);
}

-(void)gsClick:(UIButton *)btn
{
    [[XZMusicNSObject initClient] playBgMusic];
    
    btn.selected = !btn.selected;
    NSString *str = @"";
    if (btn.selected) {
        str = XZ_ON;
    }else{
        str = XZ_Off;
    }
    
    XZSET_CACHE(str, XZ_SET_GameMusic);
}

-(void)xyClick
{
    [[XZMusicNSObject initClient] playBgMusic];
    self.xView.hidden = NO;
    [XZWindow bringSubviewToFront:self.xView];
}

-(void)cxyClick
{
    [[XZMusicNSObject initClient] playBgMusic];
    self.xView.hidden = YES;
}

@end

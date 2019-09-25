//
//  XZMapButton.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/23.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZMapButton.h"
#import "XZHomeModel.h"

@interface XZMapButton ()

@property (nonatomic, strong) UIImageView *currentImgV;
@property (nonatomic, strong) UIImageView *xzImgV;

@property (nonatomic, strong) UIImageView *starMove;

@end

@implementation XZMapButton

-(instancetype)init
{
    if (self = [super init]) {
    
        self.xzImgV = [UIImageView new];
        [self addSubview:self.xzImgV];
        self.xzImgV.frame = CGRectMake(0, 0, Auto_Width(124)/2, Auto_Width(124)/2);

        self.currentImgV = [UIImageView new];
        self.currentImgV.frame = CGRectMake((XZMidX(self.xzImgV)-(Auto_Width(143)/2/2))/2, (XZMidY(self.xzImgV)- (Auto_Width(143)/2/2))/2, Auto_Width(143)/2, Auto_Width(143)/2);
        [self addSubview:self.currentImgV];
        self.currentImgV.center = self.xzImgV.center;
        self.currentImgV.contentMode = UIViewContentModeScaleAspectFit;

        self.starMove = [UIImageView new];
        [self addSubview:self.starMove];
        [self.starMove setImage:XZImageName(@"home_star1")];
        NSMutableArray *imgVA = [[NSMutableArray alloc] init];
        for (int i = 1; i < 4; i++) {
            [imgVA addObject:[UIImage imageNamed:[NSString stringWithFormat:@"home_star%d",i]]];
        }
        self.starMove.animationImages = imgVA;
        self.starMove.animationDuration = 0.6;
        self.starMove.frame = CGRectMake((XZWidth(self)-(Auto_Width(93)/2/2))/2, XZMinY(self.currentImgV)+Auto_Height(10)/2, Auto_Width(93)/2, Auto_Width(43)/2);
        
        CGFloat ce_x = self.currentImgV.center.x-(Auto_Width(93)/2/2);
        
        CGRect rect = self.starMove.frame;
        rect.origin.x = ce_x;
        self.starMove.frame = rect;

    }
    return self;
}

-(void)initHomeModel:(XZHomeModel *)homeModel
{
    _isPass = homeModel.isPass;
    _isCurrentPosition = homeModel.isCurrentPosition;
    
    self.currentImgV.hidden = !homeModel.isCurrentPosition;
    self.starMove.hidden = !homeModel.isCurrentPosition;
    self.xzImgV.hidden = homeModel.isCurrentPosition;
    
    if (homeModel.isSecond) {
        [self.currentImgV setImage:XZImageName(@"home_current2")];
    }else{
        [self.currentImgV setImage:XZImageName(@"home_current")];
    }
    
    if (homeModel.isPass) {
        if (homeModel.isSecond) {
            [self.xzImgV setImage:XZImageName(@"home_pass2")];
        }else{
            [self.xzImgV setImage:XZImageName(@"home_pass")];
        }
    }else{
        if (homeModel.isSecond) {
            [self.xzImgV setImage:XZImageName(@"home_noPass2")];
        }else{
            [self.xzImgV setImage:XZImageName(@"home_noPass")];
        }
    }
    
    if (homeModel.isCurrentPosition) {
        [self.starMove startAnimating];
    }else{
        [self.starMove stopAnimating];
    }
}

@end

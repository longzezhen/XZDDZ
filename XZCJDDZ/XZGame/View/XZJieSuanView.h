//
//  XZJieSuanView.h
//  XZCJDDZ
//
//  Created by df on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZJieSuanView : UIView
@property (nonatomic,copy)void(^clickLeftButtonBlock)(void);
@property (nonatomic,copy)void(^clickRightButtonBlock)(void);
@property (nonatomic,strong)UIView * shadowView;
@property (nonatomic,strong)UIImageView * GYImageView;
@property (nonatomic,strong)UIImageView * GXOneImageView;
@property (nonatomic,strong)UIImageView * GXTwoImageView;
@property (nonatomic,strong)UIImageView * winLoseImgeView;
@property (nonatomic,strong)UIButton * leftButton;
@property (nonatomic,strong)UIButton * rightButton;
@property (nonatomic,strong)UIImageView * winStarImageView;//赢特有动画
@end

NS_ASSUME_NONNULL_END

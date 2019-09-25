//
//  XZMapButton.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/23.
//  Copyright © 2019 dub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZHomeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XZMapButton : UIButton

@property (nonatomic, assign) BOOL isPass;//是否通关

@property (nonatomic, assign) BOOL isCurrentPosition;//是否当前关卡

-(void)initHomeModel:(XZHomeModel *)homeModel;

@end

NS_ASSUME_NONNULL_END

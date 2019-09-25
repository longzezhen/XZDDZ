//
//  TimeDownObj.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TimeDownBlock)(NSInteger count);

@interface TimeDownObj : NSObject

+(TimeDownObj *)shareClient;

-(void)setStarWithView:(UIView *)selfView;

-(void)startCountDown;

-(void)stopTimer;

-(NSInteger)counDownNoStars;

-(void)jsStarCount;

-(NSInteger)counDownStars;

@end

NS_ASSUME_NONNULL_END

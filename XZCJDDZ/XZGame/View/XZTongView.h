//
//  XZTongView.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/23.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XZTongViewBlock)(NSInteger currentNum, BOOL isPass, BOOL isCurrent);

@interface XZTongView : NSObject

-(void)initMapViewFrom:(UIView *)selfView block:(XZTongViewBlock)block;

-(void)refreshCurrent;

@end

NS_ASSUME_NONNULL_END

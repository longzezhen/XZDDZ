//
//  XZTimeManager.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZTimeManager : NSObject

+(XZTimeManager *)shareClient;
//计算时间差
-(NSInteger)nowTimeAgo:(NSDate *)agoDate;
//保存当前时间
-(void)SaveCurrentTime;

@end

NS_ASSUME_NONNULL_END

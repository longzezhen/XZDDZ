//
//  XZTimeManager.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZTimeManager.h"

@implementation XZTimeManager

+(XZTimeManager *)shareClient
{
    static XZTimeManager *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[XZTimeManager alloc] init];
    });
    
    return client;
}

- (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

-(NSInteger)nowTimeAgo:(NSDate *)agoDate
{
    NSDate *nowDate = [NSDate date];//获取当前日期
    
    NSInteger count = [nowDate timeIntervalSinceDate:agoDate];
    
    return count;
}

-(void)SaveCurrentTime
{
    NSDate *now = [NSDate date];
    XZSET_CACHE(now, XZ_Save_CurrentTime);
}

@end

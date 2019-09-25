//
//  XZMusicNSObject.h
//  DDZCJ
//
//  Created by jjj on 2019/9/17.
//  Copyright © 2019 df. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZMusicNSObject : NSObject

+(XZMusicNSObject *)initClient;

-(void)playBgMusic;
-(void)pauseBgMusic;

-(void)playGameMusic;
-(void)pauseGameMusic;

@end

NS_ASSUME_NONNULL_END

//
//  XZMusicPlayManager.h
//  XZCJDDZ
//
//  Created by df on 2019/9/23.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XZMusicPlayManager : NSObject
+(XZMusicPlayManager *)shareManager;
@property (nonatomic,strong)AVAudioPlayer * backgroundPlayer;
@property (nonatomic,strong)AVAudioPlayer * gameWinPlayer;
@property (nonatomic,strong)AVAudioPlayer * gameLosePlayer;
@property (nonatomic,strong)AVAudioPlayer * xuanPaiPlayer;
@property (nonatomic,strong)AVAudioPlayer * danZhangPlayer;
@property (nonatomic,strong)AVAudioPlayer * duoZhangPlayer;
@property (nonatomic,strong)AVAudioPlayer * anNiuPlayer;
//背景音乐
-(void)backgroundMusicPlay;
-(void)backgroundMusicStop;
//游戏过关
-(void)gameWinMusicPlay;
-(void)gameWinMusicStop;
//游戏失败
-(void)gameLoseMusicPlay;
-(void)gameLoseMusicStop;
//选牌
-(void)xuanPaiMusicPlay;
//出单张
-(void)danZhangMusicPlay;
//出多张
-(void)duoZhangMusicPlay;
//点击按钮的声音
-(void)anNiuMusicPlay;
@end

NS_ASSUME_NONNULL_END

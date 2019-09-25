//
//  XZMusicPlayManager.m
//  XZCJDDZ
//
//  Created by df on 2019/9/23.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZMusicPlayManager.h"
@interface XZMusicPlayManager()<AVAudioPlayerDelegate>

@end
@implementation XZMusicPlayManager
+(XZMusicPlayManager *)shareManager
{
    static XZMusicPlayManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XZMusicPlayManager alloc] init];
    });
    return manager;
}

#pragma mark - public
-(void)backgroundMusicPlay
{
    [self.backgroundPlayer play];
}
-(void)backgroundMusicStop
{
    [self.backgroundPlayer stop];
}
-(void)gameWinMusicPlay
{
    if (![XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_Off]) {
        [self.gameWinPlayer play];
    }
}
-(void)gameWinMusicStop
{
    [self.gameWinPlayer stop];
}
-(void)gameLoseMusicPlay
{
    if (![XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_Off]) {
        [self.gameLosePlayer play];
    }
}
-(void)gameLoseMusicStop
{
    [self.gameLosePlayer stop];
}

//选牌
-(void)xuanPaiMusicPlay
{
    if (![XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_Off]) {
        [self.xuanPaiPlayer play];
    }
}
//单张
-(void)danZhangMusicPlay
{
    if (![XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_Off]) {
        [self.danZhangPlayer play];
    }
}
//多张
-(void)duoZhangMusicPlay
{
    if (![XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_Off]) {
        [self.duoZhangPlayer play];
    }
}

-(void)anNiuMusicPlay
{
    if (![XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_Off]) {
        [self.anNiuPlayer play];
    }
}



#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   
}

// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"解码错误！");
}

// 当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    // 当音频播放过程中被中断时，执行该方法。比如：播放音频时，电话来了！
    // 这时候，音频播放将会被暂停。
}
// 当中断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"中断结束，恢复播放");
    if (flags == AVAudioSessionInterruptionOptionShouldResume && player != nil){
        [player play];
    }
}

#pragma mark - get
-(AVAudioPlayer *)backgroundPlayer
{
    if (!_backgroundPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"BackgroudMusic" withExtension:@"mp3"];
        _backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _backgroundPlayer.numberOfLoops = -1;
    }
    return _backgroundPlayer;
}

-(AVAudioPlayer *)gameWinPlayer
{
    if (!_gameWinPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"GuGuanMusic" withExtension:@"mp3"];
        _gameWinPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _gameWinPlayer;
}

-(AVAudioPlayer *)gameLosePlayer
{
    if (!_gameLosePlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"SiBaiMusic" withExtension:@"mp3"];
        _gameLosePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _gameLosePlayer;
}

-(AVAudioPlayer *)xuanPaiPlayer
{
    if (!_xuanPaiPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"XuanPaiMusic" withExtension:@"mp3"];
        _xuanPaiPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _xuanPaiPlayer;
}

-(AVAudioPlayer *)danZhangPlayer
{
    if (!_danZhangPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"DanZhangMusic" withExtension:@"caf"];
        _danZhangPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _danZhangPlayer;
}

-(AVAudioPlayer *)duoZhangPlayer
{
    if (!_duoZhangPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"DuoZhangMusic" withExtension:@"caf"];
        _duoZhangPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _duoZhangPlayer;
}

-(AVAudioPlayer *)anNiuPlayer
{
    if (!_anNiuPlayer) {
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"AnNiuMusic" withExtension:@"mp3"];
        _anNiuPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _anNiuPlayer;
}
@end

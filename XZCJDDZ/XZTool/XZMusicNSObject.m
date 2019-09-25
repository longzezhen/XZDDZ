//
//  XZMusicNSObject.m
//  DDZCJ
//
//  Created by jjj on 2019/9/17.
//  Copyright © 2019 df. All rights reserved.
//

#import "XZMusicNSObject.h"
#import <AVFoundation/AVFoundation.h>

@interface XZMusicNSObject ()<AVAudioPlayerDelegate>
{
    SystemSoundID _soundID;
}
//播放器
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;



@end

@implementation XZMusicNSObject

+(XZMusicNSObject *)initClient
{
    static XZMusicNSObject *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[XZMusicNSObject alloc] init];
        [client initCustom];
        
    });
    
    return client;
}

-(void)initCustom
{
    //获取音效文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AnNiuMusic.mp3" ofType:nil];
    //创建音效文件URL
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    //音效声音的唯一标示ID
//    SystemSoundID soundID = 0;
    _soundID = 0;
    //将音效加入到系统音效服务中，NSURL需要桥接成CFURLRef，会返回一个长整形ID，用来做音效的唯一标示
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &_soundID);
    //设置音效播放完成后的回调C语言函数
    AudioServicesAddSystemSoundCompletion(_soundID,NULL,NULL,soundCompleteCallBack,NULL);
    
}

-(void)playBgMusic
{
    if (!XZGET_CACHE(XZ_SET_GameMusic)) {
        [self playSoundEffect];
    }
    if ([XZGET_CACHE(XZ_SET_GameMusic) isEqualToString:XZ_ON]) {
        [self playSoundEffect];
    }
    
}
-(void)pauseBgMusic
{
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
    }
}

-(void)playGameMusic
{
    
}
-(void)pauseGameMusic
{
    
}

void soundCompleteCallBack(SystemSoundID soundID, void    *clientData) {
//    NSLog(@"播放完成");
}

- (void)playSoundEffect {
    //开始播放音效
    AudioServicesPlaySystemSound(_soundID);
}


- (AVAudioPlayer*)audioPlayer
{
    if (!_audioPlayer) {
        //获取本地播放文件路径
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"click_bg.caf" ofType:nil];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"click_bg" withExtension:@"caf"];
        NSError *error = nil;
        //初始化播放器
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //是否循环播放
//        _audioPlayer.numberOfLoops = 1;
        
        //把播放文件加载到缓存中（注意：即使在播放之前音频文件没有加载到缓冲区程序也会隐式调用此方法。）
        [_audioPlayer prepareToPlay];
        //设置代理，监听播放状态(例如:播放完成)
//        _audioPlayer.delegate = self;
        // 设置音频会话模式，后台播放
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//        [audioSession setActive:YES error:nil];
        // 添加通知(输出改变通知)  ios 6.0 后
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
//        if (error) {
//            NSAssert(YES,"音乐初始化过程报错");
//        }
    }
    return _audioPlayer;
}

@end

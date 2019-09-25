//
//  XZGameViewController.m
//  XZCJDDZ
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZGameViewController.h"
#import "XZGameScene.h"
#import "XZMusicPlayManager.h"
@interface XZGameViewController ()
@property (nonatomic,strong)SKView * gameSKView;
@end

@implementation XZGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[SKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XZGameScene * scene = [XZGameScene sceneWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    XZWeakSelf;
    scene.exitTheSceneBlock = ^{
        [[XZMusicPlayManager shareManager] gameWinMusicStop];
        [[XZMusicPlayManager shareManager] gameLoseMusicStop];
        [XZMusicPlayManager shareManager].gameWinPlayer = nil;
        [XZMusicPlayManager shareManager].gameLosePlayer = nil;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.gameSKView presentScene:scene];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(SKView *)gameSKView
{
    if (!_gameSKView) {
        _gameSKView = (SKView *)self.view;
        _gameSKView.showsFPS = true;
        _gameSKView.showsQuadCount = true;
        _gameSKView.showsFields = true;
        _gameSKView.showsPhysics = true;
        _gameSKView.showsDrawCount = true;
        _gameSKView.showsNodeCount = true;
    }
    return _gameSKView;
}
@end

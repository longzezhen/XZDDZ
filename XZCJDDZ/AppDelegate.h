//
//  AppDelegate.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate *)shareDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger currentCount;
@property (assign, nonatomic) NSInteger paipuNumber;
@end

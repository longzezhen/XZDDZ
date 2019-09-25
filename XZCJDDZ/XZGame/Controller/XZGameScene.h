//
//
//
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZGameScene : SKScene
@property (nonatomic,copy) void (^exitTheSceneBlock)(void);
@end

NS_ASSUME_NONNULL_END

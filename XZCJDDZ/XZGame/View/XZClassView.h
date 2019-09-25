//
//  XZClassView.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XZClassViewBlock)(void);

@interface XZClassView : NSObject

+(XZClassView *)shareClient;

-(void)showSetViewBlock:(XZClassViewBlock)block;

@end

NS_ASSUME_NONNULL_END

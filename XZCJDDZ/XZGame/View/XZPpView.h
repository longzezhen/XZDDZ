//
//  XZPpView.h
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ XZPpViewBlock)(BOOL isSuc);

@interface XZPpView : UIView
- (void)AddRemindTest:(NSString *)textStr titleStr:(NSString *)titleStr block:(XZPpViewBlock)block;

- (void)AddStarViewWithTitle:(NSString *)titleStr block:(XZPpViewBlock)block;

@end

NS_ASSUME_NONNULL_END

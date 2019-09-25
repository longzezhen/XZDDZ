//
//  XZPokerCardTool.h
//  XZCJDDZ
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZCardModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,XZShowPokerType){
    XZPokerType_Dan = 1,
    XZPokerType_DuiZi,
    XZPokerType_WangZha,
    XZPokerType_ZhaDan,
    XZPokerType_SanBuDai,
    XZPokerType_SanDaiYi,
    XZPokerType_SanDaiDui,
    XZPokerType_SunZi,
    XZPokerType_LianDui,
    XZPokerType_FeiJiBuDai,
    XZPokerType_FeiJiDaiDanZhang,
    XZPokerType_FeiJiDaiDuiZi,
    XZPokerType_SiDaiLiangDanZhang,
    XZPokerType_SiDaiLiangDuiZi,
    XZPokerType_MeiChuPai,
};
@interface XZPokerCardTool : NSObject
+(XZPokerCardTool *)sharePokerTool;
-(XZShowPokerType)getPokerType:(NSArray<XZCardModel *>*)cardArray;
-(NSArray*)paiXuPokerFromXiaoToDa:(NSArray<XZCardModel *>*)cardArray;
-(BOOL)isCanShowMyCards:(NSArray<XZCardModel*>*)myCardsArray andPrevCards:(NSArray<XZCardModel*>*)prevCardsArray;
@end

NS_ASSUME_NONNULL_END

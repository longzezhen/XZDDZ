//
//  XZPokerCardTool.m
//  XZCJDDZ
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZPokerCardTool.h"

@implementation XZPokerCardTool
+(XZPokerCardTool *)sharePokerTool
{
    static XZPokerCardTool * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[XZPokerCardTool alloc] init];
    });
    return tool;
}

-(NSArray*)paiXuPokerFromXiaoToDa:(NSArray<XZCardModel *>*)cardArray
{
    if (cardArray == nil) {
        return nil;
    }
    NSMutableArray<XZCardModel *> * mutableCardArray = [NSMutableArray arrayWithArray:cardArray];
    NSInteger arrayCount = cardArray.count;
    for (int i = 0; i < arrayCount; i++) {
        for (int j = 0; j < arrayCount-i-1; j++) {
            NSInteger gradeOne = mutableCardArray[j].grade;
            NSInteger gradeTwo = mutableCardArray[j+1].grade;
            BOOL isExchange = NO;
            if (gradeOne > gradeTwo) {
                isExchange = YES;
            }else if (gradeOne == gradeTwo){
                CardBigType typeOne = mutableCardArray[j].bigType;
                CardBigType typeTwo = mutableCardArray[j+1].bigType;
                if (typeOne == FANG_KUAI) {
                    isExchange = YES;
                }else if (typeOne == MEI_HUA){
                    if (typeTwo == HONG_TAO || typeTwo == HEI_TAO) {
                        isExchange = YES;
                    }
                }else if (typeOne == HONG_TAO){
                    if (typeTwo == HEI_TAO) {
                        isExchange = YES;
                    }
                }
            }
            if (isExchange) {
                [mutableCardArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    return mutableCardArray;
}

-(BOOL)isDan:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isDan = NO;
    if (cardArray != nil && cardArray.count == 1) {
        isDan = YES;
    }
    return isDan;
}

-(BOOL)isDuiZi:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isDuiZi = NO;
    if (cardArray != nil && cardArray.count == 2) {
        if (cardArray[0].grade == cardArray[1].grade) {
            isDuiZi = YES;
        }
    }
    return isDuiZi;
}

-(BOOL)isSanDaiYi:(NSArray<XZCardModel *>*)cardArray
{
    if (cardArray.count == 4) {
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        //炸弹不为三带一
        if (cardArray[0].grade == cardArray[1].grade && cardArray[0].grade == cardArray[2].grade && cardArray[0].grade == cardArray[3].grade) {
            return NO;
        }else if (cardArray[0].grade == cardArray[1].grade && cardArray[0].grade == cardArray[2].grade){//三带一，被带的牌在右边
            return YES;
        }else if (cardArray[1].grade == cardArray[2].grade && cardArray[1].grade == cardArray[3].grade){//三带一，被带的牌在左边
            return YES;
        }
    }
    return NO;
}

-(BOOL)isSanDaiDui:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isSanDaiDui = NO;
    if (cardArray.count == 5) {
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        if (cardArray[0].grade == cardArray[1].grade && cardArray[2].grade == cardArray[3].grade && cardArray[2].grade == cardArray[4].grade) {//被带的牌在左边
            isSanDaiDui = YES;
        }else if (cardArray[0].grade == cardArray[1].grade && cardArray[0].grade == cardArray[2].grade && cardArray[3].grade == cardArray[4].grade){
            isSanDaiDui = YES;
        }
    }
    return isSanDaiDui;
}

-(BOOL)isSanBuDai:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isSanBuDai = NO;
    if (cardArray.count == 3) {
        if (cardArray[0].grade == cardArray[1].grade && cardArray[0].grade == cardArray[2].grade) {
            isSanBuDai = YES;
        }
    }
    return isSanBuDai;
}

-(BOOL)isSunZi:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isSunZi = YES;
    if (cardArray != nil) {
        if (cardArray.count < 5 || cardArray.count > 12) {
            return NO;
        }
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        
        for (int i = 0; i < cardArray.count-1; i++) {
            NSInteger prev = cardArray[i].grade;
            NSInteger next = cardArray[i+1].grade;
            //大小王2不能加入顺子
            if (next == 17 || next == 16 || next == 15) {
                isSunZi = NO;
                break;
            }else{
                if (prev - next != -1) {
                    isSunZi = NO;
                    break;
                }
            }
        }
    }
    return isSunZi;
}

-(BOOL)isZhaDan:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isZhaDan = NO;
    if (cardArray.count == 4) {
        if (cardArray[0].grade == cardArray[1].grade && cardArray[0].grade == cardArray[2].grade && cardArray[0].grade == cardArray[3].grade) {
            isZhaDan = YES;
        }
    }
    return isZhaDan;
}

-(BOOL)isWangZha:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isWangZha = NO;
    if (cardArray != nil &&cardArray.count == 2) {
        if (cardArray[0].grade + cardArray[1].grade == 33) {
            isWangZha = YES;
        }
    }
    return isWangZha;
}

-(BOOL)isLianDui:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isLianDui = YES;
    if (cardArray == nil || cardArray.count < 6 || cardArray.count%2 != 0) {
        return NO;
    }
    cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
    for (int i=0; i<cardArray.count-1; i=i+2) {
        if (cardArray[i].grade != cardArray[i+1].grade) {
            isLianDui = NO;
            break;
        }
        
        if (i<cardArray.count-2) {
            if (cardArray[i].grade - cardArray[i+2].grade != -1) {
                isLianDui = NO;
                break;
            }
        }
    }
    
    return isLianDui;
}

-(BOOL)isFeiJiBuDai:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isFeiJiBuDai = YES;
    if (cardArray == nil || cardArray.count < 6 || cardArray.count%3 != 0) {
        isFeiJiBuDai = NO;
    }else{
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        NSInteger n = cardArray.count/3;
        NSMutableArray * subMutableArray = [NSMutableArray array];
        for (int i = 0; i<n; i++) {
            NSArray * array = [cardArray subarrayWithRange:NSMakeRange(i*3, 3)];
            BOOL isSanBuDai = [self isSanBuDai:array];
            if (!isSanBuDai) {
                return NO;
            }else{
                [subMutableArray addObject:cardArray[i*3]];
            }
        }
        for (int i = 0; i<subMutableArray.count; i++) {
            XZCardModel * model = subMutableArray[i];
            if (model.grade == 15) {
                return NO;
            }
            if (i<subMutableArray.count-1) {
                XZCardModel * nextModel = subMutableArray[i+1];
                if (nextModel.grade - model.grade != 1) {
                    return NO;
                }
            }
        }
    }
    return isFeiJiBuDai;
}

-(BOOL)isFeiJiDaiDanZhang:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isFeiJiDaiDanZhang = NO;
    if (cardArray == nil || cardArray.count%4 != 0 ||cardArray.count<8) {
        isFeiJiDaiDanZhang = NO;
    }else{
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        NSInteger n = cardArray.count/4;
        for (int i = 0; i<n+1; i++) {
            NSInteger gradeOne = cardArray[i].grade;
            NSInteger gradeTwo = cardArray[i+1].grade;
            NSInteger gradeThree = cardArray[i+2].grade;
            if (gradeOne == gradeTwo && gradeOne == gradeThree) {
                NSArray * array = [cardArray subarrayWithRange:NSMakeRange(i, 3*n)];
                isFeiJiDaiDanZhang = [self isSanBuDai:array];
            }
        }
    }
    return isFeiJiDaiDanZhang;
}

-(BOOL)isFeiJiDaiDuiZi:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isFeiJiDaiDuiZi = NO;
    if (cardArray == nil || cardArray.count%5 != 0 || cardArray.count <10) {
        isFeiJiDaiDuiZi = NO;
    }else{
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        NSInteger n = cardArray.count/5;
        for (int i = 0; i<2*n+1; i++) {
            NSInteger gradeOne = cardArray[i].grade;
            NSInteger gradeTwo = cardArray[i+1].grade;
            NSInteger gradeThree = cardArray[i+2].grade;
            if (gradeOne == gradeTwo && gradeOne == gradeThree) {
                NSArray * array = [cardArray subarrayWithRange:NSMakeRange(i, 3*n)];
                if ([self isFeiJiBuDai:array]) {
                    NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:cardArray];
                    [mutableArray removeObjectsInRange:NSMakeRange(i, 3*n)];
                    if (mutableArray.count/2 == n && mutableArray.count%2 == 0) {
                        BOOL allDuizi = YES;
                        for (int i = 0; i<mutableArray.count-1; i = i+2) {
                            XZCardModel * model1 = mutableArray[i];
                            XZCardModel * model2 = mutableArray[i+1];
                            if (model1.grade != model2.grade) {
                                allDuizi = NO;
                            }
                        }
                        if (allDuizi) {
                            isFeiJiDaiDuiZi = YES;
                        }
                    }
                }
            }
        }
    }
    return isFeiJiDaiDuiZi;
}

-(BOOL)isSiDaiEr:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isSiDaiEr = NO;
    if (cardArray.count == 6) {
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        for (int i = 0; i<3; i++) {
            NSInteger gradeOne = cardArray[i].grade;
            NSInteger gradeTwo = cardArray[i+1].grade;
            NSInteger gradeThree = cardArray[i+2].grade;
            NSInteger gradeFour = cardArray[i+3].grade;
            
            if (gradeOne == gradeTwo && gradeOne == gradeThree && gradeOne == gradeFour) {
                isSiDaiEr = YES;
            }
        }
    }
    return isSiDaiEr;
}

-(BOOL)isSiDaiLiangDui:(NSArray<XZCardModel *>*)cardArray
{
    BOOL isSiDaiLiangDui = NO;
    if (cardArray.count == 8) {
        cardArray = [self paiXuPokerFromXiaoToDa:cardArray];
        for (int i = 0; i<5; i = i+2) {
            NSInteger gradeOne = cardArray[i].grade;
            NSInteger gradeTwo = cardArray[i+1].grade;
            NSInteger gradeThree = cardArray[i+2].grade;
            NSInteger gradeFour = cardArray[i+3].grade;
            
            if (gradeOne == gradeTwo && gradeOne == gradeThree && gradeOne == gradeFour) {
                NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:cardArray];
                [mutableArray removeObjectsInRange:NSMakeRange(i, 4)];
                XZCardModel * model1 = mutableArray[0];
                XZCardModel * model2 = mutableArray[1];
                XZCardModel * model3 = mutableArray[2];
                XZCardModel * model4 = mutableArray[3];
                if (model1.grade == model2.grade && model3.grade == model4.grade) {
                    isSiDaiLiangDui = YES;
                }
            }
            
        }
    }
    return isSiDaiLiangDui;
}

-(XZShowPokerType)getPokerType:(NSArray<XZCardModel *>*)cardArray
{
    XZShowPokerType cardsType = 0;
    if (cardArray) {
        if ([self isDan:cardArray]) {
            cardsType = XZPokerType_Dan;
        }else if ([self isDuiZi:cardArray]){
            cardsType = XZPokerType_DuiZi;
        }else if ([self isWangZha:cardArray]){
            cardsType = XZPokerType_WangZha;
        }else if ([self isZhaDan:cardArray]){
            cardsType = XZPokerType_ZhaDan;
        }else if ([self isSanBuDai:cardArray]){
            cardsType = XZPokerType_SanBuDai;
        }else if ([self isSanDaiYi:cardArray]){
            cardsType = XZPokerType_SanDaiYi;
        }else if ([self isSanDaiDui:cardArray]){
            cardsType = XZPokerType_SanDaiDui;
        }else if ([self isSunZi:cardArray]){
            cardsType = XZPokerType_SunZi;
        }else if ([self isLianDui:cardArray]){
            cardsType = XZPokerType_LianDui;
        }else if ([self isFeiJiBuDai:cardArray]){
            cardsType = XZPokerType_FeiJiBuDai;
        }else if ([self isFeiJiDaiDanZhang:cardArray]){
            cardsType = XZPokerType_FeiJiDaiDanZhang;
        }else if ([self isFeiJiDaiDuiZi:cardArray]){
            cardsType = XZPokerType_FeiJiDaiDuiZi;
        }else if ([self isSiDaiEr:cardArray]){
            cardsType = XZPokerType_SiDaiLiangDanZhang;
        }else if ([self isSiDaiLiangDui:cardArray]){
            cardsType = XZPokerType_SiDaiLiangDuiZi;
        }else if (cardArray.count == 0){
            cardsType = XZPokerType_MeiChuPai;
        }
    }
    return cardsType;
}

-(BOOL)isCanShowMyCards:(NSArray<XZCardModel*>*)myCardsArray andPrevCards:(NSArray<XZCardModel*>*)prevCardsArray
{
    XZShowPokerType myCardsType = [self getPokerType:myCardsArray];
    XZShowPokerType prevCardsType = [self getPokerType:prevCardsArray];
    if (myCardsType == 0 || prevCardsType == 0) {
        return NO;
    }
    NSInteger mySize = myCardsArray.count;
    NSInteger prevSize = prevCardsArray.count;
    if (prevSize == 0 && mySize != 0) {
        return YES;
    }
    if (prevCardsType == XZPokerType_WangZha) {
        return NO;
    }else if (myCardsType == XZPokerType_WangZha){
        return YES;
    }
    if (prevCardsType != XZPokerType_ZhaDan && myCardsType == XZPokerType_ZhaDan) {
        return YES;
    }
    myCardsArray = [self paiXuPokerFromXiaoToDa:myCardsArray];
    prevCardsArray = [self paiXuPokerFromXiaoToDa:prevCardsArray];
    if (prevCardsType == XZPokerType_Dan && myCardsType == XZPokerType_Dan) {
        if (myCardsArray[0].grade > prevCardsArray[0].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_DuiZi && myCardsType == XZPokerType_DuiZi){
        if (myCardsArray[0].grade > prevCardsArray[0].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_SanBuDai && myCardsType == XZPokerType_SanBuDai){
        if (myCardsArray[0].grade > prevCardsArray[0].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_SanDaiYi && myCardsType == XZPokerType_SanDaiYi){
        if (myCardsArray[1].grade > prevCardsArray[1].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_SanDaiDui && myCardsType == XZPokerType_SanDaiDui){
        if (myCardsArray[2].grade > prevCardsArray[2].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_SunZi && myCardsType == XZPokerType_SunZi){
        if (mySize != prevSize) {
            return NO;
        }else{
            if (myCardsArray[0].grade > prevCardsArray[0].grade) {
                return YES;
            }else{
                return NO;
            }
        }
    }else if (prevCardsType == XZPokerType_LianDui && myCardsType == XZPokerType_LianDui){
        if (mySize != prevSize) {
            return NO;
        }else{
            if (myCardsArray[0].grade > prevCardsArray[0].grade) {
                return YES;
            }else{
                return NO;
            }
        }
    }else if (prevCardsType == XZPokerType_FeiJiBuDai && myCardsType == XZPokerType_FeiJiBuDai){
        if (mySize != prevSize) {
            return NO;
        }else{
            if (myCardsArray[0].grade > prevCardsArray[0].grade) {
                return YES;
            }else{
                return NO;
            }
        }
    }else if (prevCardsType == XZPokerType_FeiJiDaiDanZhang && myCardsType == XZPokerType_FeiJiDaiDanZhang){
        if (mySize != prevSize) {
            return NO;
        }else{
            if (myCardsArray[5].grade > prevCardsArray[5].grade) {
                return YES;
            }else{
                return NO;
            }
        }
    }else if (prevCardsType == XZPokerType_FeiJiDaiDuiZi && myCardsType == XZPokerType_FeiJiDaiDuiZi){
        if (mySize != prevSize) {
            return NO;
        }else{
            NSInteger n = mySize/5;
            if (myCardsArray[2*n].grade > prevCardsArray[2*n].grade) {
                return YES;
            }else{
                return NO;
            }
        }
    }else if (prevCardsType == XZPokerType_ZhaDan && myCardsType == XZPokerType_ZhaDan){
        if (myCardsArray[0].grade > prevCardsArray[0].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_SiDaiLiangDanZhang && myCardsType == XZPokerType_SiDaiLiangDanZhang){
        if (myCardsArray[2].grade > prevCardsArray[2].grade) {
            return YES;
        }else{
            return NO;
        }
    }else if (prevCardsType == XZPokerType_SiDaiLiangDanZhang && myCardsType == XZPokerType_SiDaiLiangDanZhang){
        NSInteger myGrade = 0;
        NSInteger prevGrade = 0;
        for (int i = 0; i<5; i = i+2) {
            NSInteger gradeOne = myCardsArray[i].grade;
            NSInteger gradeTwo = myCardsArray[i+1].grade;
            NSInteger gradeThree = myCardsArray[i+2].grade;
            NSInteger gradeFour = myCardsArray[i+3].grade;
            if (gradeOne == gradeTwo && gradeOne == gradeThree && gradeOne == gradeFour){
                myGrade = gradeOne;
            }
        }
        for (int i = 0; i<5; i = i+2) {
            NSInteger gradeOne = prevCardsArray[i].grade;
            NSInteger gradeTwo = prevCardsArray[i+1].grade;
            NSInteger gradeThree = prevCardsArray[i+2].grade;
            NSInteger gradeFour = prevCardsArray[i+3].grade;
            if (gradeOne == gradeTwo && gradeOne == gradeThree && gradeOne == gradeFour){
                prevGrade = gradeOne;
            }
        }
        if (myGrade > prevGrade) {
            return YES;
        }else{
            NO;
        }
    }
    
    return NO;
}
@end

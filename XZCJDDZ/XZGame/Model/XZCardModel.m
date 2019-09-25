//
//  XZCardModel.m
//  XZCJDDZ
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZCardModel.h"

@implementation XZCardModel
-(XZCardModel*)initWithID:(NSInteger)cardId
{
    if (self = [super init]) {
        self.cardId = cardId;
        self.bigType = [self getTheBigTypeWithID:cardId];
        self.numberType = [self getTheNumberTypeWithID:cardId];
        self.grade = [self getTheGradeWithID:cardId];
        self.imageName = [NSString stringWithFormat:@"POKER_%ld",cardId];
    }
    return self;
}

#pragma mark - private
-(CardNumberType)getTheNumberTypeWithID:(NSInteger)cardId
{
    CardNumberType numberType = 0;
    if (cardId >= 1 && cardId <= 52) {
        switch (cardId % 13) {
            case 0:
                numberType = NUM_K;
                break;
            case 1:
                numberType = NUM_A;
                break;
            case 2:
                numberType = NUM_ER;
                break;
            case 3:
                numberType = NUM_SAN;
                break;
            case 4:
                numberType = NUM_SI;
                break;
            case 5:
                numberType = NUM_WU;
                break;
            case 6:
                numberType = NUM_LIU;
                break;
            case 7:
                numberType = NUM_QI;
                break;
            case 8:
                numberType = NUM_BA;
                break;
            case 9:
                numberType = NUM_JIU;
                break;
            case 10:
                numberType = NUM_SHI;
                break;
            case 11:
                numberType = NUM_J;
                break;
            case 12:
                numberType = NUM_Q;
                break;
            default:
                break;
        }
    }else if (cardId == 53){
        numberType = NUM_XW;
    }else if (cardId == 54){
        numberType = NUM_DW;
    }
    return numberType;
}

-(CardBigType)getTheBigTypeWithID:(NSInteger)cardId
{
    CardBigType bigType = 0;
    if (cardId >= 1 && cardId <= 13) {
        bigType = HEI_TAO;
    }else if (cardId >= 14 && cardId <= 26){
        bigType = HONG_TAO;
    }else if (cardId >= 27 && cardId <= 39){
        bigType = MEI_HUA;
    }else if (cardId >= 40 &&cardId <= 52){
        bigType = FANG_KUAI;
    }else if (cardId == 53){
        bigType = XIAO_WANG;
    }else if (cardId == 54){
        bigType = DA_WANG;
    }
    return bigType;
}

-(NSInteger)getTheGradeWithID:(NSInteger)cardId
{
    NSInteger grade = 0;
    if (cardId == 54) {
        grade = 17;
    }else if (cardId == 53){
        grade = 16;
    }else{
        switch (cardId % 13) {
            case 0:
                grade = 13;
                break;
            case 1:
                grade = 14;
                break;
            case 2:
                grade = 15;
                break;
            case 3:
                grade = 3;
                break;
            case 4:
                grade = 4;
                break;
            case 5:
                grade = 5;
                break;
            case 6:
                grade = 6;
                break;
            case 7:
                grade = 7;
                break;
            case 8:
                grade = 8;
                break;
            case 9:
                grade = 9;
                break;
            case 10:
                grade = 10;
                break;
            case 11:
                grade = 11;
                break;
            case 12:
                grade = 12;
                break;
                
                
            default:
                break;
        }
    }
    return grade;
}
@end

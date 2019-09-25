//
//  XZCardModel.h
//  XZCJDDZ
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,CardNumberType){
    NUM_A = 1,
    NUM_ER,
    NUM_SAN,
    NUM_SI,
    NUM_WU,
    NUM_LIU,
    NUM_QI,
    NUM_BA,
    NUM_JIU,
    NUM_SHI,
    NUM_J,
    NUM_Q,
    NUM_K,
    NUM_XW,
    NUM_DW
};

typedef NS_ENUM(NSUInteger,CardBigType){
    HEI_TAO = 1,
    HONG_TAO,
    MEI_HUA,
    FANG_KUAI,
    XIAO_WANG,
    DA_WANG
};

@interface XZCardModel : NSObject
@property (nonatomic,assign) NSInteger cardId;
@property (nonatomic,assign) NSInteger grade;
@property (nonatomic,strong) NSString * imageName;
@property (nonatomic,assign) CardBigType bigType;
@property (nonatomic,assign) CardNumberType numberType;
-(XZCardModel*)initWithID:(NSInteger)cardId;
@end



//
//
//
//
//  Created by df on 2019/9/21.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZGameScene.h"
#import "XZCardModel.h"
#import "XZPokerCardTool.h"
#import "XZJieSuanView.h"
#import "XZMusicPlayManager.h"
#import "XZClassView.h"
#import "TimeDownObj.h"
#import "XZPpView.h"
#define BIGCARDWIDE      186*0.8/2
#define BIGCARDHEIGHT    257*0.8/2
#define SMALLCARDWIDE    186*0.6/2
#define SMALLCARDHEIGHT  257*0.6/2
#define SPACEBIG            54/2
#define SPACESMALL       40/2
#define PAIUP           60/2
@interface XZGameScene()
@property (nonatomic,strong)SKSpriteNode * beijingNode;
@property (nonatomic,strong)SKSpriteNode * goBackNode;
@property (nonatomic,strong)SKSpriteNode * settingNode;
@property (nonatomic,strong)SKSpriteNode * tiLiNode;
@property (nonatomic,strong)UILabel * tiLiValueLabel;
@property (nonatomic,strong)SKSpriteNode * ETNode;
@property (nonatomic,strong)SKSpriteNode * playHandNode;
@property (nonatomic,strong)SKSpriteNode * noPlayHandNode;
@property (nonatomic,strong)SKSpriteNode * gameBeginNode;
@property (nonatomic,strong)XZJieSuanView * winJieSuanView;
@property (nonatomic,strong)XZJieSuanView * loseJieSuanView;
@property (nonatomic,strong)XZPpView * popupView;

@property (nonatomic,strong)NSMutableArray * wodeCardArray;
@property (nonatomic,strong)NSMutableArray * wodeNodeArray;
@property (nonatomic,strong)NSMutableArray * jiqiCardArray;
@property (nonatomic,strong)NSMutableArray * jiqiNodeArray;
@property (nonatomic,strong)NSMutableArray * wodeWillShowCardArray;
@property (nonatomic,strong)NSMutableArray * wodeWillShowNodeArray;
@property (nonatomic,strong)NSMutableArray * prevShowCardArray;
@property (nonatomic,strong)NSMutableArray * wodeZhuoShangNodeArray;
@property (nonatomic,strong)NSMutableArray * jiqiZhuoShangNodeArray;

@end
@implementation XZGameScene
-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self initView];
    }
    return self;
}

#pragma mark - private
-(void)initView
{
    [self addChild:self.beijingNode];
    [self addChild:self.goBackNode];
    [self addChild:self.settingNode];
    [self addChild:self.tiLiNode];
    [self addChild:self.ETNode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tiLiValueLabel.hidden = NO;
        [self addChild:self.gameBeginNode];
    });
}

-(void)dealCard
{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"cardMold" ofType:@"plist"];
    NSArray * paipuArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSDictionary * dic = paipuArray[[AppDelegate shareDelegate].paipuNumber];
    self.wodeCardArray = [NSMutableArray arrayWithArray:[self cardsForCardIDArray:dic[@"player"]]];
    self.jiqiCardArray = [NSMutableArray arrayWithArray:[self cardsForCardIDArray:dic[@"robot"]]];
    [self addMyNodeWithCardArray:self.wodeCardArray];
    [self addRobotNodeWithCardArray:self.jiqiCardArray];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addChild:self.playHandNode];
        [self addChild:self.noPlayHandNode];
        [self buttonPositionWithType:2];
    });
}

-(NSArray*)cardsForCardIDArray:(NSArray*)idArray
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    for (int i = 0; i<idArray.count; i++) {
        XZCardModel * model = [[XZCardModel alloc] initWithID:[idArray[i] integerValue]];
        [mutableArray addObject:model];
    }
    NSArray* array = [[XZPokerCardTool sharePokerTool] paiXuPokerFromXiaoToDa:mutableArray];
    return array;
}

-(void)addMyNodeWithCardArray:(NSArray<XZCardModel*>*)cardsArray
{
    CGFloat pointx = (self.size.width-SPACEBIG*(cardsArray.count-1)-BIGCARDWIDE)/2;
    for (int i = 0; i<cardsArray.count; i++) {
        XZCardModel * model = cardsArray[i];
        SKSpriteNode * cardNode = [[SKSpriteNode alloc] initWithImageNamed:model.imageName];
        cardNode.name = model.imageName;
        cardNode.size = CGSizeMake(BIGCARDWIDE, BIGCARDHEIGHT);
        cardNode.position = CGPointMake(self.size.width+BIGCARDWIDE/2, Auto_Height(20)+BIGCARDHEIGHT/2);
        [self addChild:cardNode];
        SKAction * moveAction = [SKAction moveTo:CGPointMake(pointx+BIGCARDWIDE/2+SPACEBIG*i, Auto_Height(20)+BIGCARDHEIGHT/2) duration:0.8];
        [self.wodeNodeArray addObject:cardNode];
        [cardNode runAction:moveAction];
    }
}

-(void)addRobotNodeWithCardArray:(NSArray<XZCardModel*>*)cardsArray
{
    CGFloat pointx = (self.size.width-SPACEBIG*(cardsArray.count-1)-BIGCARDWIDE)/2;
    for (int i = 0; i<cardsArray.count; i++) {
        XZCardModel * model = cardsArray[i];
        SKSpriteNode * cardNode = [[SKSpriteNode alloc] initWithImageNamed:model.imageName];
        cardNode.size = CGSizeMake(BIGCARDWIDE, BIGCARDHEIGHT);
        cardNode.position = CGPointMake(self.size.width+BIGCARDWIDE/2, self.size.height-Auto_Height(276/2)-BIGCARDHEIGHT/2);
        [self addChild:cardNode];
        SKAction * moveAction = [SKAction moveTo:CGPointMake(pointx+BIGCARDWIDE/2+SPACEBIG*i, self.size.height-Auto_Height(276/2)-BIGCARDHEIGHT/2) duration:0.8];
        [self.jiqiNodeArray addObject:cardNode];
        [cardNode runAction:moveAction];
    }
}

//移除机器人桌上的牌
-(void)removeRobotZhuoShangNodePai
{
    for (SKNode * node in self.jiqiZhuoShangNodeArray) {
        [node removeFromParent];
    }
}

//移除我桌上的牌
-(void)removeMyZhuoShangNodePai
{
    for (SKNode * node in self.wodeZhuoShangNodeArray) {
        [node removeFromParent];
    }
}

//更新我的手牌布局
-(void)updateMyNodeBuju
{
    CGFloat pointx = (self.size.width-SPACEBIG*(self.wodeNodeArray.count-1)-BIGCARDWIDE)/2;
    for (int i = 0; i<self.wodeNodeArray.count; i++) {
        SKNode * node = self.wodeNodeArray[i];
        SKAction * moveAction = [SKAction moveTo:CGPointMake(pointx+BIGCARDWIDE/2+SPACEBIG*i, Auto_Height(20)+BIGCARDHEIGHT/2) duration:0.1];
        [node runAction:moveAction];
    }
}


-(void)robotCardsAnimationWithIndex:(NSInteger)i andWithRobotCardsNumber:(NSInteger)n
{
    [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:self.jiqiNodeArray range:NSMakeRange(i, n)];
    //移动robot要出的牌
    [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
    [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:self.jiqiCardArray range:NSMakeRange(i, n)];
    
    [self.jiqiCardArray removeObjectsInRange:NSMakeRange(i, n)];
    [self.jiqiNodeArray removeObjectsInRange:NSMakeRange(i, n)];
    
    //更新robot手牌布局
    [self updateRobotNodeBuju];
}

//机器人是否有炸弹管上并出牌
-(BOOL)robotZhaDanGuanShang
{
    BOOL canShow = NO;
    for (int i = 0; i+3<self.jiqiCardArray.count; i++) {
        XZCardModel * modelOne = self.jiqiCardArray[i];
        XZCardModel * modelTwo = self.jiqiCardArray[i+1];
        XZCardModel * modelThree = self.jiqiCardArray[i+2];
        XZCardModel * modelFour = self.jiqiCardArray[i+3];
        if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade == modelFour.grade) {
            canShow = YES;
            [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:4];
            break;
        }
    }
    return canShow;
}

//机器人是否有王炸管上
-(BOOL)robotWangZhaGuanShang
{
    BOOL canShow = NO;
    //牌数小于2张肯定没王炸
    if (self.jiqiCardArray.count<2) {
        return NO;
    }
    XZCardModel * lastModel = [self.jiqiCardArray lastObject];
    NSInteger robotNum = self.jiqiCardArray.count;
    XZCardModel * preLastModel = self.jiqiCardArray[robotNum-2];
    if (lastModel.grade+preLastModel.grade == 33) {
        canShow = YES;
        //[self removeLastZhuoShangPai];
        [self.jiqiZhuoShangNodeArray removeAllObjects];
        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[robotNum-2]];
        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[robotNum-1]];
        [self.prevShowCardArray removeAllObjects];
        [self.prevShowCardArray addObject:preLastModel];
        [self.prevShowCardArray addObject:lastModel];
        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
        [self updateRobotNodeBuju];
    }
    return canShow;
}

//更新robot手牌布局
-(void)updateRobotNodeBuju
{
    CGFloat pointx = (self.size.width-(self.jiqiNodeArray.count-1)*SPACEBIG-BIGCARDWIDE)/2;
    for (int n = 0; n<self.jiqiNodeArray.count; n++) {
        SKNode * node = self.jiqiNodeArray[n];
        SKAction * moveAction = [SKAction moveTo:CGPointMake(pointx+BIGCARDWIDE/2+SPACEBIG*n, self.size.height-Auto_Height(276/2)-BIGCARDHEIGHT/2) duration:0.1];
        [node runAction:moveAction];
    }
}

//是否有炸弹管上
-(BOOL)myCardZhaDanGuanShang
{
    BOOL canShow = NO;
    for (int i = 0; i+3<self.wodeCardArray.count; i++) {
        XZCardModel * modelOne = self.wodeCardArray[i];
        XZCardModel * modelTwo = self.wodeCardArray[i+1];
        XZCardModel * modelThree = self.wodeCardArray[i+2];
        XZCardModel * modelFour = self.wodeCardArray[i+3];
        if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade == modelFour.grade) {
            canShow = YES;
            break;
        }
    }
    return canShow;
}

//是否有王炸管上
-(BOOL)myCardWangZhaGuanShang
{
    BOOL canShow = NO;
    //牌数小于2张肯定没王炸
    if (self.wodeCardArray.count<2) {
        return NO;
    }
    XZCardModel * lastModel = [self.wodeCardArray lastObject];
    NSInteger robotNum = self.wodeCardArray.count;
    XZCardModel * preLastModel = self.wodeCardArray[robotNum-2];
    if (lastModel.grade+preLastModel.grade == 33) {
        canShow = YES;
    }
    return canShow;
}

//移动robot牌
-(void)moveRobotCardsWithNodeArray:(NSArray*)array
{
    //移走robot要出的牌
    CGFloat pointx = (self.size.width-SPACESMALL*(array.count-1)-SMALLCARDWIDE)/2;
    for (int j = 0; j<array.count; j++) {
        SKNode * node = array[j];
        SKAction * moveAction = [SKAction moveTo:CGPointMake(pointx+SMALLCARDWIDE/2+SPACESMALL*j, self.size.height-Auto_Height(324/2)-BIGCARDHEIGHT-Auto_Height(10)-SMALLCARDHEIGHT/2) duration:0.1];
        SKAction * scaleAction = [SKAction scaleTo:0.75 duration:0.1];
        [node runAction:[SKAction group:@[moveAction,scaleAction]]];
    }
}

//我点击不出的时候机器人响应
-(void)robotResponseMeBuChu
{
    XZCardModel * cardOneModel = self.jiqiCardArray[0];
    XZCardModel * cardTwoModel = [XZCardModel new];
    XZCardModel * cardThreeModel = [XZCardModel new];;
    XZCardModel * cardFourModel = [XZCardModel new];;
    
    if (self.jiqiCardArray.count == 2) {
        cardTwoModel = self.jiqiCardArray[1];
    }else if (self.jiqiCardArray.count == 3){
        cardTwoModel = self.jiqiCardArray[1];
        cardThreeModel = self.jiqiCardArray[2];
    }else if (self.jiqiCardArray.count >= 4){
        cardTwoModel = self.jiqiCardArray[1];
        cardThreeModel = self.jiqiCardArray[2];
        cardFourModel = self.jiqiCardArray[3];
    }
    //移除robot桌上的牌
    [self removeRobotZhuoShangNodePai];
    
    if (cardOneModel.grade != cardTwoModel.grade) {
        [[XZMusicPlayManager shareManager] danZhangMusicPlay];
        [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:[NSArray arrayWithObject:self.jiqiNodeArray[0]]];
        [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:[NSArray arrayWithObject:self.jiqiCardArray[0]]];
        
        [self.jiqiCardArray removeObjectAtIndex:0];
        [self.jiqiNodeArray removeObjectAtIndex:0];
    }else{
        [[XZMusicPlayManager shareManager] duoZhangMusicPlay];
        if (cardTwoModel.grade != cardThreeModel.grade) {
            [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:@[self.jiqiNodeArray[0],self.jiqiNodeArray[1]]];
            [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:@[cardOneModel,cardTwoModel]];
            [self.jiqiCardArray removeObjectsInRange:NSMakeRange(0, 2)];
            [self.jiqiNodeArray removeObjectsInRange:NSMakeRange(0, 2)];
        }else{
            if (cardThreeModel.grade != cardFourModel.grade) {
                [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:@[self.jiqiNodeArray[0],self.jiqiNodeArray[1],self.jiqiNodeArray[2]]];
                [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:@[cardOneModel,cardTwoModel,cardThreeModel]];
                [self.jiqiCardArray removeObjectsInRange:NSMakeRange(0, 3)];
                [self.jiqiNodeArray removeObjectsInRange:NSMakeRange(0, 3)];
            }else{
                [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:@[self.jiqiNodeArray[0],self.jiqiNodeArray[1],self.jiqiNodeArray[2],self.jiqiNodeArray[3]]];
                [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:@[cardOneModel,cardTwoModel,cardThreeModel,cardFourModel]];
                [self.jiqiCardArray removeObjectsInRange:NSMakeRange(0, 4)];
                [self.jiqiNodeArray removeObjectsInRange:NSMakeRange(0, 4)];
            }
        }
    }
    //移走robot要出的牌
    [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
    
    if (self.jiqiCardArray.count == 0) {
        //闯关失败
        self.loseJieSuanView.hidden = NO;
        self.userInteractionEnabled = NO;
        [self.playHandNode removeFromParent];
        [self.noPlayHandNode removeFromParent];
        [[XZMusicPlayManager shareManager] gameLoseMusicPlay];
    }else{
        //更新robot手牌布局
        [self updateRobotNodeBuju];
    }
    
}

#pragma mark - 判断我手上的牌有没有大过robot的牌
-(BOOL)myCardCanHitRobotShowCard:(NSArray<XZCardModel*>*)robotShowCardsArray
{
    if ([self myCardWangZhaGuanShang]) {
        return YES;
    }
    BOOL iCanHit = NO;
    XZShowPokerType type = [[XZPokerCardTool sharePokerTool] getPokerType:robotShowCardsArray];
    switch (type) {
        case XZPokerType_Dan:
        {
            XZCardModel * model = robotShowCardsArray[0];
            for (int i = 0; i<self.wodeCardArray.count; i++) {
                XZCardModel * myModel = self.wodeCardArray[i];
                if (myModel.grade>model.grade) {
                    iCanHit = YES;
                    break;
                }
            }
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_DuiZi:
        {
            XZCardModel * model = robotShowCardsArray[0];
            for (int i = 0; i+1<self.wodeCardArray.count; i++) {
                XZCardModel * modelOne = self.wodeCardArray[i];
                XZCardModel * modelTwo = self.wodeCardArray[i+1];
                if (modelOne.grade == modelTwo.grade && modelOne.grade>model.grade) {
                    iCanHit = YES;
                    break;
                }
            }
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_WangZha:
        {
            iCanHit = NO;
        }
            break;
        case XZPokerType_ZhaDan:
        {
            XZCardModel * model = robotShowCardsArray[0];
            for (int i = 0; i+3<self.wodeCardArray.count; i++) {
                XZCardModel * modelOne = self.wodeCardArray[i];
                XZCardModel * modelTwo = self.wodeCardArray[i+1];
                XZCardModel * modelThree = self.wodeCardArray[i+2];
                XZCardModel * modelFour = self.wodeCardArray[i+3];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade == modelFour.grade && modelOne.grade > model.grade) {
                    iCanHit = YES;
                    [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:4];
                    break;
                }
            }
        }
            break;
        case XZPokerType_SanBuDai:
        {
            XZCardModel * model = robotShowCardsArray[0];
            for (int i = 0; i+2<self.wodeCardArray.count; i++) {
                XZCardModel * modelOne = self.wodeCardArray[i];
                XZCardModel * modelTwo = self.wodeCardArray[i+1];
                XZCardModel * modelThree = self.wodeCardArray[i+2];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade > model.grade) {
                    iCanHit = YES;
                    break;
                }
            }
            //是否有炸弹
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_SanDaiYi:
        {
            XZCardModel * model = robotShowCardsArray[1];
            for (int i = 0; i+2<self.wodeCardArray.count; i++) {
                XZCardModel * modelOne = self.wodeCardArray[i];
                XZCardModel * modelTwo = self.wodeCardArray[i+1];
                XZCardModel * modelThree = self.wodeCardArray[i+2];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade > model.grade){
                    if (self.wodeCardArray.count>=4) {
                        iCanHit = YES;
                    }
                }
            }
            //是否有炸弹
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_SanDaiDui:
        {
            XZCardModel * model = robotShowCardsArray[2];
            for (int i = 0; i+2<self.wodeCardArray.count; i++) {
                if (iCanHit) {
                    break;
                }
                XZCardModel * modelOne = self.wodeCardArray[i];
                XZCardModel * modelTwo = self.wodeCardArray[i+1];
                XZCardModel * modelThree = self.wodeCardArray[i+2];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade > model.grade){
                    for (int j = 0; j+1<self.jiqiCardArray.count; j++) {
                        XZCardModel * model1 = self.jiqiCardArray[j];
                        XZCardModel * model2 = self.jiqiCardArray[j+1];
                        if (model1.grade == model2.grade && model1.grade != modelOne.grade) {
                            iCanHit = YES;
                            break;
                        }
                    }
                }
            }
            //是否有炸弹
            if (!iCanHit) {
                iCanHit = [self myCardWangZhaGuanShang];
            }
        }
            break;
        case XZPokerType_SunZi:
        {
            //残局如果顺子被管上，我就没有顺子能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_LianDui:
        {
            //残局如果连对被管上，我就没有连对能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_FeiJiBuDai:
        {
            //残局如果飞机被管上，我就没有飞机能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_FeiJiDaiDanZhang:
        {
            //残局如果飞机被管上，我就没有飞机能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_FeiJiDaiDuiZi:
        {
            //残局如果飞机被管上，我就没有飞机能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_SiDaiLiangDanZhang:
        {
            //残局如果四带二被管上，我就没有四带二能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
        case XZPokerType_SiDaiLiangDuiZi:
        {
            //残局如果四带二被管上，我就没有四带二能管上了
            if (!iCanHit) {
                iCanHit = [self myCardZhaDanGuanShang];
            }
        }
            break;
            
        default:
            break;
    }
    return iCanHit;
}

#pragma mark - robot响应玩家出牌
-(void)showRobotCardsWithMyShowCards:(NSArray<XZCardModel*>*)myShowCardsArray
{
    //robot是否要得起我出的牌
    BOOL robotCanHit = NO;
    //只要robot响应，就除我桌上的牌
    [self removeMyZhuoShangNodePai];
    
    XZShowPokerType type = [[XZPokerCardTool sharePokerTool] getPokerType:myShowCardsArray];
    switch (type) {
        case XZPokerType_Dan:
        {
            XZCardModel * model = myShowCardsArray[0];
            BOOL  canShow = NO;
            for (int i = 0; i<self.jiqiCardArray.count; i++) {
                XZCardModel * robotModel = self.jiqiCardArray[i];
                if (robotModel.grade>model.grade) {
                    canShow = YES;
                    [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:1];
                    break;
                }
            }
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起单张");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_DuiZi:
        {
            XZCardModel * model = myShowCardsArray[0];
            BOOL  canShow = NO;
            for (int i = 0; i+1<self.jiqiCardArray.count; i++) {
                XZCardModel * modelOne = self.jiqiCardArray[i];
                XZCardModel * modelTwo = self.jiqiCardArray[i+1];
                if (modelOne.grade == modelTwo.grade && modelOne.grade>model.grade) {
                    canShow = YES;
                    //更新数组，更新布局
                    [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:2];
                    break;
                }
            }
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起对子");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_WangZha:
        {
            NSLog(@"机器人要不起王炸");
            robotCanHit = NO;
            //[self.prevShowCardArray removeAllObjects];
        }
            break;
        case XZPokerType_ZhaDan:
        {
            XZCardModel * model = myShowCardsArray[0];
            BOOL  canShow = NO;
            for (int i = 0; i+3<self.jiqiCardArray.count; i++) {
                XZCardModel * modelOne = self.jiqiCardArray[i];
                XZCardModel * modelTwo = self.jiqiCardArray[i+1];
                XZCardModel * modelThree = self.jiqiCardArray[i+2];
                XZCardModel * modelFour = self.jiqiCardArray[i+3];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade == modelFour.grade && modelOne.grade > model.grade) {
                    canShow = YES;
                    [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:4];
                    break;
                }
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起炸弹");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_SanBuDai:
        {
            XZCardModel * model = myShowCardsArray[0];
            BOOL canShow = NO;
            for (int i = 0; i+2<self.jiqiCardArray.count; i++) {
                XZCardModel * modelOne = self.jiqiCardArray[i];
                XZCardModel * modelTwo = self.jiqiCardArray[i+1];
                XZCardModel * modelThree = self.jiqiCardArray[i+2];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade > model.grade) {
                    canShow = YES;
                    [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:3];
                    break;
                }
            }
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起三不带");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_SanDaiYi:
        {
            XZCardModel * model = myShowCardsArray[1];
            BOOL canShow = NO;
            for (int i = 0; i+2<self.jiqiCardArray.count; i++) {
                XZCardModel * modelOne = self.jiqiCardArray[i];
                XZCardModel * modelTwo = self.jiqiCardArray[i+1];
                XZCardModel * modelThree = self.jiqiCardArray[i+2];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade > model.grade){
                    if (i==0) {
                        if (self.jiqiCardArray.count>=4) {
                            canShow = YES;
                            [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:4];
                        }
                    }else{
                        canShow = YES;
                        NSMutableArray * mutableNodeArray = [NSMutableArray arrayWithArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 3)]];
                        [mutableNodeArray insertObject:self.jiqiNodeArray[0] atIndex:0];
                        
                        NSMutableArray * mutableCardArray = [NSMutableArray arrayWithArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 3)]];
                        [mutableCardArray insertObject:self.jiqiCardArray[0] atIndex:0];
                        
                        [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:mutableNodeArray];
                        //移走robot要出的牌
                        [self moveRobotCardsWithNodeArray:mutableNodeArray];
                        //更新上一手机器人出的牌
                        [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:mutableCardArray];
                        
                        [self.jiqiCardArray removeObjectsInArray:mutableCardArray];
                        [self.jiqiNodeArray removeObjectsInArray:mutableNodeArray];
                        
                        //更新robot手牌布局
                        [self updateRobotNodeBuju];
                        break;
                    }
                }
            }
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起三带一");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_SanDaiDui:
        {
            XZCardModel * model = myShowCardsArray[2];
            BOOL canShow = NO;
            
            for (int i = 0; i+2<self.jiqiCardArray.count; i++) {
                if (canShow) {
                    break;
                }
                XZCardModel * modelOne = self.jiqiCardArray[i];
                XZCardModel * modelTwo = self.jiqiCardArray[i+1];
                XZCardModel * modelThree = self.jiqiCardArray[i+2];
                if (modelOne.grade == modelTwo.grade && modelOne.grade == modelThree.grade && modelOne.grade > model.grade){
                    for (int j = 0; j+1<self.jiqiCardArray.count; j++) {
                        XZCardModel * model1 = self.jiqiCardArray[j];
                        XZCardModel * model2 = self.jiqiCardArray[j+1];
                        if (model1.grade == model2.grade && model1.grade != modelOne.grade) {
                            canShow = YES;
                            
                            //更新桌上的牌
                            [self.jiqiZhuoShangNodeArray removeAllObjects];
                            [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 3)]];
                            [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                            //冒泡排序
                            for (int a=0; a<self.jiqiZhuoShangNodeArray.count; a++) {
                                for (int b=0; b<self.jiqiZhuoShangNodeArray.count-1-a; b++) {
                                    SKSpriteNode * node1 = self.jiqiZhuoShangNodeArray[b];
                                    SKSpriteNode * node2 = self.jiqiZhuoShangNodeArray[b+1];
                                    if (node1.position.x > node2.position.x) {
                                        [self.jiqiZhuoShangNodeArray exchangeObjectAtIndex:b withObjectAtIndex:b+1];
                                    }
                                }
                            }
                            
                            //更新机器人上一轮出的牌
                            [self.prevShowCardArray removeAllObjects];
                            [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 3)]];
                            [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                            //移动robot要出的牌
                            [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                            //更新机器人cardArray和nodeArray
                            [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                            [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                            //更新机器人手牌布局
                            [self updateRobotNodeBuju];
                            break;
                        }
                    }
                }
            }
            
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起三带一");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_SunZi:
        {
            XZCardModel * model = myShowCardsArray[0];
            BOOL canShow = NO;
            for (int i=0; i<self.jiqiCardArray.count; i++) {
                if (canShow) {
                    break;
                }
                XZCardModel * model1 = self.jiqiCardArray[i];
                if (model1.grade > model.grade) {
                    for (int j=0; j<self.jiqiCardArray.count; j++) {
                        if (canShow) {
                            break;
                        }
                        XZCardModel * model2 = self.jiqiCardArray[j];
                        if (model2.grade-model1.grade==1) {
                            for (int m=0; m<self.jiqiCardArray.count; m++) {
                                if (canShow) {
                                    break;
                                }
                                XZCardModel * model3 = self.jiqiCardArray[m];
                                if (model3.grade-model2.grade==1) {
                                    for (int n=0; n<self.jiqiCardArray.count; n++) {
                                        if (canShow) {
                                            break;
                                        }
                                        XZCardModel * model4 = self.jiqiCardArray[n];
                                        if (model4.grade-model3.grade==1) {
                                            for (int x=0; x<self.jiqiCardArray.count; x++) {
                                                if (canShow) {
                                                    break;
                                                }
                                                XZCardModel * model5 = self.jiqiCardArray[x];
                                                if (model5.grade-model4.grade==1 && model5.grade<=14) {
                                                    if (myShowCardsArray.count == 5) {
                                                        canShow = YES;
                                                        
                                                        //更新桌上的牌
                                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                        //更新机器人上一轮出的牌
                                                        [self.prevShowCardArray removeAllObjects];
                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                        //移动robot要出的牌
                                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                        //更新机器人cardArray和nodeArray
                                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                        //更新robot手牌布局
                                                        [self updateRobotNodeBuju];
                                                        break;
                                                    }
                                                    for (int y=0; y<self.jiqiCardArray.count; y++) {
                                                        if (canShow) {
                                                            break;
                                                        }
                                                        XZCardModel * model6 = self.jiqiCardArray[y];
                                                        if (model6.grade-model5.grade==1 && model6.grade<=14) {
                                                            if (myShowCardsArray.count == 6) {
                                                                canShow = YES;
                                                                
                                                                //更新robot桌上的牌
                                                                [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[y]];
                                                                //更新robot上一轮出的牌
                                                                [self.prevShowCardArray removeAllObjects];
                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[y]];
                                                                //移动robot要出的牌
                                                                [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                //更新robot cardArray和nodeArray
                                                                [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                //更新robot手牌布局
                                                                [self updateRobotNodeBuju];
                                                                break;
                                                            }
                                                            for (int z=0; z<self.jiqiCardArray.count; z++) {
                                                                if (canShow) {
                                                                    break;
                                                                }
                                                                XZCardModel * model7 = self.jiqiCardArray[z];
                                                                if (model7.grade-model6.grade==1 && model7.grade<=14) {
                                                                    if (myShowCardsArray.count == 7) {
                                                                        canShow = YES;
                                                                        
                                                                        //更新robot桌上的牌
                                                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[y]];
                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[z]];
                                                                        //更新robot上一轮出的牌
                                                                        [self.prevShowCardArray removeAllObjects];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[y]];
                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[z]];
                                                                        //移动robot要出的牌
                                                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                        //更新robot cardArray和nodeArray
                                                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                        //更新robot手牌布局
                                                                        [self updateRobotNodeBuju];
                                                                        break;
                                                                    }
                                                                    for (int a=0; a<self.jiqiCardArray.count; a++) {
                                                                        if (canShow) {
                                                                            break;
                                                                        }
                                                                        XZCardModel * model8 = self.jiqiCardArray[a];
                                                                        if (model8.grade-model7.grade==1 && model8.grade<=14) {
                                                                            if (myShowCardsArray.count == 8) {
                                                                                canShow = YES;
                                                                                
                                                                                //更新robot桌上的牌
                                                                                [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[y]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[z]];
                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[a]];
                                                                                //更新robot上一轮出的牌
                                                                                [self.prevShowCardArray removeAllObjects];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[y]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[z]];
                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[a]];
                                                                                //移动robot要出的牌
                                                                                [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                                //更新robot cardArray和nodeArray
                                                                                [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                                [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                                //更新robot手牌布局
                                                                                [self updateRobotNodeBuju];
                                                                                break;
                                                                            }
                                                                            for (int b=0; b<self.jiqiCardArray.count; b++) {
                                                                                if (canShow) {
                                                                                    break;
                                                                                }
                                                                                XZCardModel * model9 = self.jiqiCardArray[b];
                                                                                if (model9.grade-model8.grade==1 && model9.grade<=14) {
                                                                                    if (myShowCardsArray.count == 9) {
                                                                                        canShow = YES;
                                                                                        
                                                                                        //更新robot桌上的牌
                                                                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[y]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[z]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[a]];
                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[b]];
                                                                                        //更新robot上一轮出的牌
                                                                                        [self.prevShowCardArray removeAllObjects];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[y]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[z]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[a]];
                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[b]];
                                                                                        //移动robot要出的牌
                                                                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                                        //更新robot cardArray和nodeArray
                                                                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                                        //更新robot手牌布局
                                                                                        [self updateRobotNodeBuju];
                                                                                        break;
                                                                                    }
                                                                                    for (int c=0; c<self.jiqiCardArray.count; c++) {
                                                                                        if (canShow) {
                                                                                            break;
                                                                                        }
                                                                                        XZCardModel * model10 = self.jiqiCardArray[c];
                                                                                        if (model10.grade-model9.grade==1 && model10.grade<=14) {
                                                                                            if (myShowCardsArray.count == 10) {
                                                                                                canShow = YES;
                                                                                                
                                                                                                //更新robot桌上的牌
                                                                                                [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[y]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[z]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[a]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[b]];
                                                                                                [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[c]];
                                                                                                //更新robot上一轮出的牌
                                                                                                [self.prevShowCardArray removeAllObjects];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[y]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[z]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[a]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[b]];
                                                                                                [self.prevShowCardArray addObject:self.jiqiCardArray[c]];
                                                                                                //移走robot要出的牌
                                                                                                [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                                                //更新robot cardArray和nodeArray
                                                                                                [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                                                [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                                                //更新robot手牌布局
                                                                                                [self updateRobotNodeBuju];
                                                                                                break;
                                                                                            }
                                                                                            for (int d=0; d<self.jiqiCardArray.count; d++) {
                                                                                                if (canShow) {
                                                                                                    break;
                                                                                                }
                                                                                                XZCardModel * model11 = self.jiqiCardArray[d];
                                                                                                if (model11.grade-model10.grade==1 && model11.grade<=14) {
                                                                                                    if (myShowCardsArray.count == 11) {
                                                                                                        canShow = YES;
                                                                                                        
                                                                                                        //更新robot桌上的牌
                                                                                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[i]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[j]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[m]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[n]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[x]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[y]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[z]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[a]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[b]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[c]];
                                                                                                        [self.jiqiZhuoShangNodeArray addObject:self.jiqiNodeArray[d]];
                                                                                                        //更新robot上一轮出的牌
                                                                                                        [self.prevShowCardArray removeAllObjects];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[i]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[j]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[m]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[n]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[x]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[y]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[z]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[a]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[b]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[c]];
                                                                                                        [self.prevShowCardArray addObject:self.jiqiCardArray[d]];
                                                                                                        //移动robot要出的牌
                                                                                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                                                        //更新robot cardArray和nodeArray
                                                                                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                                                        //更新机器人手牌布局
                                                                                                        [self updateRobotNodeBuju];
                                                                                                        break;
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起顺子");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_LianDui:
        {
            XZCardModel * model = myShowCardsArray[0];
            BOOL canShow = NO;
            for (int i = 0; i+1<self.jiqiCardArray.count; i++) {
                if (canShow) {
                    break;
                }
                XZCardModel * model1 = self.jiqiCardArray[i];
                XZCardModel * model2 = self.jiqiCardArray[i+1];
                if (model1.grade == model2.grade && model1.grade > model.grade){
                    for (int j = 0; j+1<self.jiqiCardArray.count; j++) {
                        if (canShow) {
                            break;
                        }
                        XZCardModel * model3 = self.jiqiCardArray[j];
                        XZCardModel * model4 = self.jiqiCardArray[j+1];
                        if (model3.grade == model4.grade && model3.grade - model1.grade == 1) {
                            for (int m = 0; m+1<self.jiqiCardArray.count; m++) {
                                if (canShow) {
                                    break;
                                }
                                XZCardModel * model5 = self.jiqiCardArray[m];
                                XZCardModel * model6 = self.jiqiCardArray[m+1];
                                if (model5.grade == model6.grade && model5.grade - model3.grade == 1){
                                    if (myShowCardsArray.count == 6) {
                                        canShow = YES;
                                        NSLog(@"管得上3连对");
                                        
                                        //更新robot桌上的牌
                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 2)]];
                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(m, 2)]];
                                        //更新robot上一轮出的牌
                                        [self.prevShowCardArray removeAllObjects];
                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 2)]];
                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(m, 2)]];
                                        //移动robot要出的牌
                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                        //更新robot cardArray和nodeArray
                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                        //更新robot手牌布局
                                        [self updateRobotNodeBuju];
                                        break;
                                    }
                                    for (int n=0; n+1<self.jiqiCardArray.count; n++) {
                                        if (canShow) {
                                            break;
                                        }
                                        XZCardModel * model7 = self.jiqiCardArray[n];
                                        XZCardModel * model8 = self.jiqiCardArray[n+1];
                                        if (model7.grade == model8.grade && model7.grade - model5.grade == 1){
                                            if (myShowCardsArray.count == 8) {
                                                canShow = YES;
                                                NSLog(@"管得上4连对");
                                                
                                                //更新robot桌上的牌
                                                [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                //更新robot上一轮出的牌
                                                [self.prevShowCardArray removeAllObjects];
                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                //移动robot要出的牌
                                                [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                //更新机器人cardArray和nodeArray
                                                [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                //更新robot手牌布局
                                                [self updateRobotNodeBuju];
                                                break;
                                            }
                                            for (int a=0; a+1<self.jiqiCardArray.count; a++) {
                                                if (canShow) {
                                                    break;
                                                }
                                                XZCardModel * model9 = self.jiqiCardArray[a];
                                                XZCardModel * model10 = self.jiqiCardArray[a+1];
                                                if (model9.grade == model10.grade && model9.grade - model7.grade == 1){
                                                    if (myShowCardsArray.count == 10) {
                                                        canShow = YES;
                                                        NSLog(@"管得上5连对");
                                                        
                                                        //更新robot桌上的牌
                                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                        //更新robot上一轮出的牌
                                                        [self.prevShowCardArray removeAllObjects];
                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                        //移动robot要出的牌
                                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                        //更新robot cardArray和nodeArray
                                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                        //更新robot手牌布局
                                                        [self updateRobotNodeBuju];
                                                        break;
                                                    }
                                                    for (int b=0; b+1<self.jiqiCardArray.count; b++) {
                                                        if (canShow) {
                                                            break;
                                                        }
                                                        XZCardModel * model11 = self.jiqiCardArray[b];
                                                        XZCardModel * model12 = self.jiqiCardArray[b+1];
                                                        if (model11.grade == model12.grade && model11.grade - model9.grade == 1){
                                                            if (myShowCardsArray.count == 12) {
                                                                canShow = YES;
                                                                NSLog(@"管得上6连对");
                                                                
                                                                //更新robot桌上的牌
                                                                [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(b, 2)]];
                                                                //更新robot上一轮出的牌
                                                                [self.prevShowCardArray removeAllObjects];
                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(b, 2)]];
                                                                
                                                                //移动robot要出的牌
                                                                [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                //更新robot cardArray和nodeArray
                                                                [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                //更新robot手牌布局
                                                                [self updateRobotNodeBuju];
                                                                break;
                                                            }
                                                            for (int c=0; c+1<self.jiqiCardArray.count; c++) {
                                                                if (canShow) {
                                                                    break;
                                                                }
                                                                XZCardModel * model13 = self.jiqiCardArray[c];
                                                                XZCardModel * model14 = self.jiqiCardArray[c+1];
                                                                if (model13.grade == model14.grade && model13.grade - model11.grade == 1){
                                                                    if (myShowCardsArray.count == 12) {
                                                                        canShow = YES;
                                                                        NSLog(@"管得上7连对");
                                                                        
                                                                        //更新robot桌上的牌
                                                                        [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(b, 2)]];
                                                                        [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(c, 2)]];
                                                                        //更新robot上一轮出的牌
                                                                        [self.prevShowCardArray removeAllObjects];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(b, 2)]];
                                                                        [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(c, 2)]];
                                                                        
                                                                        //移动robot要出的牌
                                                                        [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                        //更新robot cardArray和nodeArray
                                                                        [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                        [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                        //更新robot手牌布局
                                                                        [self updateRobotNodeBuju];
                                                                        break;
                                                                    }
                                                                    for (int d=0; d+1<self.jiqiCardArray.count; d++) {
                                                                        XZCardModel * model15 = self.jiqiCardArray[d];
                                                                        XZCardModel * model16 = self.jiqiCardArray[d+1];
                                                                        if (model15.grade == model16.grade && model15.grade - model13.grade == 1){
                                                                            if (myShowCardsArray.count == 16) {
                                                                                canShow = YES;
                                                                                NSLog(@"管得上8连对");
                                                                                
                                                                                //更新robot桌上的牌
                                                                                [self.jiqiZhuoShangNodeArray removeAllObjects];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(b, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(c, 2)]];
                                                                                [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(d, 2)]];
                                                                                //更新robot上一轮出的牌
                                                                                [self.prevShowCardArray removeAllObjects];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(j, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(m, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(n, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(a, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(b, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(c, 2)]];
                                                                                [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(d, 2)]];
                                                                                
                                                                                //移动robot要出的牌
                                                                                [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                                                                                //更新robot cardArray和nodeArray
                                                                                [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                                                                                [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                                                                                //更新robot手牌布局
                                                                                [self updateRobotNodeBuju];
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起连对");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_FeiJiBuDai:
        {
            BOOL canShow = NO;
            XZCardModel * model = myShowCardsArray[0];
            for (int i=0; i+5<self.jiqiCardArray.count; i++) {
                XZCardModel * model1 = self.jiqiCardArray[i];
                XZCardModel * model2 = self.jiqiCardArray[i+1];
                XZCardModel * model3 = self.jiqiCardArray[i+2];
                XZCardModel * model4 = self.jiqiCardArray[i+3];
                XZCardModel * model5 = self.jiqiCardArray[i+4];
                XZCardModel * model6 = self.jiqiCardArray[i+5];
                if (model1.grade==model2.grade && model1.grade==model3.grade && model4.grade==model5.grade && model4.grade==model6.grade && model4.grade-model3.grade==1 && model1.grade>model.grade) {
                    canShow = YES;
                    
                    //更新robot桌上的牌
                    [self.jiqiZhuoShangNodeArray removeAllObjects];
                    [self.jiqiZhuoShangNodeArray addObjectsFromArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 6)]];
                    //更新robot上一轮出的牌
                    [self.prevShowCardArray removeAllObjects];
                    [self.prevShowCardArray addObjectsFromArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 6)]];
                    //移动robot要出的牌
                    [self moveRobotCardsWithNodeArray:self.jiqiZhuoShangNodeArray];
                    //更新robot cardArray和nodeArray
                    [self.jiqiCardArray removeObjectsInArray:self.prevShowCardArray];
                    [self.jiqiNodeArray removeObjectsInArray:self.jiqiZhuoShangNodeArray];
                    //更新robot手牌布局
                    [self updateRobotNodeBuju];
                    break;
                }
            }
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起飞机不带");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_FeiJiDaiDanZhang:
        {
            BOOL canShow = NO;
            XZCardModel * model = myShowCardsArray[2];
            for (int i = 0; i+5<self.jiqiCardArray.count; i++) {
                XZCardModel * model1 = self.jiqiCardArray[i];
                XZCardModel * model2 = self.jiqiCardArray[i+1];
                XZCardModel * model3 = self.jiqiCardArray[i+2];
                XZCardModel * model4 = self.jiqiCardArray[i+3];
                XZCardModel * model5 = self.jiqiCardArray[i+4];
                XZCardModel * model6 = self.jiqiCardArray[i+5];
                if (model1.grade==model2.grade && model1.grade==model3.grade && model4.grade==model5.grade && model4.grade==model6.grade && model1.grade>model.grade) {
                    if (self.jiqiCardArray.count>=8) {
                        canShow = YES;
                        if (i<=2) {
                            [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:8];
                        }else{
                            NSMutableArray * mutableNodeArray = [NSMutableArray arrayWithArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 6)]];
                            [mutableNodeArray insertObjects:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(0, 2)] atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
                            
                            NSMutableArray * mutableCardArray = [NSMutableArray arrayWithArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 6)]];
                            [mutableCardArray insertObjects:[self.jiqiCardArray subarrayWithRange:NSMakeRange(0, 2)] atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
                            
                            [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:mutableNodeArray];
                            //移动robot要出的牌
                            [self moveRobotCardsWithNodeArray:mutableNodeArray];
                            //更新上一手robot出的牌
                            [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:mutableCardArray];
                            
                            [self.jiqiCardArray removeObjectsInArray:mutableCardArray];
                            [self.jiqiNodeArray removeObjectsInArray:mutableNodeArray];
                            
                            //更新robot手牌布局
                            [self updateRobotNodeBuju];
                            break;
                        }
                    }
                }
            }
            
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起飞机不带");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_FeiJiDaiDuiZi:
        {
            BOOL canShow = NO;
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            //            if (!canShow) {
            //                NSLog(@"机器人要不起飞机带对子");
            //                [self.prevShowCardArray removeAllObjects];
            //            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_SiDaiLiangDanZhang:
        {
            BOOL canShow = NO;
            XZCardModel * model = myShowCardsArray[2];
            for (int i = 0; i+3<self.jiqiCardArray.count; i++) {
                XZCardModel * model1 = self.jiqiCardArray[i];
                XZCardModel * model2 = self.jiqiCardArray[i+1];
                XZCardModel * model3 = self.jiqiCardArray[i+2];
                XZCardModel * model4 = self.jiqiCardArray[i+3];
                if (model1.grade==model2.grade && model1.grade==model3.grade && model1.grade==model4.grade && model1.grade>model.grade) {
                    if (self.jiqiCardArray.count>=6) {
                        canShow = YES;
                        if (i<=2) {
                            [self robotCardsAnimationWithIndex:i andWithRobotCardsNumber:6];
                        }else{
                            NSMutableArray * mutableNodeArray = [NSMutableArray arrayWithArray:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(i, 4)]];
                            [mutableNodeArray insertObjects:[self.jiqiNodeArray subarrayWithRange:NSMakeRange(0, 2)] atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
                            
                            NSMutableArray * mutableCardArray = [NSMutableArray arrayWithArray:[self.jiqiCardArray subarrayWithRange:NSMakeRange(i, 4)]];
                            [mutableCardArray insertObjects:[self.jiqiCardArray subarrayWithRange:NSMakeRange(0, 2)] atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
                            
                            [self.jiqiZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.jiqiZhuoShangNodeArray.count) withObjectsFromArray:mutableNodeArray];
                            //移动robot要出的牌
                            [self moveRobotCardsWithNodeArray:mutableNodeArray];
                            //更新上一手robot出的牌
                            [self.prevShowCardArray replaceObjectsInRange:NSMakeRange(0, self.prevShowCardArray.count) withObjectsFromArray:mutableCardArray];
                            
                            [self.jiqiCardArray removeObjectsInArray:mutableCardArray];
                            [self.jiqiNodeArray removeObjectsInArray:mutableNodeArray];
                            
                            //更新robot手牌布局
                            [self updateRobotNodeBuju];
                            break;
                        }
                    }
                }
            }
            
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            robotCanHit = canShow;
        }
            break;
        case XZPokerType_SiDaiLiangDuiZi:
        {
            BOOL canShow = NO;
            //是否有炸弹
            if (!canShow) {
                canShow = [self robotZhaDanGuanShang];
            }
            //是否有王炸
            if (!canShow) {
                canShow = [self robotWangZhaGuanShang];
            }
            robotCanHit = canShow;
        }
            break;
            
        default:
            break;
    }
    
    if (self.jiqiCardArray.count == 0) {
        //闯关失败
        self.loseJieSuanView.hidden = NO;
        self.userInteractionEnabled = NO;
        [[XZMusicPlayManager shareManager] gameLoseMusicPlay];
    }else{
        if (robotCanHit) {
            //显示出牌、不出或者要不起
            if ([self myCardCanHitRobotShowCard:self.prevShowCardArray]) {
                //我的牌能管上
                [self buttonPositionWithType:1];
            }else{
                [self buttonPositionWithType:3];
            }
            
            if (self.jiqiZhuoShangNodeArray.count>1) {
                [[XZMusicPlayManager shareManager] duoZhangMusicPlay];
            }else{
                [[XZMusicPlayManager shareManager] danZhangMusicPlay];
            }
        }else{
            //显示出牌
            NSLog(@"机器人要不起");
//            if (![XZGET_CACHE(DDZ_SET_GameMusic) isEqualToString:@"XZ_Off"]){
//                [[DDZBackgroundMusic shareBackgroundMusic] buYaoMusicPlay];
//            }
            [self.prevShowCardArray removeAllObjects];
            [self buttonPositionWithType:2];
        }
    }
}


    
    

#pragma mark - action
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKNode * node;
    for (UITouch * touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        node = [self nodeAtPoint:touchLocation];
    }
    
    if ([self.wodeNodeArray containsObject:node]) {
        CGFloat height = Auto_Height(20)+BIGCARDHEIGHT/2;
        if (node.position.y - height < 1) {
            [self.wodeWillShowNodeArray addObject:node];
            SKAction * action = [SKAction moveTo:CGPointMake(node.position.x, Auto_Height(20)+BIGCARDHEIGHT/2+PAIUP) duration:0.1];
            [node runAction:action];
            for (XZCardModel * model in self.wodeCardArray) {
                if ([node.name isEqualToString:model.imageName]) {
                    [self.wodeWillShowCardArray addObject:model];
                }
            }
        }else{
            [self.wodeWillShowNodeArray removeObject:node];
            SKAction * action = [SKAction moveTo:CGPointMake(node.position.x, Auto_Height(20)+BIGCARDHEIGHT/2) duration:0.1];
            [node runAction:action];
            for (XZCardModel * model in self.wodeCardArray) {
                if ([node.name isEqualToString:model.imageName]) {
                    [self.wodeWillShowCardArray removeObject:model];
                }
            }
        }
        [[XZMusicPlayManager shareManager] xuanPaiMusicPlay];
    }
    
    if ([node.name isEqualToString:@"determine"]) {
        [self clickDetermine];
    }
    
    if ([node.name isEqualToString:@"pass"]) {
        [self clickPass];
    }
    
    if ([node.name isEqualToString:@"fanHui"]) {
        [self clickFanHui];
    }
    
    if ([node.name isEqualToString:@"sheZhi"]) {
        [self clickSheZhi];
    }
}

//点击返回
-(void)clickFanHui
{
    [[XZMusicPlayManager shareManager] anNiuMusicPlay];
    self.userInteractionEnabled = NO;
    XZWeakSelf
//    [self.popupView AddStarViewWithTitle:@"您確定要放棄本場考試嗎？" block:^(BOOL isSuc) {
//        if (isSuc) {
//            weakSelf.exitTheSceneBlock();
//        }else{
//            weakSelf.userInteractionEnabled = YES;
//        }
//        weakSelf.popupView = nil;
//    }];
    
    [self.popupView AddRemindTest:@"Are you sure you want to leave this game?" titleStr:@"Remind" block:^(BOOL isSuc) {
        if (isSuc) {
            weakSelf.exitTheSceneBlock();
        }else{
            weakSelf.userInteractionEnabled = YES;
        }
        weakSelf.popupView = nil;
    }];
}

//点击设置
-(void)clickSheZhi
{
    [[XZMusicPlayManager shareManager] anNiuMusicPlay];
    [[XZClassView shareClient] showSetViewBlock:^{
        
    }];
}

//点击不出后
-(void)clickPass
{
    self.userInteractionEnabled = NO;
    [[XZMusicPlayManager shareManager] anNiuMusicPlay];
    [self buttonPositionWithType:4];
    for (SKNode * node in self.wodeWillShowNodeArray) {
        SKAction * action = [SKAction moveTo:CGPointMake(node.position.x, Auto_Height(20)+BIGCARDHEIGHT/2) duration:0.1];
        [node runAction:action];
    }
    [self.wodeWillShowNodeArray removeAllObjects];
    [self.wodeWillShowCardArray removeAllObjects];
    //点不要后机器人出牌
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        [self robotResponseMeBuChu];
        if ([self myCardCanHitRobotShowCard:self.prevShowCardArray]) {
            //我的牌能管上
            [self buttonPositionWithType:1];
        }else{
            [self buttonPositionWithType:3];
        }
    });
}

-(void)buttonPositionWithType:(NSInteger)type
{
    switch (type) {
        case 1://出牌，不出
        {
            self.playHandNode.hidden = NO;
            self.noPlayHandNode.hidden = NO;
            self.playHandNode.position = CGPointMake(self.beijingNode.position.x+Auto_Width(20)+110/2, Auto_Height(20+57)+BIGCARDHEIGHT+44/2);
            self.noPlayHandNode.position = CGPointMake(self.beijingNode.position.x-Auto_Width(20)-110/2, Auto_Height(20+57)+BIGCARDHEIGHT+44/2);
        }
            break;
        case 2://出牌
        {
            self.playHandNode.hidden = NO;
            self.noPlayHandNode.hidden = YES;
            self.playHandNode.position = CGPointMake(self.beijingNode.position.x, Auto_Height(20+57)+BIGCARDHEIGHT+44/2);
        }
            break;
        case 3://不出
        {
            self.playHandNode.hidden = YES;
            self.noPlayHandNode.hidden = NO;
            self.noPlayHandNode.position = CGPointMake(self.beijingNode.position.x, Auto_Height(20+57)+BIGCARDHEIGHT+44/2);
        }
            break;
        case 4://
        {
            self.playHandNode.hidden = YES;
            self.noPlayHandNode.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

//点击出牌后
-(void)clickDetermine
{
    //播放点击按钮音效
    [[XZMusicPlayManager shareManager] anNiuMusicPlay];
    if ([[XZPokerCardTool sharePokerTool] isCanShowMyCards:self.wodeWillShowCardArray andPrevCards:self.prevShowCardArray]) {
        //能管上时用户在机器人响应前不能点牌
        self.userInteractionEnabled = NO;
        //播放出牌音效
        if (self.wodeWillShowCardArray.count == 1) {
            [[XZMusicPlayManager shareManager] danZhangMusicPlay];
        }else{
            [[XZMusicPlayManager shareManager] duoZhangMusicPlay];
        }
        //隐藏出牌、不出等按钮
        [self buttonPositionWithType:4];
        //移除robot桌上的牌
        [self removeRobotZhuoShangNodePai];
        //移除自己桌上的牌
        [self removeMyZhuoShangNodePai];
        //移动出掉牌
        CGFloat outPointx = (self.size.width-SPACESMALL*(self.wodeWillShowNodeArray.count-1)-SMALLCARDWIDE)/2;
        //出去的牌按位置从左到右排序
        //冒泡排序
        for (int i=0; i<self.wodeWillShowNodeArray.count; i++) {
            for (int j=0; j<self.wodeWillShowNodeArray.count-1-i; j++) {
                SKSpriteNode * node1 = self.wodeWillShowNodeArray[j];
                SKSpriteNode * node2 = self.wodeWillShowNodeArray[j+1];
                if (node1.position.x > node2.position.x) {
                    [self.wodeWillShowNodeArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
        }
        
        for (int i = 0; i<self.wodeWillShowNodeArray.count; i++) {
            SKNode * node = self.wodeWillShowNodeArray[i];
            SKAction * moveAction = [SKAction moveTo:CGPointMake(outPointx+SMALLCARDWIDE/2+SPACESMALL*i, Auto_Height(20)+BIGCARDHEIGHT+Auto_Height(10)+SMALLCARDHEIGHT/2) duration:0.1];
            SKAction * scaleAction = [SKAction scaleTo:0.75 duration:0.1];
            [node runAction:[SKAction group:@[moveAction,scaleAction]]];
        }
        
        //我的桌上的牌
        [self.wodeZhuoShangNodeArray replaceObjectsInRange:NSMakeRange(0, self.wodeZhuoShangNodeArray.count) withObjectsFromArray:self.wodeWillShowNodeArray];
        
        
        [self.wodeCardArray removeObjectsInArray:self.wodeWillShowCardArray];
        [self.wodeNodeArray removeObjectsInArray:self.wodeWillShowNodeArray];
        if (self.wodeCardArray.count == 0) {//过关
            self.winJieSuanView.hidden = NO;
            self.userInteractionEnabled = NO;
            //播放过关音效
            [[XZMusicPlayManager shareManager] gameWinMusicPlay];
            NSInteger choiceNumber = [AppDelegate shareDelegate].paipuNumber;
            NSInteger currentNuber = [XZGET_CACHE(XZ_CURRENT_NUMBER) integerValue];
            if (choiceNumber == currentNuber) {
                NSString * guanka = [NSString stringWithFormat:@"%ld",[AppDelegate shareDelegate].paipuNumber+1];
                XZSET_CACHE(guanka, XZ_CURRENT_NUMBER)
            }
        }else{
            //更新我的手牌布局
            [self updateMyNodeBuju];
            //机器人响应我的出牌
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showRobotCardsWithMyShowCards:self.wodeWillShowCardArray];
                self.userInteractionEnabled = YES;
                [self.wodeWillShowNodeArray removeAllObjects];
                [self.wodeWillShowCardArray removeAllObjects];
            });
        }
    }else{
        NSLog(@"牌型不符合规则~");
        for (SKNode * node in self.wodeWillShowNodeArray) {
            SKAction * action = [SKAction moveTo:CGPointMake(node.position.x, Auto_Height(20)+BIGCARDHEIGHT/2) duration:0.1];
            [node runAction:action];
        }
        [self.wodeWillShowNodeArray removeAllObjects];
        [self.wodeWillShowCardArray removeAllObjects];
    }
}

#pragma mark - get
-(SKSpriteNode *)beijingNode
{
    if (!_beijingNode) {
        _beijingNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:IS_IPhoneX_All?@"game_beiJing_X":@"game_beiJing"]];
        _beijingNode.name = @"backgroud";
        _beijingNode.size = CGSizeMake(self.size.width, self.size.height);
        _beijingNode.position = CGPointMake(_beijingNode.size.width/2, _beijingNode.size.height/2);
    }
    return _beijingNode;
}

-(SKSpriteNode *)goBackNode
{
    if (!_goBackNode) {
        _goBackNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_fanHui"]];
        _goBackNode.name = @"fanHui";
        _goBackNode.size = CGSizeMake(100/2, 72/2);
        _goBackNode.position = CGPointMake(Auto_Width(10)+100/4, KScreenHeight-Auto_Height(20)-72/4-XZNavigation_TopHeight);
    }
    return _goBackNode;
}

-(SKSpriteNode *)settingNode
{
    if (!_settingNode) {
        _settingNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_sheZhi"]];
        _settingNode.name = @"sheZhi";
        _settingNode.size = CGSizeMake(100/2, 74/2);
        _settingNode.position = CGPointMake(100/2+Auto_Width(25)+100/4, KScreenHeight-Auto_Height(21)-76/4-XZNavigation_TopHeight);
    }
    return _settingNode;
}

-(SKSpriteNode *)tiLiNode
{
    if (!_tiLiNode) {
        _tiLiNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_tiLi"]];
        _tiLiNode.name = @"tiLi";
        _tiLiNode.size = CGSizeMake(253/2, 80/2);
        _tiLiNode.position = CGPointMake(KScreenWidth-Auto_Width(10)-253/4, KScreenHeight-Auto_Height(36/2)-80/4-XZNavigation_TopHeight);
    }
    return _tiLiNode;
}

-(UILabel *)tiLiValueLabel
{
    if (!_tiLiValueLabel) {
        _tiLiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth-Auto_Width(10)-253/4-8,Auto_Height(36/2)+XZNavigation_TopHeight, 100, 80/2)];
        _tiLiValueLabel.textAlignment = NSTextAlignmentLeft;
        _tiLiValueLabel.text = [NSString stringWithFormat:@"%ld",[[TimeDownObj shareClient] counDownStars]];
        [_tiLiValueLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        _tiLiValueLabel.textColor = UIColorFromRGB(0xffffff);
        [self.view addSubview:_tiLiValueLabel];
    }
    return _tiLiValueLabel;
}

-(SKSpriteNode *)ETNode
{
    if (!_ETNode) {
        _ETNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_ET"]];
        _ETNode.size = CGSizeMake(143/2, 220/2);
        _ETNode.position = CGPointMake(self.beijingNode.position.x, self.size.height-Auto_Height(146/2)-220/4-XZNavigation_TopHeight);
    }
    return _ETNode;
}

-(SKSpriteNode *)playHandNode
{
    if (!_playHandNode) {
        _playHandNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_Determine"]];
        _playHandNode.name = @"determine";
        _playHandNode.size = CGSizeMake(110, 44);
        _playHandNode.position = CGPointMake(self.beijingNode.position.x+Auto_Width(20)+110/2, Auto_Height(20+57)+BIGCARDHEIGHT+44/2);
    }
    return _playHandNode;
}

-(SKSpriteNode *)noPlayHandNode
{
    if (!_noPlayHandNode) {
        _noPlayHandNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"game_Pass"]];
        _noPlayHandNode.name = @"pass";
        _noPlayHandNode.size = CGSizeMake(110, 44);
        _noPlayHandNode.position = CGPointMake(self.beijingNode.position.x-Auto_Width(20)-110/2, Auto_Height(20+57)+BIGCARDHEIGHT+44/2);
    }
    return _noPlayHandNode;
}

-(SKSpriteNode *)gameBeginNode
{
    if (!_gameBeginNode) {
        _gameBeginNode = [[SKSpriteNode alloc] init];
        _gameBeginNode.size = CGSizeMake(KScreenWidth, 733*KScreenWidth/750);
        _gameBeginNode.position = CGPointMake(self.beijingNode.position.x, KScreenHeight-733*KScreenWidth/1500);
        
        NSArray * array = @[[SKTexture textureWithImageNamed:@"gameBegin_1"],[SKTexture textureWithImageNamed:@"gameBegin_2"],[SKTexture textureWithImageNamed:@"gameBegin_3"],[SKTexture textureWithImageNamed:@"gameBegin_4"],[SKTexture textureWithImageNamed:@"gameBegin_5"],[SKTexture textureWithImageNamed:@"gameBegin_6"],[SKTexture textureWithImageNamed:@"gameBegin_7"],[SKTexture textureWithImageNamed:@"gameBegin_8"],[SKTexture textureWithImageNamed:@"gameBegin_9"],[SKTexture textureWithImageNamed:@"gameBegin_10"],[SKTexture textureWithImageNamed:@"gameBegin_11"]];
        SKAction * animationAction = [SKAction animateWithTextures:array timePerFrame:2.0/11];
        XZWeakSelf
        [_gameBeginNode runAction:animationAction completion:^{
            [weakSelf.gameBeginNode removeFromParent];
            [weakSelf dealCard];
        }];
    }
    return _gameBeginNode;
}

-(XZJieSuanView *)winJieSuanView
{
    if (!_winJieSuanView) {
        _winJieSuanView = [[XZJieSuanView alloc] init];
        _winJieSuanView.GYImageView.image = XZImageName(@"GY_win");
        _winJieSuanView.GXOneImageView.image = XZImageName(@"GXOne_win");
        _winJieSuanView.GXTwoImageView.image = XZImageName(@"GXTwo_win");
        _winJieSuanView.winLoseImgeView.image = XZImageName(@"YouWin");
        [_winJieSuanView.rightButton setImage:XZImageName(@"Nextlevel") forState:UIControlStateNormal];
        _winJieSuanView.winStarImageView.hidden = NO;
        XZWeakSelf;
        _winJieSuanView.clickLeftButtonBlock = ^{
            NSLog(@"退出游戏");
            weakSelf.exitTheSceneBlock();
        };
        _winJieSuanView.clickRightButtonBlock = ^{
            NSLog(@"下一关");
            weakSelf.exitTheSceneBlock();
        };
        [self.view addSubview:_winJieSuanView];
        [_winJieSuanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _winJieSuanView;
}

-(XZJieSuanView *)loseJieSuanView
{
    if (!_loseJieSuanView) {
        _loseJieSuanView = [[XZJieSuanView alloc] init];
        XZWeakSelf;
        _loseJieSuanView.clickLeftButtonBlock = ^{
            NSLog(@"退出游戏");
            weakSelf.exitTheSceneBlock();
        };
        _loseJieSuanView.clickRightButtonBlock = ^{
            NSLog(@"重新挑战");
            weakSelf.exitTheSceneBlock();
        };
        [self.view addSubview:_loseJieSuanView];
        [_loseJieSuanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _loseJieSuanView;
}

-(XZPpView *)popupView
{
    if (!_popupView) {
        _popupView = [[XZPpView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_popupView];
    }
    return _popupView;
}

-(NSMutableArray *)wodeNodeArray
{
    if (!_wodeNodeArray) {
        _wodeNodeArray = [NSMutableArray array];
    }
    return _wodeNodeArray;
}

-(NSMutableArray *)jiqiNodeArray
{
    if (!_jiqiNodeArray) {
        _jiqiNodeArray = [NSMutableArray array];
    }
    return _jiqiNodeArray;
}

-(NSMutableArray *)wodeWillShowCardArray
{
    if (!_wodeWillShowCardArray) {
        _wodeWillShowCardArray = [NSMutableArray array];
    }
    return _wodeWillShowCardArray;
}

-(NSMutableArray *)wodeWillShowNodeArray
{
    if (!_wodeWillShowNodeArray) {
        _wodeWillShowNodeArray = [NSMutableArray array];
    }
    return _wodeWillShowNodeArray;
}

-(NSMutableArray *)prevShowCardArray
{
    if (!_prevShowCardArray) {
        _prevShowCardArray = [NSMutableArray array];
    }
    return _prevShowCardArray;
}

-(NSMutableArray *)wodeZhuoShangNodeArray
{
    if (!_wodeZhuoShangNodeArray) {
        _wodeZhuoShangNodeArray = [NSMutableArray array];
    }
    return _wodeZhuoShangNodeArray;
}

-(NSMutableArray *)jiqiZhuoShangNodeArray
{
    if (!_jiqiZhuoShangNodeArray) {
        _jiqiZhuoShangNodeArray = [NSMutableArray array];
    }
    return _jiqiZhuoShangNodeArray;
}
@end

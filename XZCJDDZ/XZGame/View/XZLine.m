//
//  XZLine.m
//  XZCJDDZ
//
//  Created by jjj on 2019/9/24.
//  Copyright © 2019 dub. All rights reserved.
//

#import "XZLine.h"
#import "XZMapButton.h"

@interface XZLine ()

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*lineArrayM;

@end

@implementation XZLine

-(void)DrawDottedLineWithCurNum:(NSInteger)currentNum fromView:(UIView *)fromView everyPArrayM:(NSMutableArray *)everyPArrayM
{
    UIScrollView *viewS = (UIScrollView *)fromView;
    if (self.lineArrayM.count > 0) {
        [self.lineArrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAShapeLayer *dotteShapeLayer = (CAShapeLayer *)obj;
            [dotteShapeLayer removeFromSuperlayer];
        }];
        [self.lineArrayM removeAllObjects];
    }

    NSInteger curNum = [XZGET_CACHE(XZ_CURRENT_NUMBER) integerValue] ? : 0;
//    NSInteger curNum = 12;
    for (int i = 0; i < everyPArrayM.count; i++) {
        
        if (i < 11) {
            
            XZMapButton *btn = (XZMapButton *)everyPArrayM[i];
            XZMapButton *btn2 = (XZMapButton *)everyPArrayM[i+1];

            CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
            CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
            //设置虚线颜色为
            if (i < curNum) {//设置当前关卡颜色
                [dotteShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
            }else{
                [dotteShapeLayer setStrokeColor:[[UIColor grayColor] CGColor]];
            }
            //设置虚线宽度
            dotteShapeLayer.lineWidth = 2.0f ;
            //10=线的宽度 5=每条线的间距
            NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
            [dotteShapeLayer setLineDashPattern:dotteShapeArr];
            CGPathMoveToPoint(dotteShapePath, NULL, btn.center.x ,btn.center.y);
            CGPathAddLineToPoint(dotteShapePath, NULL, btn2.center.x, btn2.center.y);
            [dotteShapeLayer setPath:dotteShapePath];
            CGPathRelease(dotteShapePath);
            
            [fromView.layer addSublayer:dotteShapeLayer];
            [self.lineArrayM addObject:dotteShapeLayer];
            [viewS bringSubviewToFront:btn];
            
        }
        
        if (i == 11) {
            XZMapButton *btn3 = (XZMapButton *)everyPArrayM[11];
            [viewS bringSubviewToFront:btn3];
        }
        
        if (i > 11 && (i < 21)) {
            
            XZMapButton *btn = (XZMapButton *)everyPArrayM[i];
            XZMapButton *btn2 = (XZMapButton *)everyPArrayM[i+1];
            
            CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
            CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
            //设置虚线颜色为
            if (i < curNum) {//设置当前关卡颜色
                [dotteShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
            }else{
                [dotteShapeLayer setStrokeColor:[[UIColor grayColor] CGColor]];
            }
            //设置虚线宽度
            dotteShapeLayer.lineWidth = 2.0f ;
            //10=线的宽度 5=每条线的间距
            NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
            [dotteShapeLayer setLineDashPattern:dotteShapeArr];
            CGPathMoveToPoint(dotteShapePath, NULL, btn.center.x ,btn.center.y);
            CGPathAddLineToPoint(dotteShapePath, NULL, btn2.center.x, btn2.center.y);
            [dotteShapeLayer setPath:dotteShapePath];
            CGPathRelease(dotteShapePath);
            
            [fromView.layer addSublayer:dotteShapeLayer];
            [self.lineArrayM addObject:dotteShapeLayer];
            
            [viewS bringSubviewToFront:btn];
            
        }
        
        if (i == 21) {
            XZMapButton *btn4 = (XZMapButton *)everyPArrayM[21];
            [viewS bringSubviewToFront:btn4];
        }
        
    }
    
}

-(NSMutableArray *)lineArrayM
{
    if (!_lineArrayM) {
        _lineArrayM = [NSMutableArray array];
    }
    return _lineArrayM;
}

@end
